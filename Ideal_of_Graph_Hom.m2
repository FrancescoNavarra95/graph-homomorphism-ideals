------------------------------------------------------------------------------------------------------
----------------------------------- Graph Homomorphism Ideals ----------------------------------------
--------------------------------------------------------------------------------------------------------
-- Let G and H be two graphs (or directed graphs) on vertex sets [n]={1,..,n} and 
-- [m]={1,..,m}, respectively.
-- Let Hom(G,H) denote the set of all graph homomorphisms from G to H.
--
-- Let S = K[x_(i,j) : i \in [n], j \in [m]] be a polynomial ring over a field K.
-- For any homomorphism \phi in Hom(G,H), we associate the monomial
--
--     u_\phi = x_(1,\phi(1)) * ... * x_(n,\phi(n)).
--
-- The ideal of graph homomorphisms from G to H is defined as
--
--     I_(G -> H) = ( u_\phi : \phi in Hom(G,H) ).
--
-- This package provides functions to compute all graph (or digraph)
-- homomorphisms between two given graphs and to construct the
-- associated ideal in the polynomial ring S.
--
-- IMPORTANT: The package requires loading the Macaulay2 package "Graphs".
--
-- The main functions are:
-- 1. idealGraph(G,H): constructs the ideal associated to graph homomorphisms from G to H 
-- 2. idealDiGraph(G,H): constructs the ideal associated to digraph homomorphisms from G to H
-- 
------------------------------------------------------------------------------------------------------
-- allFunctions(G,H): returns the list of all functions from the vertex set of G to the vertex set of H
allFunctions = (G, H) -> (
    VG = vertexSet G;
    VH = vertexSet H;
    n = #VG-1;
    S = VH;
    for i from 1 to n do (
        S = S ** VH;
    );
    for i from 0 to n do (
        S = S/splice;
    );
    S = apply(S, toList);
    return S;
);

---------------------------------------------------------------

-- allEdges(G): returns all edges of G, including loops {v,v} for vertices adjacent to themselves
allEdges = G -> (
    E = edges G;
    L = select(vertices G, v -> isMember(v, neighbors(G,v)) );
    NewL = {};
    for l in L do NewL = append(NewL, {l,l}) ;
    J = join(E, apply(NewL, x -> set x));
    return J;
);

-- isAnEdge(G,L): checks whether L is an edge of G (including loops)
isAnEdge = (G,L) -> (
	EG = allEdges G;
	if isMember(set L, EG) then return true else return false;
);

-- isHomGraph(G,H,f): checks whether a function f defines a graph homomorphism from G to H
isHomGraph = (G, H, f) -> (
    EG = allEdges G;
    EGList = apply(EG, toList);
    
    Tag = all(EGList, e -> ( 
        u = e#0;
        if #e == 1 then v = e#0 else v = e#1;
        isAnEdge(H, {f_(u - 1), f_(v - 1)})
    ));
    return Tag; 
);

-- graphHomomorphisms(G,H): returns all graph homomorphisms from G to H
graphHomomorphisms = (G,H) -> (
    maps = allFunctions(G, H);
    HM = select(maps, f -> isHomGraph(G,H,f));
    return HM;
);

-- idealGraph(G,H): constructs the ideal associated to graph homomorphisms from G to H
idealGraph = (G,H) ->(
m = #vertexSet(G);
n = #vertexSet(H);
R = QQ[x_(1,1)..x_(m,n)];

HomGraph = graphHomomorphisms (G,H);
if HomGraph == {} then error "There are no graph homomorphisms";
HG = #(HomGraph#0);
Li = {};
for seq in HomGraph do(
	u = 1;
	for i from 1 to m do(
		u = u*x_(i,seq#(i-1));
	); 
Li = append(Li, u);
);
return ideal Li;
);

--------------------------------------------------------------------

-- isDiEdge(G,L): checks whether L is a directed edge of G
isDiEdge = (G,L) -> (
	EG = edges G;
	if isMember(L, EG) then return true else return false;
);

-- isHomDiGraph(G,H,f): checks whether a function f defines a digraph homomorphism from G to H
isHomDiGraph = (G, H, f) -> (
    EGList = edges G;
    
    Tag = all(EGList, e -> ( 
        u = e#0;
        v = e#1;
        isDiEdge(H, {f_(u - 1), f_(v - 1)})
    ));
    return Tag; 
);

-- digraphHomomorphisms(G,H): returns all digraph homomorphisms from G to H
digraphHomomorphisms = (G,H) -> (
    maps = allFunctions(G, H);
    HM = select(maps, f -> isHomDiGraph(G,H,f));
    return HM;
);

-- idealDiGraph(G,H): constructs the ideal associated to digraph homomorphisms from G to H
idealDiGraph = (G,H) ->(
m = #vertexSet(G);
n = #vertexSet(H);
R = QQ[x_(1,1)..x_(m,n)];

HomGraph = digraphHomomorphisms (G,H);
if HomGraph == {} then error "There are no graph homomorphisms";
HG = #(HomGraph#0);
Li = {};
for seq in HomGraph do(
	u = 1;
	for i from 1 to m do(
		u = u*x_(i,seq#(i-1));
	); 
Li = append(Li, u);
);
return ideal Li;
);





------------------------------------------------------------
-- Examples
------------------------------------------------------------

-- i1 : loadPackage "Graphs";
-- i2 : load "Ideal_of_Graph_Hom.m2";

-- i3 : G = graph({{1,2}, {2,3}, {1,1}, {2,2}});
-- i4 : H = graph({{1,2}, {2,2}});
-- i5 : idealGraph(G,H)
--
-- o5 = ideal (x   x   x   , x   x   x   )
--              1,2 2,2 3,1   1,2 2,2 3,2
--
-- o5 : Ideal of R

-- i6 : G = graph({{1,2}, {2,3}, {1,1}, {2,2}});
-- i7 : H = graph({{1,2}, {2,3}, {2,2}});
-- i8 : idealGraph(G,H)
--
-- o8 = ideal (x   x   x   , x   x   x   , x   x   x   )
--              1,2 2,2 3,1   1,2 2,2 3,2   1,2 2,2 3,3
--
-- o8 : Ideal of R

-- i9 : G = digraph({{1,2}, {2,3}, {1,1}, {2,2}});
-- i10 : H = digraph({{1,2}, {2,3}, {2,2}});
-- i11 : idealDiGraph(G,H)
--
-- o11 = ideal (x   x   x   , x   x   x   )
--               1,2 2,2 3,2   1,2 2,2 3,3
--
-- o11 : Ideal of R

-- i12 : G = digraph({{1,2}, {2,3}, {1,1}});
-- i13 : H = digraph({{1,2}, {2,3}});
-- i14 : idealDiGraph(G,H)
--
-- Ideal_of_Graph_Hom.m2:135:24:(3):[1]: error: There are no graph homomorphisms
