function plot_neighbors( neighbors, nx, ny )


figure( 'color', 'w' )

[ mnx, mny ] = meshgrid( nx, ny );
scatter( mnx(:), mny(:), 120, neighbors( : ), 'filled', 'o' )

colormap( jet )
clb = colorbar;
clb.Label.String = 'Number of occupied neighbors';
caxis( [ 0, max( neighbors, [], 'all' )] )

set( gca, 'position', [ 0.15, 0.2, 0.6, 0.6 ], 'fontsize', 13, 'xtick', nx( 1 ) : 2 : nx( end ), ...
    'ytick', ny( 1 ) : 2 : ny( end ) )
xlim( [ nx( 1 ), nx( end ) ] )
ylim( [ ny( 1 ), ny( end ) ] )
box on
grid on
xlabel( 'Number of grid points along X' )
ylabel( 'Number of grid points along Y' )


end