from context import Context


if __name__ == "__main__":

    action = "sort"
    context = Context(action)
    
    l = ["a", "b", "c", "d", "e"]
    print(context.do_algorithm(l))

    # Far down the application, we need to do this again:

    context = Context(action) # action might have changed
    l = ["c", "x", "K", "e", "l"]
    print(context.do_algorithm(l))