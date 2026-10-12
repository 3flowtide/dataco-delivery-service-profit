from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parent.parent
SQL_DIR = ROOT / "sql"
DB_PATH = ROOT / "dataco.duckdb"
PRINT_RESULTS_FOR = {"02_data_quality_checks.sql"}


def strip_line_comments(sql_text: str) -> str:
    lines = []
    for line in sql_text.splitlines():
        idx = line.find("--")
        lines.append(line[:idx] if idx != -1 else line)
    return "\n".join(lines)


def split_statements(sql_text: str) -> list[str]:
    cleaned = strip_line_comments(sql_text)
    return [s.strip() for s in cleaned.split(";") if s.strip()]


def run_file(con: duckdb.DuckDBPyConnection, sql_file: Path) -> None:
    print(f"\n=== Running {sql_file.name} ===")
    print_results = sql_file.name in PRINT_RESULTS_FOR
    for statement in split_statements(sql_file.read_text()):
        result = con.execute(statement)
        if print_results:
            df = result.fetchdf()
            if not df.empty:
                print(f"\n-- {statement.splitlines()[0][:80]}")
                print(df.to_string(index=False))


def main() -> None:
    con = duckdb.connect(str(DB_PATH))
    try:
        for sql_file in sorted(SQL_DIR.glob("*.sql")):
            run_file(con, sql_file)
    finally:
        con.close()
    print("\nPipeline complete.")


if __name__ == "__main__":
    main()
