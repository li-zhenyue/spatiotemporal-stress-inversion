function plot_optimal_meshing_strategy( lon, lat, idx, C, optimal_nx, optimal_ny )


category = size( C, 1 );

figure( 'color', 'w' )
hold on

% 绘制地震分组
scatter( lon, lat, 15, idx, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceAlpha', 0.7, 'MarkerEdgeAlpha', 0.5  )
colormap( jet( category ) )
box on
set( gca, 'fontsize', 12 )
xlabel( 'longitude / \circ ' )
ylabel( 'latitude / \circ ' )

% 绘制最优网格化策略
min_clon = min( C( :, 1 ) ); max_clon = max( C( :, 1 ) );
min_clat = min( C( :, 2 ) ); max_clat = max( C( :, 2 ) );
lon_grid = linspace( min_clon, max_clon, optimal_nx );
lat_grid = linspace( min_clat, max_clat, optimal_ny );
for i = 1 : optimal_ny
    plot( [ min_clon, max_clon ], lat_grid( i ) * ones( 1, 2 ), 'k' )
end
for i = 1 : optimal_nx
    plot( lon_grid( i ) * ones( 1, 2 ), [ min_clat, max_clat ], 'k' )
end

% 为每个质心寻找网格点坐标和经纬度位置
grid_coordinate = nan( category, 2 );
for k = 1 : category
    [ mlon, mlat ] = meshgrid( lon_grid, lat_grid );
    dist = ( mlon - C( k, 1 ) ).^2 + ( mlat - C( k, 2 ) ).^2;
    [ grid_coordinate( k, 1 ), grid_coordinate( k, 2 ) ] = find( dist == min( dist, [], 'all' ) );
end
grid_position = [ lon_grid( grid_coordinate( :, 2 ) )', lat_grid( grid_coordinate( :, 1 ) )' ];

% 绘制质心位置和网格化后的位置
scatter( C( :, 1 ), C( :, 2 ), 60, 'w', 'filled', 'marker', 'd', 'MarkerEdgeColor', 'k', 'LineWidth', 1 )
scatter( grid_position( :, 1 ), grid_position( :, 2 ), 50, [0.30, 0.75, 0.93], 'filled', 'marker', 'o', 'MarkerEdgeColor', 'k', 'LineWidth', 1 )

% 从质心位置指向网格点
for i = 1 : category
    quiver( C( i, 1 ), C( i, 2 ), grid_position( i, 1 ) - C( i, 1 ), grid_position( i, 2 ) - C( i, 2 ), 'LineWidth', 1.2, 'color', 'r', 'MaxHeadSize', 1  )
%     plot( [ C( i, 1 ), grid_position( i, 1 ) ], [ C( i, 2 ), grid_position( i, 2 ) ], 'r', 'LineWidth', 1  )
end


end



