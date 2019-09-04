function [ ngonImage ] = polygonBorder(lblImage,range)
edges = boxBorderSearch(lblImage,3);

[numNeighbors, uniqueNeighbors] = get_obj_neighbors(edges,1);

[sortedImage,indices] = sort(lblImage(:));
firstVal = find(diff(sortedImage),1)+1;

polyVals = zeros(size(sortedImage));
polyVals(firstVal:end) = numNeighbors(sortedImage(firstVal:end));

ngonImage(indices) = polyVals(:);
ngonImage = reshape(ngonImage,size(lblImage)).*(edges==0);
end