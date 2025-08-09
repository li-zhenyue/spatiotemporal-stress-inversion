function [ s1_vector, s2_vector, s3_vector, R ] = stress_tensor_decomposition( stress_tensor, varargin )
% 根据应力张量得到三个主轴的方向以及三个主应力的相对大小

p = inputParser;
addOptional( p, 'CompressionSign', -1 )
parse( p, varargin{ : } )

stress_tensor = p.Results.CompressionSign * stress_tensor;

[ V, D ] = eig( stress_tensor );
[ d, ind ] = sort( diag( D ), 'descend' );
vector = V( :, ind );
s1_vector = vector( :, 1 );
s2_vector = vector( :, 2 );
s3_vector = vector( :, 3 );
R = ( d( 1 ) - d( 2 ) ) / ( d( 1 ) - d( 3 ) );


end