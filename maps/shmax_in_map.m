figure

position = readmatrix( 'stereonet_position.dat' );
% position = groups.centroid;

% 地形图
m_proj( 'mercator', 'lon', lon_range+[-0.7,0.2], 'lat', lat_range+[-0.5, 0] );
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
% % m_line( block2( :, 1 ), block2( :, 2 ), 'color', 'm', 'LineWidth', 1 )

% 应力分区边界
m_line( vx, vy, 'color', 'b', 'LineWidth', 1.2 )

r = 0.015;
SH_range = groups.SH_range * pi/180;
nn = 50;
for i = 1 : ngrp
    optimal_stress = m2stresstensor( groups.stress{ i } );
    [ s1_optimal, s2_optimal, s3_optimal, ~ ] = stress_tensor_decomposition( optimal_stress );
    [ ~, s1_plunge ] = vector_to_azimuth_and_plunge( s1_optimal );
    [ ~, s2_plunge ] = vector_to_azimuth_and_plunge( s2_optimal );
    [ ~, s3_plunge ] = vector_to_azimuth_and_plunge( s3_optimal );
    type = StressType( s1_plunge, s2_plunge, s3_plunge );
    switch type
        case { 'NF', 'NS' }
            color = 'b';
        case { 'TF', 'TS' }
            color = 'r';
        case 'SS'
            color = 'k';
        case 'U'
            color = 'g';
    end
    
    [ox, oy] = m_ll2xy( position( i, 1 ), position( i, 2 ) );
    
    fill( ox + r * cos( linspace( 0, 2*pi, 50 ) ), oy + r * sin( linspace( 0, 2*pi, 50 ) ), 'w',...
        'EdgeColor', 'k', 'LineWidth', 0.01 )
    
    x = r * [ 0, sin( linspace( SH_range( i, 1 ), SH_range( i, 2 ), nn ) ), 0 ];
    y = r * [ 0, cos( linspace( SH_range( i, 1 ), SH_range( i, 2 ), nn ) ), 0 ];
    fill(  x + ox,  y + oy, color, 'EdgeColor', color, 'LineWidth', 0.01 )
    fill( -x + ox, -y + oy, color, 'EdgeColor', color, 'LineWidth', 0.01 )
    
end
