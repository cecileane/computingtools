---
layout: page
title: 11/15 notes
description: course notes
---

real [11/15 notes](notes1115.html)

## python class example: simulation parameters

example: simulation study on a grid of parameter values
(say Nfail in 50,100, and xtol in .001,.01,.1).
But 5 instead of 2 parameters, with a total of
2*2*5*3*4=240 instead of 2*3=6 combinations.


- Purpose: interface between slurm (to submit hundreds of jobs at once) and a
simulation / analysis program, that needs a combination of several parameter
values as input. slurm can provide 1 parameter as input: array task ID.
main:
take a task ID and run simulation given associated parameters
`xtol":[], "Nfail":[50,100]`

slurm array task ID -> combination of parameters for a simulation

class members:
- task ID: integer in 0-239 (240) `taskID`
- dictionary: parameter name -> ID. `paramID`
- dictionary: parameter name -> value. `paramValue`

special class method: `__init__` function to create new object ("instance").   here: taskID value as input.
initialize `paramID` and `paramValue` to empty dictionaries.

Copy this to a new file, named `simulparam.py`:

```python
class SimulParam:
  """Simulation Parameter class:
  to contain a task ID and associated parameter values.
  Purpose: interface between slurm (to submit hundreds of jobs at once) and a
  simulation / analysis program, that needs a combination of several parameter
  values as input. slurm can provide 1 parameter as input: array task ID."""

  def __init__ (self, taskID, paramSpace=None):
    """initializes a new SimulParam object with a given task ID, and
    given a dictionary: parameter name -> values for this parameter.
    Populates associated paramID and parameter values."""
    # fixit: add assertion to make sure taksID is an integer, non-negative,
    # and not above allowed maximum
    print("just starting __init__ for new SimulParam object")
    self.taskID = taskID
    print("task:",self.taskID)
    self.paramID = {}
    self.paramValue  = {}
    d,r = divmod(taskID, len(paramSpace[par]))# alternative: % and //
    self.paramID[par] = r
    self.paramValue[par] = paramSpace[par][r]
    taskID = d
    print(par, ": ", self.paramValue[par], sep="")
```

we can use our class like this:

```python
import simulparam
paramspace = {"xtol":[.001,.01,.1], "Nfail":[50,100]}
spo = simulparam.SimulParam(3, paramspace) # spo for SimulParam Object
```

let's improve on this: add methods to

- update parameter values from parameter IDs
- update parameter IDs (and values) from task ID (need parameter space info)
- update task ID from parameter IDs (need parameter space info)
- print a `SimulParam` object nicely as a string: special method `__str__`
- extract one parameter value

after edits to `simulparam.py`, the class should be reload with:

```python
import simulparam
import importlib
importlib.reload(simulparam)
```

```python
paramspace = {"xtol":[.001,.01,.1], "Nfail":[50,100]}
comb = simulparam.SimulParam(3, paramdict)
comb.taskID
comb.paramID
comb.paramValue
comb
print(comb)
comb = simulparam.SimulParam(4)
print(comb)
comb.updateParams(paramspace)
print(comb)
comb.get_par("Nfail")
getattr(comb, "taskID")
help(SimulParam)
help(SimulParam.__init__)

getattr(comb,"taskID")
```
