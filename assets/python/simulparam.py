#!/usr/bin/env python

class SimulParam:
  """Simulation Parameter class, to contain a task ID, parameter IDs
  and parameter values for a particular combination of simulation parameters.
  The task ID is the input from the slurm array."""
  print("hello from SimulParam")

  def __init__ (self, taskID, paramSpace=None):
    """initializes a new SimulParam object with a given task ID.
    If given a dictionary: parameter name -> values for this param,
    then populates paramID and parameter values."""
    # fixit: add assertion to make sure taksID is an integer, non-negative,
    # and not above allowed maximum
    print("just starting __init__ for new SimulParam object")
    self.var = modulevar
    self.taskID = taskID
    print("task:",self.taskID)
    self.paramID = {}
    self.paramValue  = {}
    if paramSpace is not None:
      self.updateParams(paramSpace)

  def updateParams(self, paramSpace):
    print("task ID=",self.taskID)
    i = self.taskID
    for par in sorted(paramSpace.keys()):
      d,r = divmod(i, len(paramSpace[par]))# alternative: % and //
      self.paramID[par] = r
      self.paramValue[par] = paramSpace[par][r]
      i = d
      print(par, ": ", self.paramValue[par], sep="")

  def __str__(self):
    return   "taskID:     " + str(self.taskID) + \
           "\nparamID:    " + str(self.paramID) + \
           "\nparamValue: " + str(self.paramValue)

  def get_par(self, name):
    return self.paramValue[name]
