function sorted_groups = adjust_groups_order( groups )
% 根据网格化以后的质心坐标对各分组重新排序
% 各分组先按行序从小到大排列，再按列序从小到大排列

[ raw, idx ] = sort( groups.grid_coordinate( :, 1 ), 'ascend' );
uniraw = unique( raw, 'sorted' );
for i = 1 : length( uniraw )
    s = find( raw == uniraw( i ) );
    if length( s ) > 1
        [ ~, m ] = sort( groups.grid_coordinate( idx( s ), 2 ), 'ascend' );
        s1 = s( m );
        idx( s ) = idx( s1 );
    end
end
sorted_groups = groups( idx, : );


end