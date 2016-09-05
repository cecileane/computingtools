---
layout: page
title: 11/17 notes
description: course notes
---
[previous](notes1115.html) & [next](notes1206.html)

---

## python classes and methods

recall our Tree class from
[last time](notes1115.html#python-classes-and-methods):

```python
import tree
tre = tree.Tree([])
tre.new_edge(0,1); tre.new_edge(0,2)
tre.new_edge(2,3); tre.new_edge(2,4)
tre
print(tre)
```

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
          warn("there should be a single root: " + str(rootset))
      if len(rootset) == 0:
          raise Exception("there should be at least one root!")
      self.root = rootset.pop()
```

we used **sets** above: like dictionaries, but with keys only: no values.
useful:

- to check if one element is in the set, very fast even for big sets
- to do set operations: here we got a set difference A \ B:
  elements in A that are not in B

```python
import importlib
importlib.reload(tree)
tre = tree.Tree([tree.Edge(0,1),tree.Edge(0,2),
                 tree.Edge(2,3),tree.Edge(2,4)])
print(tre)
tre.node2edge
tre.root
```

now let's write new methods:

- `get_dist2root(i)` for the distance between the root and node i,
- `get_path2root(i)` for the list of nodes between the root and i,
- `get_MRCA(i,j)` to get the most recent common ancestor between nodes i and j
- `get_nodedist(i,j)` to get the tree distance between nodes i and j

and use them:

```python
tre.get_dist2root(3)
tre.get_path2root(3)
tre.get_MRCA(3,1)
tre.get_nodedist(3,1)
```

useful conventions:

- class names are capitalized (e.g. Edge, Tree)
- **verbs** for methods, **nouns** for data attributes

many things we might want to add:

- add edge lengths to the Edge class,
  use them to get distances in `get_nodedist()`
- new attribute for Tree objects to hold leaf names
- compare 2 trees, to see if they have the same topology:
  if so, same distances between leaves
- Node class, pointing to Edges

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

## Scripting project

- overall [description](project1description)
- step-by-step instruction [details](project1stepsinstructions)
- due: 12/6

---
[previous](notes1115.html) & [next](notes1206.html)
