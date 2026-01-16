#!/usr/bin/env python3

from __future__ import annotations

import argparse
import calendar
import datetime as dt
import json
from typing import List

SAT   = "#00FFFF"
SUN   = "#FFFF00"
TODAY = "#00FF00"

def month_block_plain(year, month, firstweekday, width, today):
    cal = calendar.Calendar(firstweekday=firstweekday)

    title_txt = f"{calendar.month_name[month]} {year}"
    title_cell = title_txt[:width].ljust(width)
    title = f"<span foreground='{TODAY}'>{title_cell}</span>" if (today.year == year and today.month == month) else title_cell

    lines = [title, "─" * width]

    if width >= 20:
        hp = []
        for i in range(7):
            w = (firstweekday + i) % 7
            s = calendar.day_abbr[w][:2]
            if w == 5: s = f"<span foreground='{SAT}'>{s}</span>"
            if w == 6: s = f"<span foreground='{SUN}'>{s}</span>"
            hp.append(s)
        header = " ".join(hp) + (" " * (width - 20))
    else:
        header = " ".join(calendar.day_abbr[(i + firstweekday) % 7][:2] for i in range(7))[:width].ljust(width)
    lines.append(header)

    for week in cal.monthdayscalendar(year, month):
        if width >= 20:
            parts = []
            for i, d in enumerate(week):
                if d == 0:
                    parts.append("  ")
                    continue

                cell = f"{d:2}"
                w = (firstweekday + i) % 7

                if (today.year == year and today.month == month and d == today.day):
                    cell = f"<span foreground='{TODAY}'>{cell}</span>"
                elif w == 5:
                    cell = f"<span foreground='{SAT}'>{cell}</span>"
                elif w == 6:
                    cell = f"<span foreground='{SUN}'>{cell}</span>"

                parts.append(cell)

            lines.append(" ".join(parts) + (" " * (width - 20)))
        else:
            lines.append(
                " ".join(("  " if d == 0 else f"{d:2}") for d in week)[:width].ljust(width)
            )

    return lines

def join_blocks_grid(blocks: List[List[str]], cols: int, width: int, gap: int) -> List[str]:
    out: List[str] = []
    spacer = " " * gap

    for r in range(0, len(blocks), cols):
        row = blocks[r : r + cols]
        max_h = max(len(b) for b in row)

        for i in range(max_h):
            parts = []
            for b in row:
                s = b[i] if i < len(b) else ""
                parts.append(s.ljust(width))
            out.append(spacer.join(parts))

        out.append("")

    while out and out[-1] == "":
        out.pop()

    return out


def build_tooltip(now: dt.datetime, cols: int, width: int, gap: int, firstweekday: int) -> str:
    y = now.year
    blocks = [month_block_plain(y, m, firstweekday, width, now.date()) for m in range(1, 13)]
    grid_lines = join_blocks_grid(blocks, cols=cols, width=width, gap=gap)

    return "\n".join(grid_lines)


def parse_args() -> argparse.Namespace:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cols", type=int, default=3)
    ap.add_argument("--width", type=int, default=20)
    ap.add_argument("--gap", type=int, default=3)
    ap.add_argument("--firstweekday", choices=["sun", "mon"], default="sun")
    ap.add_argument("--text-mode", choices=["clock", "empty"], default="clock")
    ap.add_argument("--clock-format", default="%Y.%m.%d %H:%M")
    return ap.parse_args()


def main() -> None:
    args = parse_args()

    now = dt.datetime.now()
    firstweekday = 6 if args.firstweekday == "sun" else 0

    cols = max(1, args.cols)
    width = max(14, args.width)
    gap = max(1, args.gap)

    tooltip = build_tooltip(now, cols=cols, width=width, gap=gap, firstweekday=firstweekday)

    if args.text_mode == "empty":
        text = ""
    else:
        text = f"{now.strftime(args.clock_format)}"

    print(json.dumps({"text": text, "tooltip": tooltip}, ensure_ascii=False))


if __name__ == "__main__":
    main()

