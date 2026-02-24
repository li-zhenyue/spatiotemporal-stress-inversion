
figure

% 绘制地形图
m_proj( 'mercator', 'lon', lon_range+[-0.2,0.2], 'lat', lat_range+[-0.2,0.2] );
clim( [-100, 6800] );
colormap( m_colmap( 'gland', 256 ) )
[ELEV, LONG, LAT] = m_etopo2( [lon_range lat_range] );
m_etopo2( 'shadedrelief', 'lightangle', 45 );
m_grid( 'box', 'on', 'gridlines', 'no', 'fontsize', 13,...
    'tickdir','out', 'ticklen', 0.015, 'linewidth', 1  )
set( gcf, 'position', [300, 300, 650, 500], 'color', 'w' )
set( gca, 'Position', [0.05, 0.1, 0.8, 0.8] )

c = colorbar;
c.Position = [0.81, 0.1, 0.03, 0.5];
c.FontSize = 11;
c.TickLength = 0.015;
c.Label.String = 'Elevation / m';

alpha( 0.7 )

% 绘制断层
% opts = detectImportOptions( 'CN-faults.gmt', 'FileType', 'text', 'NumHeaderLines', 5, ...
%     'ReadVariableNames', false, 'ImportErrorRule', 'fill', 'ExpectedNumVariables', 2 );
% faults = readmatrix( 'CN-faults.gmt', opts );
% m_line( faults( :, 1 ), faults( :, 2 ), 'color', 'k', 'LineWidth', 0.8 )

% 绘制块体边界
% opts = detectImportOptions( 'CN-block-L1.gmt', 'FileType', 'text', ...
%     'ReadVariableNames', false, 'ImportErrorRule', 'fill', 'ExpectedNumVariables', 2 );
% block1 = readmatrix( 'CN-block-L1.gmt', opts );
% m_line( block1( :, 1 ), block1( :, 2 ), 'color', 'm', 'LineWidth', 0.8 )
% 
% opts = detectImportOptions( 'CN-block-L2.gmt', 'FileType', 'text', ...
%     'ReadVariableNames', false, 'ImportErrorRule', 'fill', 'ExpectedNumVariables', 2 );
% block2 = readmatrix( 'CN-block-L2.gmt', opts );
% m_line( block2( :, 1 ), block2( :, 2 ), 'color', 'm', 'LineWidth', 0.8 )

% 绘制震源机制数据
for i = 1 : length( lon )
    
    [x, y] = m_ll2xy( lon( i ), lat( i ) );
    
    [~, P_axis, B_axis, T_axis] = PlaneConvert( sdr( i, : ) );
    
    type = StressType( P_axis( 2 ), B_axis( 2 ), T_axis( 2 ) );
    switch type
        case { 'NF', 'NS' }
            color = [0.07, 0.62, 1];
        case { 'TF', 'TS' }
            color = 'r';
        case 'SS'
            color = 'k';
        case 'U'
            color = 'g';
    end
    
    BeachBall( x, y, sdr( i, : ), 'CreatFigure', false, 'radius', 0.0015 * mag( i ), ...
        'circle', { 'k-', 'LineWidth', 0.01 },  'plane', { 'LineStyle', 'none' }, ...
        'fill', { color, 'EdgeColor', 'none', 'FaceAlpha', 1 })
    
end




