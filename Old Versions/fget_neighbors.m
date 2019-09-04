function [pixNeighbors] = get_neighbors(S,varargin)
% Generate the pixel neighborhood reference
numargs = length(varargin);
if numargs>1
    error('Too many arguments.')
elseif numargs
    range = varargin{1};
else
    range = 1;
end
[nRows, nCols] = size(S);
[cindex,rindex] = meshgrid(-range:range,-range:range);
neighborOffsets = cindex(:)*nRows+rindex(:);
neighborOffsets = neighborOffsets(neighborOffsets~=0);

% Get inscribed image linear indices: [range] pixels away from all edges
[cols,rows] = meshgrid(range:nCols-range-1,range+1:nRows-range);
linear_index = nRows*cols(:)+rows(:);

% Filter out indices that contain no objects (S==0)
mask = S(linear_index)>0;
linear_index = linear_index(mask);

% Get indices of neighbor pixels
neighbor_index = bsxfun(@plus,neighborOffsets,linear_index(:)');

% Get values of neighbor pixels
neighborVals = S(neighbor_index);

% Sort pixels by object
[objNum, index] = sort(S(linear_index));

% Find object index boundaries
objBounds = find([1;diff(objNum);1]);

% Get border objects, this includes the value of the object
uniqueNeighbors = cell(length(objBounds)-1,1);
for i = 1:length(objBounds)-1
    allVals = neighborVals(:,index(objBounds(i):objBounds(i+1)-1));
    sortedVals = sort(allVals(:));
    uniqueIndices = find([1;diff(sortedVals)]);
    uniqueNeighbors{i} = sortedVals(uniqueIndices);
end

% Get the number of neighbor objects
numNeighbors = cellfun(@length,uniqueNeighbors)-1;