#!/usr/bin/env python
"""module to calculate factorial numbers
and binomial coefficients on the log scale,
to avoid overflow with big numbers"""

import math
import argparse
# use an Argument Parser object to handle script arguments
parser = argparse.ArgumentParser()
parser.add_argument("-n", type=int, help="total number of items to choose from")
parser.add_argument("-k", type=int, help="number of items to choose")
parser.add_argument("-l", "--log", action="store_true", help="returns the log binomial coefficient")
parser.add_argument("--test", action="store_true", help="tests the module and quits")
args = parser.parse_args()
# test argument problems early:
if args.test and (args.n or args.k or args.log):
    print("ignoring n, k or log arguments")
if not (args.test or (args.n and args.k)):
    if __name__ == '__main__':
        raise Exception("needs 2 integer arguments: -n and -k")
    # no error if file imported as module

def logfactorial(n, k=0):
    """calculate the log of factorial n: log(1) + ... + log(n).
    optional argument: k (default 0) to calculate log(n!/k!)
    assumes n and k are non-negative integers.
    If k>n, the result is 0, not an error.
    Examples:

    >>> round(math.exp(logfactorial(5)),5)
    120.0
    >>> round(math.exp(logfactorial(5,4)),5)
    5.0
    >>> round(math.exp(logfactorial(5,5)),7)
    1.0
    >>> round(math.exp(logfactorial(10,8)),5)
    90.0
    """
    assert isinstance(n,int), "argument to logfactorial should be an integer"
    assert n >= 0, "argument n should be non-negative: " + str(n)
    assert type(k)==int, "optional argument k should be an integer"
    assert k >= 0, "optional argument k should be >= 0:" + str(k)
    res = 0
    for i in range(k+1,n+1):
        res += math.log(i)
    return res

def choose(n,k, log=False):
    """calculate the binomial coefficient:
    number of ways to choose k elements in a set of n.
    Both n and k should be integers, non-negative and k<=n.
    If log=True: returns the log of the binomial coefficient.
    Examples:

    >>> choose(12,10)
    66
    >>> round(choose(5,4, log=True), 7) # log of 5
    1.6094379
    >>> choose(6,6)
    1
    >>> choose(0,0)
    1
    >>> choose(3,10)
    Traceback (most recent call last):
      ...
    AssertionError: n (3) should be >= k (10)
    """
    assert k <= n, "n (" + str(n) + ") should be >= k (" + str(k) + ")"
    res = logfactorial(n,k) - logfactorial(n-k)
    if not log:
        res = round(math.exp(res))
    return res

def runTests():
    print("testing the module...")
    import doctest
    doctest.testmod()
    print("done with tests")

if __name__ == '__main__':
    if args.test:
        runTests()
    else:
        res = choose(args.n, args.k, args.log)
        if args.log:
            print(res)
        else:
            print(round(res))
