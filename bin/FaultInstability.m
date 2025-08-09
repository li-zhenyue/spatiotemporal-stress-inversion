function instability = FaultInstability( stress_tensor, plane, friction, varargin )
% 计算断层的失稳系数
% 默认输入应力张量的符号为 [ 挤压为负 ]，可通过如下方式指定应力的符号
%     instability = FaultInstability( stress_tensor, plane, friction, 'CompressionSign', 'positive' )

p = inputParser;
addOptional( p, 'CompressionSign', 'negative' )
parse( p, varargin{ : } );

if strcmp( p.Results.CompressionSign, 'negative' )
    stress_tensor = - stress_tensor;
elseif ~strcmp( p.Results.CompressionSign, 'positive' )
    error( 'Incorrect parameter input !' )
end

d = sort( eig( stress_tensor ), 'descend' );
s1 = d( 1 ); s3 = d( 3 );
nc = ( s1 + s3 ) / 2 - ( s1 - s3 ) * friction / 2 / sqrt( 1 + friction^2 );
sc = ( s1 - s3 ) / 2 / sqrt( 1 + friction^2 );

[ sn, ss ] = normal_shear_stress( stress_tensor, plane );
instability = ( ss - friction * ( sn - s1 ) ) / ( sc - friction * ( nc - s1 ) );


end