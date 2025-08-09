function [ G, d, L ] = coefficient_matrix( fms, pairs )
% 基于分组后的断层面 fms（元胞数组，每个元胞是一个分组的震源机制），及其对应的
% 网格坐标 grid_coordinate 构造求解应力的系数矩阵

% 核矩阵以及数据矩阵
ngrp = length( fms );
G = cell( ngrp, ngrp );
d = cell( ngrp, 1 );
for i = 1 : ngrp
    nfms = size( fms{ i }, 1 );
    for j = 1 : ngrp
        if i == j
            [ G{ i, j }, d{ i } ] = linearization( fms{ i } );
        else
            G{ i, j } = zeros( 3 * nfms, 5 );
        end
    end
end

G = cell2mat( G );
d = cell2mat( d );

% 构造平滑矩阵
n_neighbors = sum( pairs, 'all' ); % 相邻对的个数
L = cell( n_neighbors, ngrp );
for i = 1 : n_neighbors
    for j = 1 : ngrp
        L{ i, j } = zeros( 5 );
    end
end

n = 0;
for i = 1 : ngrp
    k = find( pairs( :, i ) );
    if ~isempty( k )
        for j = 1 : length( k )
            n = n + 1;
            L{ n, i } = eye( 5 );
            L{ n, k( j ) } = - eye( 5 );
        end
    end
end

L = cell2mat( L );


end



function [ A, s ] = linearization( sdr )

sdr = sdr * pi/180;
strike = sdr( :, 1 );
dip = sdr( :, 2 );
rake = sdr( :, 3 );

% 法向和滑动方向
n1 = - sin( dip ) .* sin( strike );
n2 =   sin( dip ) .* cos( strike );
n3 = - cos( dip );

v1 =   cos( rake ) .* cos( strike ) + cos( dip ) .* sin( rake ) .* sin( strike );
v2 =   cos( rake ) .* sin( strike ) - cos( dip ) .* sin( rake ) .* cos( strike );
v3 = - sin( rake ) .* sin( dip );

% 构建系数矩阵 A
A11 = n1 .* ( n2.^2 + 2 * n3.^2 );
A12 = n2 .* ( 1 - 2 * n1.^2 );
A13 = n3 .* ( 1 - 2 * n1.^2 );
A14 = n1 .* ( - n2.^2 + n3.^2 );
A15 = - 2 * n1 .* n2 .* n3;

A21 = n2 .* ( - n1.^2 + n3.^2 );
A22 = n1 .* ( 1 - 2 * n2.^2 );
A23 = - 2 * n1 .* n2 .* n3;
A24 = n2 .* ( n1.^2 + 2 * n3.^2 );
A25 = n3 .* ( 1 - 2 * n2.^2 );

A31 = n3 .* ( - 2 * n1.^2 - n2.^2 );
A32 = - 2 * n1 .* n2 .* n3;
A33 = n1 .* ( 1 - 2 * n3.^2 );
A34 = n3 .* ( - n1.^2 - 2 * n2.^2 );
A35 = n2 .* ( 1 - 2 * n3.^2 );

N = length( strike ) * 3;
A = zeros( N, 5 );
A( 1 : 3 : N, 1 ) = A11; A( 1 : 3 : N, 2 ) = A12; A( 1 : 3 : N, 3 ) = A13; A( 1 : 3 : N, 4 ) = A14; A( 1 : 3 : N, 5 ) = A15;
A( 2 : 3 : N, 1 ) = A21; A( 2 : 3 : N, 2 ) = A22; A( 2 : 3 : N, 3 ) = A23; A( 2 : 3 : N, 4 ) = A24; A( 2 : 3 : N, 5 ) = A25;
A( 3 : 3 : N, 1 ) = A31; A( 3 : 3 : N, 2 ) = A32; A( 3 : 3 : N, 3 ) = A33; A( 3 : 3 : N, 4 ) = A34; A( 3 : 3 : N, 5 ) = A35;

% 滑动矢量矩阵 s
v = [ v1, v2, v3 ]';
s = reshape( v, N, 1 );


end


