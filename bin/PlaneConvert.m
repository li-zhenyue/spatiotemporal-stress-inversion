function [ NP2, P, B, T ] = PlaneConvert( NP1 )
% 根据一个断层节面的参数得到另外一个断层节面和 PBT 轴的参数
%   NP1=[strike, dip, rake]
%   P=[strike, plunge]
%   输入和输出均为角度，可输入多个节面，每行是一个节面

NP1 = NP1 * pi/180;
strike = NP1( :, 1 ); 
dip = NP1( :, 2 ); 
rake = NP1( :, 3 );
num = length( strike );

% 法向
n1 = - sin( strike ) .* sin( dip );
n2 =   cos( strike ) .* sin( dip );
n3 = - cos( dip );

% 滑动矢量
v1 =   cos( strike ) .* cos( rake ) + sin( strike ) .* cos( dip ) .* sin( rake );
v2 =   sin( strike ) .* cos( rake ) - cos( strike ) .* cos( dip ) .* sin( rake );
v3 = - sin( dip ) .* sin( rake );

NP2 = nan( num, 3 );
P = nan( num, 2 );
B = nan( num, 2 );
T = nan( num, 2 );
for i = 1 : num
    
    n = [ n1( i ), n2( i ), n3( i ) ];
    v = [ v1( i ), v2( i ), v3( i ) ];
    
    [ NP2( i, 1 ), NP2( i, 2 ), NP2( i, 3 ) ] = normalslip2sdr( v, n );
    
    P_vector = n - v;
    P_vector = P_vector / norm( P_vector );
    T_vector = n + v;
    T_vector = T_vector / norm( T_vector );
    B_vector = cross( P_vector, T_vector );
    B_vector = B_vector / norm( B_vector );
    
    [ P( i, 1 ), P( i, 2 ) ] = Vector2StrikeAndPlunge( P_vector );
    [ T( i, 1 ), T( i, 2 ) ] = Vector2StrikeAndPlunge( T_vector );
    [ B( i, 1 ), B( i, 2 ) ] = Vector2StrikeAndPlunge( B_vector );
    
end


end


function [ strike, dip, rake ] = normalslip2sdr( n, v )
% 由断层面法向和滑动方向得到走向、倾角和滑动角
% n 法向，v 滑动方向

if n( 3 ) > 0
    n = - n;
    v = - v;
end

% 倾角
dip = acos( - n( 3 ) );

% 走向
strike = atan2( n( 2 ), n( 1 ) ) - pi/2;
if strike < 0
    strike = strike + 2 * pi; 
end

% 滑动角
str_vec = [ cos( strike ), sin( strike ), 0 ];
dip_vec = [ cos( dip ) * sin( strike ), - cos( dip ) * cos( strike ), - sin( dip ) ];
rake = atan2( v * dip_vec', v * str_vec' );

strike = strike * 180/pi;
dip = dip * 180/pi;
rake = rake * 180/pi;


end


function [ strike, plunge ] = Vector2StrikeAndPlunge( vector )

if vector( 3 ) < 0
    vector = - vector; % 下半球投影
end

plunge = pi/2 - acos( vector( 3 ) );
strike = atan2( vector( 2 ), vector( 1 ) );
if strike < 0
    strike = strike + 2 * pi; 
end

plunge = plunge * 180/pi;
strike = strike * 180/pi;


end