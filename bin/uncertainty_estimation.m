function groups = uncertainty_estimation( groups )
% 估计各分区内应力的不确定性

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

uncertainty = nan( ngrp, 4 );
for i = 1 : ngrp
    
    optimal_stress = m2stresstensor( groups.stress{ i } );
    [ s1_optimal, s2_optimal, s3_optimal, R_optimal ] = stress_tensor_decomposition( optimal_stress );
    
    s1_uncertainty = nan( 1, nbr );
    s2_uncertainty = nan( 1, nbr );
    s3_uncertainty = nan( 1, nbr );
    R_uncertainty = nan( 1, nbr );
    for j = 1 : nbr
        stress_tensor = m2stresstensor( nominee{ i }( :, j ) );
        [ s1_vector, s2_vector, s3_vector, R ] = stress_tensor_decomposition( stress_tensor );
        s1_uncertainty( j ) = acos( abs( s1_optimal' * s1_vector ) ) * 180/pi;
        s2_uncertainty( j ) = acos( abs( s2_optimal' * s2_vector ) ) * 180/pi;
        s3_uncertainty( j ) = acos( abs( s3_optimal' * s3_vector ) ) * 180/pi;
        R_uncertainty( j ) = abs( R_optimal - R );
    end
    
    uncertainty( i, : ) = [ max( s1_uncertainty ), max( s2_uncertainty ), max( s3_uncertainty ), max( R_uncertainty ) ];
    
end

groups.uncertainty = uncertainty;


end


