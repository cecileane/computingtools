#!/usr/bin/env python

class Edge:
    """Edge class, to contain a directed edge of a tree or directed graph.
    attributes parent and child: index of parent and child node in the graph.
    """

    def __init__ (self, parent, child):
        """creates a new Edge object, linking nodes
        with indices parent and child."""
        print("starting __init__ for new Edge object/instance")
        self.parent = parent
        self.child = child

    def __str__(self):
        return  "edge from " + str(self.parent) + \
                " to " + str(self.child)

class Tree:
    """ Tree class, to contain a list of edges and a list of nodes."""
    def __init__(self, edgelist):
        """creates a new Tree object from a list of existing Edges"""
        self.edge = edgelist
        self.node = []

    def __str__(self):
        res = "parent -> child:"
        for e in self.edge:
            res += "\n" + str(e.parent) + " " + str(e.child)
        return res

    def add_edge(self, ed):
        """adds an edge to the tree"""
        self.edge.append(ed)

    def new_edge(self, parent, child):
        """adds to the tree a new edge from parent to child (node indices)"""
        self.add_edge( Edge(parent,child) )

    def add_node(self, node):
        """adds a node to the tree"""
        self.node.append(node)

    def new_node(self, ind, parent=None, children=[], name=""):
        """adds a new node with specified index,
        parent & children edges, and name"""
        self.add_node(Node(ind, parent, children, name))

    def print_nodes(self):
        for n in self.node:
            print(n)

class Node:
    """Node class, to contain a node in a tree or directed graph.
    attributes: index, name (if needed),
                parent: an Edge object,
                children: a list of Edge objects.
    """

    def __init__(self, ind, parent=None, children=None, name=""):
        """creates a new Node object, with index ind,
        not linked to any Edge at this point."""
        print("starting __init__ for new Node object")
        self.index = ind
        self.parent = parent
        self.children = children if children else [] # new address: different for each instance
        self.name  = name

    def __str__(self):
        res = "node " + str(self.index)
        if self.name:
            res += " (" + self.name + ")"
        if self.parent:
            res += "\n  parent node: " + str(self.parent.parent)
        if self.children:
            res += "\n  children:"
        for c in self.children:
            res += " " + str(c.child)
        return res

    def set_parent(self, ed):
        """set ed as the node's parent edge"""
        self.parent = ed

    def add_child(self, ed):
        """adds ed as one more child"""
        self.children.append(ed)

# old work with a Node class. simpler version in 11/15 notes.
#
# ```python
# import treeclass
# e1 = treeclass.Edge(0,1)
# e2 = treeclass.Edge(0,2)
# e3 = treeclass.Edge(2,3)
# e4 = treeclass.Edge(2,4)
# e4
# print(e4)
# tre = treeclass.Tree([e1,e2,e3])
# tre
# print(tre)
# tre.add_edge(e4)
# print(tre)
#
# n0 = treeclass.Node(0)
# n0.add_child(e1)
# # help(treeclass.Node.__init__) # changed: children no longer [] !!
# n0.add_child(e2)
# print(n0)
# tre.add_node(n0)
# tre.print_nodes()
#
# n1 = treeclass.Node(1, name="A")
# n1.set_parent(e1)
# print(n1)
# tre.add_node(n1)
# tre.print_nodes()
#
# n2 = treeclass.Node(2, parent=e2, children=[e3,e4])
# n3 = treeclass.Node(3, parent=e3, name="B")
# n4 = treeclass.Node(4, parent=e4, name="C")
#
# tre.add_node(n2)
# tre.add_node(n3)
# tre.add_node(n4)
# tre.print_nodes()
# ```
