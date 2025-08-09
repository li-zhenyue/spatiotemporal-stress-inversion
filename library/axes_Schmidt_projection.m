function [ tx, ty ] = axes_Schmidt_projection( T, radius )
% project axis

Tstr = T( :, 1 ) * pi/180;
Tpl  = T( :, 2 ) * pi/180;

% coordinate of T axis
tx = radius * sqrt( 2 ) * sin( ( pi/2 - Tpl ) / 2 ) .* sin( Tstr );
ty = radius * sqrt( 2 ) * sin( ( pi/2 - Tpl ) / 2 ) .* cos( Tstr );


end