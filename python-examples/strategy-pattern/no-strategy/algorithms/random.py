from typing import List
import random

class Random():
    def do_algorithm(self, data: List) -> List:
        print("Randomizing data")
        random.shuffle(data)
        return data