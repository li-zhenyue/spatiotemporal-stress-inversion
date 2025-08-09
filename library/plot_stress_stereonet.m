function plot_stress_stereonet( groups )

ngrp = size( groups, 1 );
ns = size( groups.stress_statistics{ 1 }, 2 );
figure( 'color', 'w' )
axis on
box on
grid on

for i = 1 : ngrp
    
     optimal_stress = m2stresstensor( groups.stress{ i } );
     [ s1_vector, s2_vector, s3_vector, R ] = stress_tensor_decomposition( optimal_stress );
     [ s1_az, s1_pl ] = vector_to_azimuth_and_plunge( s1_vector );
     [ s2_az, s2_pl ] = vector_to_azimuth_and_plunge( s2_vector );
     [ s3_az, s3_pl ] = vector_to_azimuth_and_plunge( s3_vector );
     optimal = [ s1_az, s1_pl, s2_az, s2_pl, s3_az, s3_pl, R ];
     
     statistics = nan( ns, 7 );
     for j = 1 : ns
         stress = m2stresstensor( groups.stress_statistics{ i }( :, j ) );
         [ s1_vector, s2_vector, s3_vector, R ] = stress_tensor_decomposition( stress );
         [ s1_az, s1_pl ] = vector_to_azimuth_and_plunge( s1_vector );
         [ s2_az, s2_pl ] = vector_to_azimuth_and_plunge( s2_vector );
         [ s3_az, s3_pl ] = vector_to_azimuth_and_plunge( s3_vector );
         statistics( j, : ) = [ s1_az, s1_pl, s2_az, s2_pl, s3_az, s3_pl, R ];
     end
     
     StressStereonet( optimal, statistics,  'radius', 0.6, 'position', groups.centroid( i, : ),...
         'CircleWidth', 0.8, 'MarkerSize', 15, 'OptimalWidth', 1.2, 'CreatFigure', false )
     
end



end

