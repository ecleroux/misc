from algorithms import Sort, Reverse, StrategyBase, Random
from typing import List

class Context():
    """
    The Context defines the interface of interest to clients.
    """

    def __init__(self, action: str) -> None:
        """
        Usually, the Context accepts a strategy through the constructor, but
        also provides a setter to change it at runtime.
        """
        if action == "sort":
            self._strategy = Sort()
        elif action == "reverse":
            self._strategy = Reverse()
        elif action == "random":
            self.strategy = Random()

    @property
    def strategy(self) -> StrategyBase:
        """
        The Context maintains a reference to one of the Strategy objects. The
        Context does not know the concrete class of a strategy. It should work
        with all strategies via the Strategy interface.
        """

        return self._strategy

    @strategy.setter
    def strategy(self, strategy: StrategyBase) -> None:
        """
        Usually, the Context allows replacing a Strategy object at runtime.
        """

        self._strategy = strategy

    def do_algorithm(self, data: List) -> None:
        """
        The Context delegates some work to the Strategy object instead of
        implementing multiple versions of the algorithm on its own.
        """

        return self.strategy.do_algorithm(data)