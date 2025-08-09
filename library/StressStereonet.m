function StressStereonet( optimal, statistics, varargin )

[ radius, position, circle_width, marker_size, optimal_width, creat_figure, orientation ] = input_parser( varargin );
x = position( 1 );
y = position( 2 );

s1_optimal = optimal( 1 : 2 );
s2_optimal = optimal( 3 : 4 );
s3_optimal = optimal( 5 : 6 );
s1_statistics = statistics( :, 1 : 2 );
s2_statistics = statistics( :, 3 : 4 );
s3_statistics = statistics( :, 5 : 6 );

[ s1_optimal_x, s1_optimal_y ] = axes_Schmidt_projection( s1_optimal, radius );
[ s2_optimal_x, s2_optimal_y ] = axes_Schmidt_projection( s2_optimal, radius );
[ s3_optimal_x, s3_optimal_y ] = axes_Schmidt_projection( s3_optimal, radius );
[ s1_statistics_x, s1_statistics_y ] = axes_Schmidt_projection( s1_statistics, radius );
[ s2_statistics_x, s2_statistics_y ] = axes_Schmidt_projection( s2_statistics, radius );
[ s3_statistics_x, s3_statistics_y ] = axes_Schmidt_projection( s3_statistics, radius );

if creat_figure
    figure( 'color', 'w' )
end
hold on
% axis equal
    
% projected circle
phi = linspace( 0, 2 * pi, 100 );
fill( x + radius * cos( phi ), y + radius * sin( phi ), 'w', 'EdgeColor', 'k', 'LineWidth', circle_width )
% plot( x + radius * cos( phi ), y + radius * sin( phi ), 'k-', 'LineWidth', circle_width )
color = [0.9, 0.9, 0.9];
for r = 0.2 : 0.2 : 0.8
    plot( x + radius * r * cos( phi ), y + radius * r * sin( phi ), 'color', color, 'LineWidth', circle_width * 0.7 )
end
line( x + [0, 0], y + [-1, 1] * radius, 'LineStyle', '-', 'color', color, 'LineWidth', circle_width * 0.7 )
line( x + [-1, 1] * radius, y + [0, 0], 'LineStyle', '-', 'color', color, 'LineWidth', circle_width * 0.7 )
line( x + [-cosd(30), cosd(30)] * radius, y + [sind(30), -sind(30)] * radius, 'LineStyle', '-', 'color', color, 'LineWidth', circle_width * 0.7 )
line( x + [-cosd(60), cosd(60)] * radius, y + [sind(60), -sind(60)] * radius, 'LineStyle', '-', 'color', color, 'LineWidth', circle_width * 0.7 )
line( x + [-cosd(30), cosd(30)] * radius, y + [-sind(30), sind(30)] * radius, 'LineStyle', '-', 'color', color, 'LineWidth', circle_width * 0.7 )
line( x + [-cosd(60), cosd(60)] * radius, y + [-sind(60), sind(60)] * radius, 'LineStyle', '-', 'color', color, 'LineWidth', circle_width * 0.7 )

if orientation
    line( [0, 0], [1, 1.1] * radius, 'color', 'k', 'LineWidth', circle_width ); 
    text( 0, 1.16 * radius, 'N', 'FontName', 'TimesNewRoman', 'FontSize', 14, 'color', 'k', 'HorizontalAlignment', 'center' ) %N
    line( [0, 0], -[1, 1.1] * radius, 'color', 'k', 'LineWidth', circle_width ); 
    text( 0, -1.16 * radius, 'S', 'FontName', 'TimesNewRoman', 'FontSize', 14, 'color', 'k', 'HorizontalAlignment', 'center' ) %S
    line( -[1.1, 1] * radius, [0, 0], 'color', 'k', 'LineWidth', 1.5 ); 
    text( -1.185 * radius, 0, 'W', 'FontName', 'TimesNewRoman', 'FontSize', 14, 'color', 'k', 'HorizontalAlignment', 'center' ) %W
    line( [1, 1.1] * radius, [0, 0], 'color', 'k', 'LineWidth', 1.5 ); 
    text( 1.16 * radius, 0, 'E', 'FontName', 'TimesNewRoman', 'FontSize', 14, 'color', 'k', 'HorizontalAlignment', 'center' ) %E
end

sz = marker_size;
scatter( x + s1_statistics_x, y + s1_statistics_y, sz, 'o', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [255  0   0]/255, 'MarkerFaceAlpha', 0.5 ) % sigma1 uncertity
scatter( x + s2_statistics_x, y + s2_statistics_y, sz, 'o', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [154 205 50]/255, 'MarkerFaceAlpha', 0.5 ) % sigma2 uncertity
scatter( x + s3_statistics_x, y + s3_statistics_y, sz, 'o', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [30 144 255]/255, 'MarkerFaceAlpha', 0.5 ) % sigma3 uncertity

% optimal stress
sz = marker_size * 2;
scatter( x + s1_optimal_x, y + s1_optimal_y, sz, 'k+', 'LineWidth', optimal_width ) % sigma1 
scatter( x + s2_optimal_x, y + s2_optimal_y, sz, 'k+', 'LineWidth', optimal_width ) % sigma2 
scatter( x + s3_optimal_x, y + s3_optimal_y, sz, 'k+', 'LineWidth', optimal_width ) % sigma3 


end


function [ radius, position, circle_width, marker_size, optimal_width, creat_figure, orientation ] = input_parser( varargin )

idx = find( strcmp( varargin{ : }, 'radius' ) );
if ~isempty( idx )
    radius = varargin{ : }{ idx + 1 };
else
    radius = 1;
end

idx = find( strcmp( varargin{ : }, 'position' ) );
if ~isempty( idx )
    position = varargin{ : }{ idx + 1 };
else
    position = [0, 0];
end

idx = find( strcmp( varargin{ : }, 'CircleWidth' ) );
if ~isempty( idx )
    circle_width = varargin{ : }{ idx + 1 };
else
    circle_width = 1.2;
end

idx = find( strcmp( varargin{ : }, 'MarkerSize' ) );
if ~isempty( idx )
    marker_size = varargin{ : }{ idx + 1 };
else
    marker_size = 50;
end

idx = find( strcmp( varargin{ : }, 'OptimalWidth' ) );
if ~isempty( idx )
    optimal_width = varargin{ : }{ idx + 1 };
else
    optimal_width = 1.5;
end

idx = find( strcmp( varargin{ : }, 'CreatFigure' ) );
if ~isempty( idx )
    creat_figure = varargin{ : }{ idx + 1 };
else
    creat_figure = true;
end

idx = find( strcmp( varargin{ : }, 'orientation' ) );
if ~isempty( idx )
    orientation = varargin{ : }{ idx + 1 };
else
    orientation = false;
end


end

function [ tx, ty ] = axes_Schmidt_projection( T, radius )
% project axis

Tstr = T( :, 1 ) * pi/180;
Tpl  = T( :, 2 ) * pi/180;

% coordinate of T axis
tx = radius * sqrt( 2 ) * sin( ( pi/2 - Tpl ) / 2 ) .* sin( Tstr );
ty = radius * sqrt( 2 ) * sin( ( pi/2 - Tpl ) / 2 ) .* cos( Tstr );


end



