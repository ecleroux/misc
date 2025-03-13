from typing import List
from .strategy_base import StrategyBase

class Reverse(StrategyBase):
    def do_algorithm(self, data: List) -> List:
        print("Reversing data")
        return reversed(sorted(data))