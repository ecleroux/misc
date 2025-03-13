from typing import List
from .strategy_base import StrategyBase

class Sort(StrategyBase):
    def do_algorithm(self, data: List) -> List:
        print("Sorting data")
        return sorted(data)