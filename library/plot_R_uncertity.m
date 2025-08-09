function plot_R_uncertity( groups )

R_uncertity = groups.uncertainty( :, 4 );

ngrp = size( groups, 1 );
R_optimal = nan( ngrp, 1 );
for i = 1 : ngrp
    optimal_stress = m2stresstensor( groups.stress{ i } );
    [ ~, ~, ~, R_optimal( i ) ] = stress_tensor_decomposition( optimal_stress );
end

figure( 'color', 'w' )
sz = 200;
scatter( groups.centroid( :, 1 ), groups.centroid( :, 2 ), sz, R_optimal, 'filled', 'marker', 's' );
d = ( max( groups.centroid( :, 1 ) ) - min( groups.centroid( :, 1 ) ) ) * 0.02;
text( groups.centroid( :, 1 ) + d, groups.centroid( :, 2 ), num2str( ( 1 : ngrp )' ), 'FontSize', 10, 'HorizontalAlignment', 'left')
colormap( jet )
colorbar
caxis( [0, 1] )
grid on
box on
set( gca, 'fontsize', 12 )

figure( 'color', 'w', 'position', [200, 200, 700, 400] )
hold on
pos = R_uncertity; 
neg = R_uncertity;
idx = R_optimal + R_uncertity > 1;
pos( idx ) = 1 - R_optimal( idx );
idx = R_optimal - R_uncertity < 0;
neg( idx ) = R_optimal( idx );
errorbar( 1 : ngrp, R_optimal, neg, pos, 's', 'MarkerSize', 7, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'LineWidth', 1 )
ylim( [0, 1] )
xlim( [1, ngrp] )
grid on
box on
set( gca, 'fontsize', 13, 'position', [0.15, 0.2, 0.7, 0.6] )
xlabel( 'Subregion number ' )
ylabel( 'R ' )


end


