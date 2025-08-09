function plot_clusters( lon, lat, idx, C )

% 绘制聚类结果
figure( 'color', 'w' )
hold on
box on

scatter( lon, lat, 15, idx, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceAlpha', 0.8, 'MarkerEdgeAlpha', 0.5 )
cluster_nbr = size( C, 1 );
colormap( jet( cluster_nbr ) )

scatter( C( :, 1 ), C( :, 2 ), 60, 'd', 'w', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1 )

% 边界
% [ vx, vy ] = voronoi( C( :, 1 ), C( :, 2 ) );
% plot( vx, vy, 'color', [0, 0.45, 0.74], 'Linewidth', 1 )

axis( [ min( lon ), max( lon ), min( lat ), max( lat ) ] )
set( gca, 'fontsize', 12 )
xlabel( 'longitude / \circ ' )
ylabel( 'latitude / \circ ' )


end