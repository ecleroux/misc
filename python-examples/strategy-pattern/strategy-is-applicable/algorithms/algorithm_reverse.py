from typing import List
from .algorithm_base import AlgorithmBase

class AlgorithmReverse(AlgorithmBase):
    
    def is_applicable(self, action: str) -> bool:     
        return action == "reverse"

    def do_algorithm(self, data: List) -> List:
        print("Reversing data")
        return reversed(sorted(data))