# Graph Homomorphism Ideals (Macaulay2)

This repository provides Macaulay2 code to compute graph and digraph homomorphisms and to construct the corresponding homomorphism ideals.

## Mathematical background

Let $G$ and $H$ be two graphs with vertex sets $[n]=\{1,\dots,n\}$ and $[m]=\{1,\dots,m\}$.

A graph homomorphism $\varphi : G \to H$ assigns to each vertex $i \in [n]$ a vertex $\varphi(i) \in [m]$ such that edges are preserved.

To each homomorphism $\varphi$, we associate the monomial
$$
u_\varphi = x_{1,\varphi(1)} \cdots x_{n,\varphi(n)}.
$$

The **graph homomorphism ideal** is defined as
$$
I_{G \to H} = (u_\varphi \mid \varphi \in \mathrm{Hom}(G,H)).
$$

## Main functions

- `idealGraph(G,H)`  
  Returns the ideal associated to graph homomorphisms from $G$ to $H$

- `idealDiGraph(G,H)`  
  Returns the ideal associated to digraph homomorphisms

## Requirements

You must load the Macaulay2 package:

```macaulay2
loadPackage "Graphs";
