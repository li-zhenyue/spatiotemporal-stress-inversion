function plot_compromise_curve( groups, lamuda )

% pairs = neighbouring_relations( groups.grid_coordinate );
pairs = neighbourship( groups.centroid, 3, 50 );
[ G, d, L ] = coefficient_matrix( groups.fms, pairs );
compromise_curve( G, d, L, lamuda );


end