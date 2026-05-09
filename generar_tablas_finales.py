from __future__ import annotations

import ast
from pathlib import Path
from typing import Iterable

import pandas as pd


BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "data"
OUTPUT_DIR = DATA_DIR / "final"


IGNORE_FILES = {"links_small.csv", "ratings_small.csv","links.csv","ratings.csv"}

# columnas a eliminar explicitamente de la tabla base
DROP_COLUMNS = {
    "movies_metadata.csv": {
        "belongs_to_collection",
        "homepage",
        "poster_path",
        "spoken_languages",
        "tagline",
        "title",
        "video",
    }
}

# columnas con lista de diccionarios a explotar
EXPLODE_COLUMNS = {
    "credits.csv": ["cast", "crew"],
    "keywords.csv": ["keywords"],
    "movies_metadata.csv": ["genres", "production_companies", "production_countries"],
}

# renombres de llaves internas de diccionarios por tabla/columna explotada
DICT_KEY_RENAMES = {
    ("credits.csv", "cast"): {"id": "person_id"},
    ("credits.csv", "crew"): {"id": "person_id"},
    ("keywords.csv", "keywords"): {"id": "keyword_id"},
    ("movies_metadata.csv", "genres"): {"id": "genre_id"},
    ("movies_metadata.csv", "production_companies"): {"id": "company_id"},
}


SKIP_BASE_TABLES = {"credits.csv", "keywords.csv"}


def parse_list_of_dicts(cell: object) -> list[dict]:
    if pd.isna(cell):
        return []
    if isinstance(cell, list):
        return [item for item in cell if isinstance(item, dict)]
    if not isinstance(cell, str):
        return []

    text = cell.strip()
    if not text:
        return []

    try:
        parsed = ast.literal_eval(text)
    except (ValueError, SyntaxError):
        return []

    if isinstance(parsed, list):
        return [item for item in parsed if isinstance(item, dict)]
    return []


def parent_id_column(df: pd.DataFrame) -> tuple[str, str]:
    # retorna (columna_origen, nombre_salida)
    if "id" in df.columns:
        return "id", "movie_id"
    if "movieId" in df.columns:
        return "movieId", "movie_id"
    raise ValueError("No se encontro columna de ID padre ('id' o 'movieId').")


def explode_to_table(
    df: pd.DataFrame,
    file_name: str,
    parent_id_source_col: str,
    parent_id_output_col: str,
    list_col: str,
) -> pd.DataFrame:
    rows: list[dict] = []
    nested_renames = DICT_KEY_RENAMES.get((file_name, list_col), {})

    for _, row in df[[parent_id_source_col, list_col]].iterrows():
        parent_id = row[parent_id_source_col]
        elements = parse_list_of_dicts(row[list_col])
        for item in elements:
            new_row = {parent_id_output_col: parent_id}
            for key, value in item.items():
                out_key = nested_renames.get(key, key)
                new_row[out_key] = value
            rows.append(new_row)
    if not rows:
        return pd.DataFrame(columns=[parent_id_output_col])
    return pd.DataFrame(rows)


def normalize_movies_metadata(df: pd.DataFrame) -> pd.DataFrame:
    # Casteos sugeridos por el usuario.
    bool_cols = ["adult"]
    int_cols = ["budget", "movie_id", "revenue", "vote_count"]
    float_cols = ["popularity", "runtime", "vote_average"]
    date_cols = ["release_date"]

    for col in bool_cols:
        if col in df.columns:
            lowered = df[col].astype("string").str.lower().str.strip()
            df[col] = lowered.map({"true": True, "false": False})

    for col in int_cols:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce").astype("Int64")

    for col in float_cols:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    for col in date_cols:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors="coerce").dt.date

    return df


def transform_file(csv_path: Path) -> Iterable[tuple[str, pd.DataFrame]]:
    file_name = csv_path.name
    df = pd.read_csv(csv_path, dtype="string", low_memory=False)

    list_columns = [c for c in EXPLODE_COLUMNS.get(file_name, []) if c in df.columns]
    parent_id_source_col, parent_id_output_col = parent_id_column(df) if list_columns else (None, None)

    # 1) crear nuevas tablas para columnas tipo lista de diccionarios
    for list_col in list_columns:
        exploded_df = explode_to_table(
            df,
            file_name=file_name,
            parent_id_source_col=parent_id_source_col,
            parent_id_output_col=parent_id_output_col,
            list_col=list_col,
        )
        yield f"{csv_path.stem}_{list_col}.csv", exploded_df

    # 2) eliminar columnas explotadas + columnas ignoradas explicitamente
    cols_to_drop = set(list_columns) | DROP_COLUMNS.get(file_name, set())
    base_df = df.drop(columns=[c for c in cols_to_drop if c in df.columns], errors="ignore")

    # renombre explicito de identificadores de pelicula para mantener relaciones claras
    if "id" in base_df.columns and file_name in {"credits.csv", "keywords.csv", "movies_metadata.csv"}:
        base_df = base_df.rename(columns={"id": "movie_id"})
    if "movieId" in base_df.columns:
        base_df = base_df.rename(columns={"movieId": "movie_id"})
    if "userId" in base_df.columns:
        base_df = base_df.rename(columns={"userId": "user_id"})

    # 3) normalizaciones especificas por tabla
    if file_name == "movies_metadata.csv":
        base_df = normalize_movies_metadata(base_df)
    elif file_name == "keywords.csv":
        if "movie_id" in base_df.columns:
            base_df["movie_id"] = pd.to_numeric(base_df["movie_id"], errors="coerce").astype("Int64")
    elif file_name == "credits.csv":
        if "movie_id" in base_df.columns:
            base_df["movie_id"] = pd.to_numeric(base_df["movie_id"], errors="coerce").astype("Int64")

    if file_name not in SKIP_BASE_TABLES:
        yield file_name, base_df


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    csv_files = sorted(p for p in DATA_DIR.glob("*.csv") if p.name not in IGNORE_FILES)
    if not csv_files:
        raise FileNotFoundError("No se encontraron CSV para procesar en data/.")

    generated: list[str] = []
    for csv_path in csv_files:
        for out_name, out_df in transform_file(csv_path):
            out_path = OUTPUT_DIR / out_name
            out_df.to_csv(out_path, index=False)
            generated.append(out_name)

    print("Archivos generados en data/final/:")
    for name in generated:
        print(f"- {name}")


if __name__ == "__main__":
    main()
