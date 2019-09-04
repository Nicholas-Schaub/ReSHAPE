function numNeighbors = NumNeighbors(S,varargin)

edges = boxBorderSearch(S,3);

[numNeighbors, uniqueNeighbors] = get_obj_neighbors(edges,1);

numNeighbors = numNeighbors - 1;

end