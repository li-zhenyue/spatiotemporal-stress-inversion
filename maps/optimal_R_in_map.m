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

% 绘制断层
% opts = detectImportOptions( 'CN-faults.gmt', 'FileType', 'text', 'NumHeaderLines', 5, ...
%     'ReadVariableNames', false, 'ImportErrorRule', 'fill', 'ExpectedNumVariables', 2 );
% faults = readmatrix( 'CN-faults.gmt', opts );
% m_line( faults( :, 1 ), faults( :, 2 ), 'color', 'k', 'LineWidth', 0.8 )

% 绘制块体边界
% opts = detectImportOptions( 'CN-block-L1.gmt', 'FileType', 'text', ...
%     'ReadVariableNames', false, 'ImportErrorRule', 'fill', 'ExpectedNumVariables', 2 );
% block1 = readmatrix( 'CN-block-L1.gmt', opts );
% % m_line( block1( :, 1 ), block1( :, 2 ), 'color', 'm', 'LineWidth', 1 )
% 
% opts = detectImportOptions( 'CN-block-L2.gmt', 'FileType', 'text', ...
%     'ReadVariableNames', false, 'ImportErrorRule', 'fill', 'ExpectedNumVariables', 2 );
% block2 = readmatrix( 'CN-block-L2.gmt', opts );
% m_line( block2( :, 1 ), block2( :, 2 ), 'color', 'm', 'LineWidth', 1 )

% 应力分区边界
m_line( vx, vy, 'color', 'b', 'LineWidth', 1.2 )

ngrp = size( groups, 1 );
R_optimal = nan( ngrp, 1 );
for i = 1 : ngrp
    optimal_stress = m2stresstensor( groups.stress{ i } );
    [ ~, ~, ~, R_optimal( i ) ] = stress_tensor_decomposition( optimal_stress );
end
colormap( jet(256) )
clim( [0, 1] )
m_scatter( groups.centroid( :, 1 ), groups.centroid( :, 2 ), 200, R_optimal, 'filled', 'marker', 's', 'MarkerEdgeColor', 'k' );
d = ( max( groups.centroid( :, 1 ) ) - min( groups.centroid( :, 1 ) ) ) * 0.028;
m_text( groups.centroid( :, 1 ) + d, groups.centroid( :, 2 ), num2str( ( 1 : ngrp )' ), ...
    'FontSize', 12, 'HorizontalAlignment', 'left', 'fontweight', 'bold', 'color', 'b' )

c = colorbar;
c.Position = [0.89, 0.11, 0.03, 0.5];
c.FontSize = 11;
c.TickLength = 0.015;
c.Label.String = 'R';
