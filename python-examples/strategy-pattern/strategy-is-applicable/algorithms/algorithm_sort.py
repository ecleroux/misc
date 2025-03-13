from typing import List
from .algorithm_base import AlgorithmBase

class AlgorithmSort(AlgorithmBase):

    def is_applicable(self, action: str) -> bool:     
        return action == "sort"

    def do_algorithm(self, data: List) -> List:
        print("Sorting data")
        return sorted(data)