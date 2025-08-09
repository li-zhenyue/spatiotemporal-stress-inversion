function BeachBall( x, y, plane1, varargin )
% 绘制震源机制的schmidt投影
%    x,y 绘制的位置
%    plane1=[str, dip, rak], 单位：度

p = inputParser;
p.KeepUnmatched = false;
p.CaseSensitive = false;
addParameter( p, 'radius', 1 ) % 半径
addParameter( p, 'color', 'r' ) % 颜色
addParameter( p, 'AxisRatio', 1 ) % 坐标轴比例
addParameter( p, 'WhichPlane', 12 ) % 绘制哪个节面
addParameter( p, 'circle', { 'k-', 'LineWidth', 1.2 } ) 
addParameter( p, 'fill', { 'r', 'EdgeColor', 'none', 'FaceAlpha', 1 } ) 
addParameter( p, 'background', { 'w', 'EdgeColor', 'none', 'FaceAlpha', 1 } ) 
addParameter( p, 'plane', { 'k-', 'LineWidth', 1 } ) 
addParameter( p, 'CreatFigure', true ) 
parse( p, varargin{ : } )

r = p.Results.radius;
axis_ratio = p.Results.AxisRatio;

[ plane2, ~, ~, T ] = PlaneConvert( plane1 );

% 两个节面的投影点坐标
coord = faults_Schmidt_projection( [ plane1; plane2 ], r );
x1 = coord{ 1 }( :, 1 ); 
y1 = coord{ 1 }( :, 2 );
x2 = coord{ 2 }( :, 1 );
y2 = coord{ 2 }( :, 2 );

% 两个节面与赤道圆的四个交点与正 x 轴的角度[-pi,pi]
alpha1 = atan2( y1( 1 ), x1( 1 ) );
alpha2 = atan2( y1( end ), x1( end ) );
alpha3 = atan2( y2( 1 ), x2( 1 ) );
alpha4 = atan2( y2( end ), x2( end ) );

n = 100;
if abs( alpha2 - alpha3 ) > pi
    beta1 = linspace( alpha2, alpha2 + sign( alpha2 ) * ( 2 * pi - abs( alpha2 - alpha3 ) ), n );
else
    beta1 = linspace( alpha2, alpha3, n );
end
if abs( alpha4 - alpha1 ) > pi
    beta2 = linspace( alpha4, alpha4 + sign( alpha4 ) * ( 2 * pi - abs( alpha4 - alpha1 ) ), n );
else
    beta2 = linspace( alpha4, alpha1, n );
end

x3 = r * cos( beta1 ); 
y3 = r * sin( beta1 );
x4 = r * cos( beta2 ); 
y4 = r * sin( beta2 );

xfill = [ x1', x3, x2', x4 ]; 
yfill = [ y1', y3, y2', y4 ];

%投影赤道圆的坐标
theta = linspace( 0, 2*pi, 2*n );
xequ = r * cos( theta ); 
yequ = r * sin( theta );

if p.Results.CreatFigure
    figure( 'color', 'w' )
end
hold on

% 判断填充哪个象限
T_az = T( 1 ) * pi/180;
T_pl = T( 2 ) * pi/180;
T_vec = [ cos( T_pl ) * cos( T_az ), cos( T_pl ) * sin( T_az ), sin( T_pl ) ];
str1 = plane1( 1 ) * pi/180;  
dip1 = plane1( 2 ) * pi/180;
str2 = plane2( 1 ) * pi/180;  
dip2 = plane2( 2 ) * pi/180;
n1 = [-sin( str1 ) * sin( dip1 ), cos( str1 ) * sin( dip1 ), -cos( dip1 ) ]; % 节面1的法向
n2 = [-sin( str2 ) * sin( dip2 ), cos( str2 ) * sin( dip2 ), -cos( dip2 ) ]; % 节面2的法向
sumn = ( n1 + n2 ) / sqrt( 2 );

if abs( T_vec * sumn' ) - cosd( 5 ) > 0
    fill( x +  xequ * axis_ratio, y + yequ,  p.Results.background{ : } )
    fill( x + xfill * axis_ratio, y + yfill, p.Results.fill{ : } )
else
    fill( x +  xequ * axis_ratio, y + yequ,  p.Results.fill{ : } )
    fill( x + xfill * axis_ratio, y + yfill, p.Results.background{ : } )
end

plot( x + xequ * axis_ratio, y + yequ, p.Results.circle{ : } )
if  p.Results.WhichPlane == 1
    plot( x + x1 * axis_ratio, y + y1, p.Results.plane{ : } )
elseif p.Results.WhichPlane == 2
    plot( x + x2 * axis_ratio, y + y2, p.Results.plane{ : } )
else
    plot( x + x1 * axis_ratio, y + y1, p.Results.plane{ : } )
    plot( x + x2 * axis_ratio, y + y2, p.Results.plane{ : } )
end


end

function coord = faults_Schmidt_projection( faults, radius )
% 断层下半球等面积投影的坐标

n_faults = size( faults, 1 );
n_rake = 100;

coord = cell( n_faults, 1 );
for i = 1 : n_faults
    strike = ones( n_rake, 1 ) * faults( i, 1 );
    dip    = ones( n_rake, 1 ) * faults( i, 2 );
    rake   = linspace( -180, 0, n_rake )';
    [ x, y, ~ ] = slip_direction_projection( [ strike, dip, rake ], radius );
    coord{ i } = [ x, y ];
end


end

function [ x, y, vector_sign ] = slip_direction_projection( sdr, radius )

sdr = sdr * pi/180;
strike = sdr( :, 1 );
dip    = sdr( :, 2 );
rake   = sdr( :, 3 );

% 断层走向为 x 轴，走向顺时针旋转 90°为 y 轴，竖直向下为 z 轴建立坐标系
slip_z = - sin( rake ) .* sin( dip );
slip_x =   cos( rake );
slip_y = - sin( rake ) .* cos( dip );

ih = acos( abs( slip_z ) ); % 离源角
strk = atan2( slip_y, slip_x ); % 断层坐标系下滑动方向的走向

ind = strk < 0;
strk( ind ) = strk( ind ) + pi;
slip_strike = strike + strk;

x = radius * sqrt( 2 ) * sin( ih / 2 ) .* sin( slip_strike );
y = radius * sqrt( 2 ) * sin( ih / 2 ) .* cos( slip_strike );

vector_sign = ones( length( strike ), 1 );
vector_sign( ind ) = -1;


end


