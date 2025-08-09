function [ noisy_plane1, noisy_plane2 ] = noisy_mechanism( plane1, noise, varargin )
% 给震源机制添加噪声
% 扰动震源机制断层面法向和滑动方向
% 添加 0 到 a（度）范围内的随机噪声, noisy_mechanism( sdr, a )
% 添加 a 到 b（度）范围内的随机噪声, noisy_mechanism( sdr, a, b )

noise = noise * pi/180;
plane1 = plane1 * pi/180;
strike = plane1( 1 ); dip = plane1( 2 ); rake = plane1( 3 );

if nargin > 2
    noise_min = noise;
    noise_max = varargin{ 1 } * pi/180;
    assert( noise_min <= noise_max, 'noise range error !' )
else
    noise_min = 0;
    noise_max = noise;
end

noise_amplitude = noise_min + tan( noise_max - noise_min ) * rand;

% 断层面法向
n = zeros( 1, 3 );
n( 1 )= -sin( dip ) * sin( strike );
n( 2 )=  sin( dip ) * cos( strike );
n( 3 )= -cos( dip );
% 滑动方向
v = zeros( 1, 3 );
v( 1 ) =  cos( rake ) * cos( strike ) + cos( dip ) * sin( rake ) * sin( strike );
v( 2 ) =  cos( rake ) * sin( strike ) - cos( dip ) * sin( rake ) * cos( strike );
v( 3 ) = -sin( rake ) * sin( dip );
% 法向与滑动方向的垂向
b = cross( n, v );
b = b / norm( b );

% 扰动法向
azimuth_random = 2 * pi * rand;
n_perpendicular = b * cos( azimuth_random ) + v * sin( azimuth_random );
n_noisy = n + n_perpendicular * noise_amplitude;
n_noisy = n_noisy / norm( n_noisy );

% 扰动b轴方向
azimuth_random = 2 * pi * rand;
b_perpendicular = n * cos( azimuth_random ) + v * sin( azimuth_random );
b_noisy = b + b_perpendicular * noise_amplitude;
b_noisy = b_noisy / norm( b_noisy );

% 扰动滑动方向
v_noisy = cross( n_noisy, b_noisy );
v_noisy = sign( v * v_noisy' ) * v_noisy / norm( v_noisy );

% 扰动后的断层面参数
[ noisy_strike1, noisy_dip1, noisy_rake1 ] = normalslip2sdr( n_noisy, v_noisy );
[ noisy_strike2, noisy_dip2, noisy_rake2 ] = normalslip2sdr( v_noisy, n_noisy );
noisy_plane1 = [ noisy_strike1, noisy_dip1, noisy_rake1 ];
noisy_plane2 = [ noisy_strike2, noisy_dip2, noisy_rake2 ];


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

