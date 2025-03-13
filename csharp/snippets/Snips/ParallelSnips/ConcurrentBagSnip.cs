using System.Collections.Concurrent;

namespace Snippets.Snips.ParallelSnips;

public class ConcurrentBagSnip
{
    public void Run()
    {
        var bag = new ConcurrentBag<int>();
        List<int> numbers = new List<int>() { 1, 2, 3, 4, 5, 6, 7, 8, 9};

        Parallel.ForEach(numbers, new ParallelOptions { MaxDegreeOfParallelism = 4 }, (num, cancellationToken) => 
        {
            if (false)
                bag.Add(num);  
        });

        Console.WriteLine(bag.Count());
    }
}
