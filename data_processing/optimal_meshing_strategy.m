function [ groups, optimal_nx, optimal_ny, neighbors ] = optimal_meshing_strategy( groups, nx, ny )


if any( strcmp( 'centroid', groups.Properties.VariableNames ) )
    C = groups.centroid;
else
    error( 'table variable ( centroid ) does not exist.' )
end

[ optimal_nx, optimal_ny, neighbors ] = find_optimal_meshing_strategy( C, nx, ny );
[ grid_coordinate, grid_position ] = grid_coordinate_and_position( C, optimal_nx, optimal_ny );
groups.grid_coordinate = grid_coordinate;
groups.grid_position = grid_position;

groups = adjust_groups_order( groups );


end


function [ optimal_nx, optimal_ny, neighbors ] = find_optimal_meshing_strategy( C, nx, ny )
% 寻找最优（相邻格点数最多）的网格化策略
% C 质心，nx 经度方向划分的网格数，ny 纬度方向的网格数
% neighbors 不同网格化策略下的相邻格点数量

ngrp = size( C, 1 );
neighbors = -1 * ones( length( ny ), length( nx ) );
for i = 1 : length( ny )
    lat_grid = linspace( min( C( :, 2 ) ), max( C( :, 2 ) ), ny( i ) );
    
    for j = 1 : length( nx )
        lon_grid = linspace( min( C( :, 1 ) ), max( C( :, 1 ) ), nx( j ) );
        
        % 为每个质心寻找网格点坐标
        grid_coordinate = nan( ngrp, 2 );
        for k = 1 : ngrp
            [ mlon, mlat ] = meshgrid( lon_grid, lat_grid );
            dist = ( mlon - C( k, 1 ) ).^2 + ( mlat - C( k, 2 ) ).^2;
            [ grid_coordinate( k, 1 ), grid_coordinate( k, 2 ) ] = find( dist == min( dist, [], 'all' ) );
        end
        
        % 检验每个网格点是否被重复分配质心
        % 若被重复分配，记为 nan
        flag = false;
        for k = 1 : ngrp - 1
            
            for m = k + 1 : ngrp
                if isequal( grid_coordinate( m, : ), grid_coordinate( k, : ) )
                    neighbors( i, j ) = nan;
                    flag = true;
                    break
                end
            end
            
            if flag
                break
            end
            
        end
        
        % 计算该网格化策略下相邻质心的对数
        if ~isnan( neighbors( i, j ) )
              pairs = neighbouring_relations( grid_coordinate );
              neighbors( i, j ) = sum( pairs, 'all' );
        end
        
    end
    
end

[ im, jm ] = find( neighbors == max( neighbors, [], 'all' ) );
optimal_nx = nx( jm );
optimal_ny = ny( im );


end

function [ grid_coordinate, grid_position ] = grid_coordinate_and_position( C, optimal_nx, optimal_ny )

category = size( C, 1 );
min_clon = min( C( :, 1 ) ); max_clon = max( C( :, 1 ) );
min_clat = min( C( :, 2 ) ); max_clat = max( C( :, 2 ) );
lon_grid = linspace( min_clon, max_clon, optimal_nx );
lat_grid = linspace( min_clat, max_clat, optimal_ny );
[ mlon, mlat ] = meshgrid( lon_grid, lat_grid );

% 为每个质心寻找网格点坐标
grid_coordinate = nan( category, 2 );
for k = 1 : category
    dist = ( mlon - C( k, 1 ) ).^2 + ( mlat - C( k, 2 ) ).^2;
    [ grid_coordinate( k, 1 ), grid_coordinate( k, 2 ) ] = find( dist == min( dist, [], 'all' ) );
end
grid_position = [ lon_grid( grid_coordinate( :, 2 ) )', lat_grid( grid_coordinate( :, 1 ) )' ];


end


