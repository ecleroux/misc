from algorithm_resolver import get_algorithm

if __name__ == "__main__":

    action = "sort"
    algorithm = get_algorithm(action)
    
    l = ["a", "b", "c", "d", "e"]
    print(algorithm.do_algorithm(l))

    # Far down the application, we need to do this again:

    l = ["c", "x", "K", "e", "l"]
    print(algorithm.do_algorithm(l))