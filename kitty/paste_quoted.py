from kittens.tui.handler import result_handler
from kitty.boss import Boss
from kitty.fast_data_types import get_clipboard_string
from shlex import quote
from typing import List

def main( args: List[str]) -> str:
    pass

@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    w = boss.window_id_map.get(target_window_id)
    quoted = quote(get_clipboard_string())
    if w is not None:
        w.paste(quoted)
