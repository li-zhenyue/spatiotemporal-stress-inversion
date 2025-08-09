function [ ns, ss ] = normal_shear_stress( stress_tensor, faults )

strike = faults( :, 1 ) * pi/180;
dip    = faults( :, 2 ) * pi/180;
N = length( strike );

% 法向
n1 = - sin( dip ) .* sin( strike );
n2 =   sin( dip ) .* cos( strike );
n3 = - cos( dip );

ns = nan( N, 1 ); % normal stress
ss = nan( N, 1 ); % shear stress
for i = 1 : N
    
    normal = [ n1( i ), n2( i ), n3( i ) ];
    p = stress_tensor * normal';
    ns( i ) = normal * p;
    ss_vector = p - ns( i ) * normal';
    ss( i ) = norm( ss_vector );
    
end


end