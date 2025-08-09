function [ azimuth, plunge ] = vector_to_azimuth_and_plunge( vector )

if vector( 3 ) < 0
    vector = - vector; % ÏÂ°ëÇòÍ¶Ó°
end

plunge = pi/2 - acos( vector( 3 ) );
azimuth = atan2( vector( 2 ), vector( 1 ) );

plunge = plunge * 180/pi;
azimuth = azimuth * 180/pi;


end