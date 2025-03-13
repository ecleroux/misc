from typing import List
from .strategy_base import StrategyBase
import random

class Random(StrategyBase):
    def do_algorithm(self, data: List) -> List:
        print("Randomizing data")
        random.shuffle(data)
        return data