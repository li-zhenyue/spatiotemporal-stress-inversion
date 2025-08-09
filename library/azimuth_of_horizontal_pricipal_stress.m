function [ SH, Sh ] = azimuth_of_horizontal_pricipal_stress( stress_tensor )
% calculate the azimuths of maximum ( SH ) and minimum ( Sh ) horizontal principal stress
% according to the stress tensor ( in North-East-Downward coordinate )

s11 = stress_tensor( 1, 1 );
s22 = stress_tensor( 2, 2 );
s12 = stress_tensor( 1, 2 );
theta = atan( 2 * s12 / ( s11 - s22 ) ) / 2; % equation 13

second_derivative = 2 * ( s22 - s11 ) * cos( 2 * theta ) - 4 * s12 * sin( 2 * theta );
if second_derivative < 0
    SH = theta;
    Sh = theta + pi/2;
    if Sh > pi/2
        Sh = Sh - pi; 
    end 
else
    SH = theta + pi/2;
    Sh = theta;
    if SH > pi/2
        SH = SH - pi; 
    end
end

SH = SH * 180/pi;
Sh = Sh * 180/pi;


end

