#!/usr/bin/env python3
"""Export every page in a Draw.io activity-diagram file."""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path
from xml.etree import ElementTree


INVALID_FILENAME_CHARS = re.compile(r'[<>:"/\\|?*\x00-\x1f]')


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export all Draw.io pages using each page name as filename."
    )
    parser.add_argument(
        "source",
        type=Path,
        nargs="?",
        default=Path(__file__).with_name("activity_rest_updated.drawio.xml"),
        help="Draw.io XML file to export",
    )
    parser.add_argument(
        "-o",
        "--output-dir",
        type=Path,
        default=Path(__file__).with_name("exports"),
        help="Output directory (default: diagram/activity/exports)",
    )
    parser.add_argument(
        "--format",
        choices=("png", "svg", "pdf"),
        default="png",
        help="Export format (default: png)",
    )
    parser.add_argument(
        "--drawio",
        default="drawio",
        help="Draw.io executable or path (default: drawio)",
    )
    return parser.parse_args()


def safe_filename(page_name: str) -> str:
    cleaned = INVALID_FILENAME_CHARS.sub("_", page_name).strip().rstrip(".")
    return cleaned or "untitled"


def get_page_names(source: Path) -> list[str]:
    try:
        root = ElementTree.parse(source).getroot()
    except ElementTree.ParseError as error:
        raise ValueError(f"Invalid Draw.io XML: {source}") from error

    names = [page.get("name", "").strip() for page in root.findall("diagram")]
    if not names or any(not name for name in names):
        raise ValueError("Every diagram page must have a non-empty name.")
    return names


def output_path(output_dir: Path, page_name: str, extension: str) -> Path:
    base_name = safe_filename(page_name)
    candidate = output_dir / f"{base_name}.{extension}"
    suffix = 2
    while candidate.exists():
        candidate = output_dir / f"{base_name} ({suffix}).{extension}"
        suffix += 1
    return candidate


def export_pages(source: Path, output_dir: Path, drawio: str, export_format: str) -> None:
    if not source.is_file():
        raise FileNotFoundError(f"Source file not found: {source}")

    executable = shutil.which(drawio)
    if executable is None and Path(drawio).is_file():
        executable = drawio
    if executable is None:
        raise FileNotFoundError(
            f"Draw.io executable not found: {drawio}. "
            "Install Draw.io or pass its path with --drawio."
        )

    names = get_page_names(source)
    output_dir.mkdir(parents=True, exist_ok=True)

    for page_index, page_name in enumerate(names):
        destination = output_path(output_dir, page_name, export_format)
        command = [
            executable,
            "--export",
            f"--format={export_format}",
            f"--page-index={page_index + 1}",
            f"--output={destination}",
            str(source),
        ]
        subprocess.run(command, check=True)
        print(f"Exported: {destination}")


def main() -> int:
    args = parse_args()
    try:
        export_pages(args.source, args.output_dir, args.drawio, args.format)
    except (FileNotFoundError, ValueError, subprocess.CalledProcessError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
