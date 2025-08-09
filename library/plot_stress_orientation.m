function plot_stress_orientation( groups )

ngrp = size( groups, 1 );
s1_azimuth = nan( ngrp, 1 ); s1_plunge = nan( ngrp, 1 );
s2_azimuth = nan( ngrp, 1 ); s2_plunge = nan( ngrp, 1 );
s3_azimuth = nan( ngrp, 1 ); s3_plunge = nan( ngrp, 1 );
R = nan( ngrp, 1 );
for i = 1 : ngrp
    ST = m2stresstensor( groups.stress{ i } );
    [ s1_vector, s2_vector, s3_vector, R( i ) ] = stress_tensor_decomposition( ST );
    [ s1_azimuth( i ), s1_plunge( i ) ] = vector_to_azimuth_and_plunge( s1_vector );
    [ s2_azimuth( i ), s2_plunge( i ) ] = vector_to_azimuth_and_plunge( s2_vector );
    [ s3_azimuth( i ), s3_plunge( i ) ] = vector_to_azimuth_and_plunge( s3_vector );
end

figure( 'color', 'w' )
hold on

len = 0.7;
for i = 1 : ngrp
    quiver( groups.centroid( i, 1 ), groups.centroid( i, 2 ), len * sind( s1_azimuth( i ) ) * cosd( s1_plunge( i ) ),  len * cosd( s1_azimuth( i ) ) * cosd( s1_plunge( i ) ),...
        'color', 'r', 'Linewidth', 1.5, 'ShowArrowHead', 'off' )
    quiver( groups.centroid( i, 1 ), groups.centroid( i, 2 ), len * sind( s1_azimuth( i ) + 180 ) * cosd( s1_plunge( i ) ),  len * cosd( s1_azimuth( i ) + 180 ) * cosd( s1_plunge( i ) ),...
        'color', 'r', 'Linewidth', 1.5, 'ShowArrowHead', 'off' )
    
    quiver( groups.centroid( i, 1 ), groups.centroid( i, 2 ), len * sind( s2_azimuth( i ) ) * cosd( s2_plunge( i ) ),  len * cosd( s2_azimuth( i ) ) * cosd( s2_plunge( i ) ),...
        'color', 'g', 'Linewidth', 1.5, 'ShowArrowHead', 'off' )
    quiver( groups.centroid( i, 1 ), groups.centroid( i, 2 ), len * sind( s2_azimuth( i ) + 180 ) * cosd( s2_plunge( i ) ),  len * cosd( s2_azimuth( i ) + 180 ) * cosd( s2_plunge( i ) ),...
        'color', 'g', 'Linewidth', 1.5, 'ShowArrowHead', 'off' )
    
    quiver( groups.centroid( i, 1 ), groups.centroid( i, 2 ), len * sind( s3_azimuth( i ) ) * cosd( s3_plunge( i ) ),  len * cosd( s3_azimuth( i ) ) * cosd( s3_plunge( i ) ),...
        'color', 'b', 'Linewidth', 1.5, 'ShowArrowHead', 'off' )
    quiver( groups.centroid( i, 1 ), groups.centroid( i, 2 ), len * sind( s3_azimuth( i ) + 180 ) * cosd( s3_plunge( i ) ),  len * cosd( s3_azimuth( i ) + 180 ) * cosd( s3_plunge( i ) ),...
        'color', 'b', 'Linewidth', 1.5, 'ShowArrowHead', 'off' )
end

scatter( groups.centroid( :, 1 ), groups.centroid( :, 2 ), 40,  R, 'filled', 'marker', 'o', 'MarkerEdgeColor', 'k' )
caxis( [ 0 , 1 ] )
c = colorbar;
c.Label.String = 'R';
colormap( jet( 256 ) )
box on
grid on
set( gca, 'fontsize', 12 )
xlabel( 'longitude / \circ ' )
ylabel( 'latitude / \circ ' )


end

