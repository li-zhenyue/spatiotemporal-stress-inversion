function groups = plot_SHmax( groups )

groups = SHmax_uncertiry_range( groups );
ngrp = size( groups, 1 );

figure( 'color', 'w' )
hold on
axis equal
box on
% grid on

r = 0.5;
SH_range = groups.SH_range * pi/180;
nn = 50;
for i = 1 : ngrp
    optimal_stress = m2stresstensor( groups.stress{ i } );
    [ s1_optimal, s2_optimal, s3_optimal, ~ ] = stress_tensor_decomposition( optimal_stress );
    [ ~, s1_plunge ] = vector_to_azimuth_and_plunge( s1_optimal );
    [ ~, s2_plunge ] = vector_to_azimuth_and_plunge( s2_optimal );
    [ ~, s3_plunge ] = vector_to_azimuth_and_plunge( s3_optimal );
    type = StressType( s1_plunge, s2_plunge, s3_plunge );
    switch type
        case { 'NF', 'NS' }
            color = 'g';
        case { 'TF', 'TS' }
            color = 'r';
        case 'SS'
            color = 'b';
        case 'U'
            color = 'k';
    end
    
    x = r * [ 0, sin( linspace( SH_range( i, 1 ), SH_range( i, 2 ), nn ) ), 0 ];
    y = r * [ 0, cos( linspace( SH_range( i, 1 ), SH_range( i, 2 ), nn ) ), 0 ];
    fill(  x + groups.centroid( i, 1 ),  y + groups.centroid( i, 2 ), color, 'EdgeColor', 'none' )
    fill( -x + groups.centroid( i, 1 ), -y + groups.centroid( i, 2 ), color, 'EdgeColor', 'none' )
    
end



end

function groups = SHmax_uncertiry_range( groups )

optimal = cell2mat( groups.stress );
statistics = cell2mat( groups.stress_statistics );

realizations = size( statistics, 2 );
angle = nan( 1, realizations );
for i = 1 : realizations
    angle( i ) = acos( optimal' * statistics( :, i ) / ( norm( optimal ) * norm( statistics( :, i ) ) ) ) * 180/pi;
end

% 95% 的置信区间
sorted_angle = sort( angle, 'ascend' );
idx = angle - sorted_angle( round( realizations * 0.95 ) ) < 0;
nbr = sum( idx );
ngrp = size( groups, 1 );
nominee = mat2cell( statistics( :, idx ), ones( 1, ngrp ) * 5 );

SH_range = nan( ngrp, 2 );
for i = 1 : ngrp
    SH_statistics = nan( 1, nbr );
    for j = 1 : nbr
        stress_tensor = m2stresstensor( nominee{ i }( :, j ) );
        SH_statistics( j ) = azimuth_of_horizontal_pricipal_stress( - stress_tensor );
    end
    
    min_az = min( SH_statistics );
    azdif = SH_statistics - min_az;
    idx = azdif > 90;
    azdif( idx ) = 180 - azdif( idx );
    max_az = min_az + max( azdif );
    
    SH_range( i, : ) = [ min_az, max_az ];

end

groups.SH_range = SH_range;


end







