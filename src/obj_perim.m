function [objPerim] = obj_perim(S)
[nRows, nCols] = size(S);
[cols,rows] = meshgrid(1:nCols,1:nRows);
dim_index = [rows(:) cols(:)];

[objNum,linear_index] = sort(S(:));

% Find object index boundaries
objBounds = find([diff(objNum);1])+1;

objPerim = zeros(size(S));

for i = 1:length(objBounds)-1
    indices = linear_index(objBounds(i):objBounds(i+1)-1);
    row_col = dim_index(indices,:);
    mins = min(row_col);
    maxs = max(row_col);
    objPerim(mins(1):maxs(1),mins(2):maxs(2)) = bwperim(S(mins(1):maxs(1),mins(2):maxs(2))==i) | objPerim(mins(1):maxs(1),mins(2):maxs(2));
end