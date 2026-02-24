
figure

% 地形图
m_proj( 'mercator', 'lon', lon_range+[-0.2,0.2], 'lat', lat_range+[-0.2,0.2] );
clim( [0, 2000] );
cmap = m_colmap( 'bland', 256 );
colormap( cmap( 230 : 256, : ) )
m_etopo2( 'shadedrelief', 'lightangle', 45 );
m_grid( 'box', 'on', 'gridlines', 'no', 'fontsize', 13,...
    'tickdir','out', 'ticklen', 0.015, 'linewidth', 1  )
set( gcf, 'position', [300, 300, 650, 500], 'color', 'w' )
alpha( 0.6 )

% 应力分区边界
m_line( vx, vy, 'color', 'b', 'LineWidth', 1.2 )
color = jet( category );
for i = 1 : category
    j = idx == i;
    m_scatter( lon( j ), lat( j ), 35, 'filled', 'MarkerEdgeColor', 'k',...
        'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 0.8, 'MarkerFaceColor', color( i, : ) );
end

% 绘制质心
centroid = groups.centroid;
m_scatter( centroid( :, 1 ), centroid( :, 2 ), 80, 'd', 'filled',...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w', 'LineWidth', 1.2 )

% 绘制平滑关系
ngrp = size( centroid, 1 );
for i = 1 : ngrp
    k = find( pairs( :, i ) );
    color = 'r';
    for j = 1 : length( k )
        m_line( [centroid( i, 1 ), centroid( k( j ), 1 )], [centroid( i, 2 ), centroid( k( j ), 2 )], 'color', 'r', 'LineWidth', 1.5 )
    end
end

