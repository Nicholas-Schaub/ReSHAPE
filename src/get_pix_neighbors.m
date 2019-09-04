function [numNeighbors,pixNeighbors] = get_pix_neighbors(S,varargin)
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
pixNeighbors = zeros((2*range+1)^2-1,numel(S));
pixNeighbors(:,linear_index) = S(neighbor_index);

% Reshape the matrix so that the rows and cols match S, and the third
% dimension contains the values of neighbor pixels
pixNeighbors = sort(reshape(pixNeighbors',[size(S) (2*range+1)^2-1]),3);

% Get the number of neighbor objects at each pixel
numNeighbors = sum(diff(pixNeighbors,1,3)>0,3);