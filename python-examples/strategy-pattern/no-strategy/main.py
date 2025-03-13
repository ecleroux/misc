from algorithms import Sort, Reverse, Random
    
if __name__ == "__main__":

    action = "sort"

    l = ["a", "b", "c", "d", "e"]
    if action == "sort":
        s = Sort()
        print(s.do_algorithm(l))
    elif action == "reverse":
        r = Reverse()
        print(r.do_algorithm(l))
    elif action == "random":
        r = Random()
        print(r.do_algorithm(l))

    # Far down the application, we need to do this again:

    l = ["c", "x", "K", "e", "l"]
    if action == "sort":
        s = Sort()
        print(s.do_algorithm(l))
    elif action == "reverse":
        r = Reverse()
        print(r.do_algorithm(l))
    elif action == "random":
        r = Random()
        print(r.do_algorithm(l))