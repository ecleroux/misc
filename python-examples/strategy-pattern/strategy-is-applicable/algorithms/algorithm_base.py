from abc import ABC, abstractmethod
from typing import List

class AlgorithmBase(ABC):
    """
    Algorithm must inherit from this base class.
    This allows the algorithms to be resolved and called on.
    """

    @abstractmethod
    def is_applicable(self, action: str) -> bool:
        """Indicates if this algorithm is applicable"""

    @abstractmethod
    def do_algorithm(self, data: List):
        pass