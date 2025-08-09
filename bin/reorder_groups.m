function sorted_groups = reorder_groups( groups )
% 对聚类后簇重新排序
% 按照质心的经度从小到大的顺序排列

[ ~, idx ] = sort( groups.centroid( :, 1 ), 'ascend' );
sorted_groups = groups( idx, : );


end