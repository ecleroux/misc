from typing import List
from .algorithm_base import AlgorithmBase
import random

class AlgorithmRandom(AlgorithmBase):

    def is_applicable(self, action: str) -> bool:     
        return action == "random"

    def do_algorithm(self, data: List) -> List:
        print("Randomizing data")
        random.shuffle(data)
        return data