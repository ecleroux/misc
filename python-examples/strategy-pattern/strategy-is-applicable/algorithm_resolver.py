from algorithms import AlgorithmBase
import algorithms

def get_algorithm(name: str) -> AlgorithmBase:
    """This will loop through all classes that inherets from AlgorithmBase
    and return the applicable algorithm"""

    applicable_algorithm_list = []
    for cls in AlgorithmBase.__subclasses__():
        if cls().is_applicable(name):
            applicable_algorithm_list.append(cls)

    if len(applicable_algorithm_list) == 0:
        raise Exception("No algorithm found!")
    elif len(applicable_algorithm_list) > 1:
        raise Exception("More than one algorithm found!")

    return applicable_algorithm_list[0]()