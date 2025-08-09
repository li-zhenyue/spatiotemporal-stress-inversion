function pairs = neighbourship( centroid, min_dist, min_angle )
% 根据最小距离确定不同分区之间的相邻关系
% 如果两个分组质心的距离小于最小距离即确定为相邻关系

ngrp = size( centroid, 1 );
pairs = false( ngrp ); % 记录相邻关系

% 与质心的距离小于最小距离的其它质心
for k = 1 : ngrp
    
    v = centroid - centroid( k, : );
    d = sqrt( sum( v.^2, 2 ) );
    m = d > 1e-5 & d < min_dist;
    pairs( m, k ) = true;
    
end

for k = 1 : ngrp
    
    s = find( pairs( :, k ) );
    v = centroid( s, : ) - centroid( k, : );
    d = sqrt( sum( v.^2, 2 ) );
    
    ns = length( s );
    A = nan( ns );
    for i = 1 : ns - 1
        for j = i + 1 : ns
            A( j, i ) = acosd( v( i, : ) * v( j, : )' / ( norm( v( i, : ) ) * norm( v( j, : ) ) ) );
        end
    end
    
    [ p, q ] = find( A < min_angle );
    for i = 1 : length( p )
       if d( p( i ) ) > d( q( i ) )
           s( p( i ) ) = -1;
       else
           s( q( i ) ) = -1;
       end
    end
    s( s < 0 ) = [];
    
    k_couloum = false( ngrp, 1 );
    k_couloum( s ) = true;
    pairs( :, k ) = k_couloum;
    
end

pairs = tril( pairs ) & transpose( triu( pairs ) );


end









