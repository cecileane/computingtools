---
layout: page
title: python classes and methods
description: course notes
---
[previous](notes1115.html) &
[next](notes1206.html)

---

object-oriented programming:

- define new "types" of objects: classes
- each object type has its own data *attributes* and *methods*.  
- special method: `__init__` to create a new object of the class
- `self`: name of new object
- special method: `__str__` to convert an object into a string,
  used to `print` the object

<!--
see Karl's
[lecture](http://kbroman.org/Tools4RR/assets/lectures/13_python_withnotes.pdf)
for a cool example
-->

example: class to code graphs, or trees, made of nodes and edges.

- Tree class
- Edge class

## the Edge class

Edge class attributes:

- `parent`: index for parent node
- `child`: index for child node

Copy this to a new file, named `tree.py`:

```python
#!/usr/bin/env python

class Edge:
    """Edge class, to contain a directed edge of a tree or directed graph.
    attributes parent and child: index of parent and child node in the graph.
    """

    def __init__ (self, parent, child, length=None):
        """create a new Edge object, linking nodes
        with indices parent and child."""
        print("starting __init__ for new Edge object/instance")
        self.parent = parent
        self.child = child
        self.length = length

    def __str__(self):
        res = "edge from " + str(self.parent) + " to " + str(self.child)
        return res
```

let's use it, in a new python session:
(if not in same directory, add the file's path to python's path:
`import sys` then `sys.path.append("path/to/tree/dot/py/file")`.)

```python
import tree
e1 = tree.Edge(0,1)
e2 = tree.Edge(0,2)
e3 = tree.Edge(2,3)
e4 = tree.Edge(2,4)
e4
print(e4)
```

## the Tree class

Tree class attributes:

- `edge`: list of Edge objects
- methods `add_edge()` to add an existing edge to the list,
  `new_edge()` to create and add a new edge

```python
class Tree:
    """ Tree, described by its list of edges."""
    def __init__(self, edgelist):
        """create a new Tree object from a list of existing Edges"""
        self.edge = edgelist

    def __str__(self):
        res = "parent -> child:"
        for e in self.edge:
            res += "\n" + str(e.parent) + " " + str(e.child)
        return res

    def add_edge(self, ed):
        """add an edge to the tree"""
        self.edge.append(ed)

    def new_edge(self, parent, child):
        """add to the tree a new edge from parent to child (node indices)"""
        self.add_edge( Edge(parent,child) )
```

after edits to `tree.py`, the class should be reloaded with:

```python
import importlib
importlib.reload(tree)
tre = tree.Tree([e1,e2])
tre
print(tre)
tre.add_edge(e3)
tre.new_edge(2,4)
print(tre)
```

example to create a tree without creating *named* edges:

```python
import tree
tre = tree.Tree([])
tre.new_edge(0,1); tre.new_edge(0,2)
tre.new_edge(2,3); tre.new_edge(2,4)
tre
print(tre)
```

## methods

To make our class more useful, let's add new methods to it:

- `get_dist2root(i)` to get the distance from the root to node i
- to help get these distances: `update_node2edge()` to create (or update)
  new attributes:
  * `node2edge`: dictionary node index -> parent Edge object
  * `root`: index of node that has no parent edge

add this to your Tree class, and call it each time the tree is modified:

```python
def update_node2edge(self):
      """dictionary child node index -> edge for fast access to edges.
      also add/update root attribute."""
      self.node2edge = {e.child : e for e in self.edge}
      childrenset = set(self.node2edge.keys())
      rootset = set(e.parent for e in self.edge).difference(childrenset)
      if len(rootset) > 1:
          raise Warning("there should be a single root: " + str(rootset))
      if len(rootset) == 0:
          raise Exception("there should be at least one root!")
      self.root = rootset.pop()
```

we used **sets** above: like dictionaries, but with keys only: no values.
useful:

- to check if one element is in the set, very fast even for big sets
- to do set operations: here we got a set difference A \ B:
  elements in A that are not in B

examples with sets:

```python
a = {1,50,100}
if 60 in a:
   print("60 is in a")
elif 50 in a:
   print("60 not in a, but 50 is in a")
a.issubset({50,1})
a.issuperset({50,1})
a.union({2,75})  # a is still {1, 50, 100}
a.update({2,75}) # a has changed
```

back to our tree class, let's use our method to identify the root
and match each non-root node with an edge:

```python
import importlib
importlib.reload(tree)
tre = tree.Tree([tree.Edge(0,1),tree.Edge(0,2),
                 tree.Edge(2,3),tree.Edge(2,4)])
print(tre)
tre.node2edge
tre.root
```

class work: write new methods
(see example solution [here](../assets/python/tree.py))

- `get_path2root(i)` for the list of nodes between the root and i,
- `get_dist2root(i)` for the distance between the root and node i,
- `get_MRCA(i,j)` to get the most recent common ancestor between nodes i and j
- `get_nodedist(i,j)` to get the tree distance between nodes i and j

and use them:

```python
tre.get_dist2root(3)
tre.get_path2root(3)
tre.get_MRCA(3,1)
tre.get_nodedist(3,1)
```

## conventions

- class names are capitalized (e.g. `Edge`, `Tree`)
- **verbs** for methods, **nouns** for data attributes

many things we might want to add:

- add edge lengths to the Edge class,
  use them to get distances in `get_nodedist()`
- new attribute for Tree objects to hold leaf names
- compare 2 trees, to see if they have the same topology:
  if so, same distances between leaves
- `Node` class, pointing to `Edge`s

This example is meant to show how to use classes,
*not* to show the best data structure for trees.

<!--
```python
t1 = tree.Tree([tree.Edge(0,1),tree.Edge(0,2),tree.Edge(2,3),tree.Edge(2,4)])
t2 = tree.Tree([tree.Edge(0,1),tree.Edge(0,2),tree.Edge(2,3),tree.Edge(2,4),
                tree.Edge(1,5),tree.Edge(1,6)])
```
-->

## module namespaces

add this at the top of the file, to see which variable is used
when a name appears multiple times:

```python
a = 5
class Foo:
    def __init__(self):
        self.x = a
class Bar:
    a = 6 # will be object attribute: .a
    b = ["u","v"] # also .b, shared across all Bar objects
    def __init__(self):
        self.x = a
```

now let's use these classes:

```python
import tree
tree.a
tree.b # unknown
a # unknown

foo = tree.Foo()
foo.x

bar = tree.Bar()
bar.x
bar.a
bar.b

tree.a = 7
foo = tree.Foo()
foo.x

bar.a = 8
bar.b[0] = "uu"

bar2 = tree.Bar()
bar2.a
bar2.x
bar2.b ## mutable: shared across all Bar objects
```

conclusion: beware, check your code on very simple examples like this if in doubt.

---
[previous](notes1115.html) &
[next](notes1206.html)
