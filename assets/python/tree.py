#!/usr/bin/env python

class Edge:
    """Edge class, to contain a directed edge of a tree or directed graph.
    attributes parent and child: index of parent and child node in the graph.
    """

    def __init__ (self, parent, child, length=None):
        """create a new Edge object, linking nodes
        with indices parent and child."""
        self.parent = parent
        self.child = child
        self.length = length

    def __str__(self):
        res = "edge from " + str(self.parent) + " to " + str(self.child)
        return res

class Tree:
    """ Tree, described by its list of edges."""
    def __init__(self, edgelist):
        """create a new Tree object from a list of existing Edges"""
        self.edge = edgelist
        if edgelist:
            self.update_node2edge()

    def __str__(self):
        res = "parent -> child:"
        for e in self.edge:
            res += "\n" + str(e.parent) + " " + str(e.child)
        return res

    def add_edge(self, ed):
        """add an edge to the tree"""
        self.edge.append(ed)
        self.update_node2edge()

    def new_edge(self, parent, child):
        """add to the tree a new edge from parent to child (node indices)"""
        self.add_edge( Edge(parent,child) )

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

    def get_path2root(self, i):
        """takes the index i of a node and returns the list of nodes
        from i to the root, in this order.
        This function is written with a loop.
        An alternative optional would have been a recursive function:
        that would call itself on the parent of i (unless i is the root)"""
        res = []
        nextnode = i
        while True:
            res.append(nextnode) # add node to the list
            if nextnode == self.root:
                break
            nextnode = self.node2edge[nextnode].parent # grab the parent to get closer to root
        return res

    def get_nodedist(self, i, j):
        """takes 2 nodes and returns the distance between them:
        number of edges from node i to node j"""
        if i==j:
            return 0
        pathi = self.get_path2root(i) # last node in this list: root
        pathj = self.get_path2root(j)
        while pathi and pathj:
            anci = pathi[-1] # anc=ancestor, last one
            ancj = pathj[-1]
            if anci == ancj:
                pathi.pop()
                pathj.pop()
            else:
                break
        return len(pathi)+len(pathj)
