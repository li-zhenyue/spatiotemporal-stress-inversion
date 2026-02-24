
figure

% position = readmatrix( 'stereonet_position.dat' );
position = groups.centroid;

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

ns = size( groups.stress_statistics{ 1 }, 2 );
optimal_stress_parameters = nan( category, 7 );
for i = 1 : category
    
    optimal_stress = m2stresstensor( groups.stress{ i } );
    [ s1_vector, s2_vector, s3_vector, R ] = stress_tensor_decomposition( optimal_stress );
    [ s1_az, s1_pl ] = vector_to_azimuth_and_plunge( s1_vector );
    [ s2_az, s2_pl ] = vector_to_azimuth_and_plunge( s2_vector );
    [ s3_az, s3_pl ] = vector_to_azimuth_and_plunge( s3_vector );
    optimal = [ s1_az, s1_pl, s2_az, s2_pl, s3_az, s3_pl, R ];
    optimal_stress_parameters( i, : ) = optimal;
    
    statistics = nan( ns, 7 );
    for j = 1 : ns
        stress = m2stresstensor( groups.stress_statistics{ i }( :, j ) );
        [ s1_vector, s2_vector, s3_vector, R ] = stress_tensor_decomposition( stress );
        [ s1_az, s1_pl ] = vector_to_azimuth_and_plunge( s1_vector );
        [ s2_az, s2_pl ] = vector_to_azimuth_and_plunge( s2_vector );
        [ s3_az, s3_pl ] = vector_to_azimuth_and_plunge( s3_vector );
        statistics( j, : ) = [ s1_az, s1_pl, s2_az, s2_pl, s3_az, s3_pl, R ];
    end
    
    [x, y] = m_ll2xy( position( i, 1 ), position( i, 2 ) );
    
    StressStereonet( optimal, statistics,  'radius', 0.015, 'position', [x, y],...
        'CircleWidth', 0.8, 'MarkerSize', 15, 'OptimalWidth', 1.2, 'CreatFigure', false )
    
end

groups.optimal_stress_parameters = optimal_stress_parameters;
