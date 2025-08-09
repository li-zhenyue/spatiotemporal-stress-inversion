function [ groups, idx, C ] = focal_mechanisms_clustering( lon, lat, sdr, cluster_nbr )


[ idx, C ] = kmeans( [ lon, lat ], cluster_nbr,  'MaxIter', 1000, 'Replicates',1000 );

groups = table( 'size', [ cluster_nbr, 3 ], 'VariableTypes', { 'double', 'cell', 'int16' }, 'VariableNames', { 'centroid', 'fms', 'number' } );
groups.centroid = C;
for i = 1 : cluster_nbr
    groups.fms{ i } = sdr( idx == i, : );
    groups.number( i ) = sum( idx == i );
end


end


