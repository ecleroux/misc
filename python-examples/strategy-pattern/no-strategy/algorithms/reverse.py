from typing import List

class Reverse():
    def do_algorithm(self, data: List) -> List:
        print("Reversing data")
        return reversed(sorted(data))