function pairs = neighbouring_relations( grid_coordinate )
% 确定不同分组之间的相邻关系
% grid_coordinate 是不同分组的网格点坐标
% 输出的 pairs 方阵记录了不同分组之间的相邻关系，矩阵的第 i 列中为 1 的元素
%   所在行序号是与第 i 组相临近的组

ngrp = size( grid_coordinate, 1 );
pairs = false( ngrp ); % 记录相邻关系
for k = 1 : ngrp - 1
    
    % 行相同，列不同的邻区对
    idx1 = abs( grid_coordinate( ( k + 1 ) : ngrp, 1 ) - grid_coordinate( k, 1 ) ) == 0 & ...
        abs( grid_coordinate( ( k + 1 ) : ngrp, 2 ) - grid_coordinate( k, 2 ) ) == 1;
    
    % 行不同，列相同的邻区对
    idx2 = abs( grid_coordinate( ( k + 1 ) : ngrp, 1 ) - grid_coordinate( k, 1 ) ) == 1 & ...
        abs( grid_coordinate( ( k + 1 ) : ngrp, 2 ) - grid_coordinate( k, 2 ) ) == 0;
    
    indx = idx1 | idx2;
    pairs( :, k ) = vertcat( false( k, 1 ), indx );
    
end


end