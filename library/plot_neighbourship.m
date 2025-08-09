function plot_neighbourship( centroid, pairs )

ngrp = size( centroid, 1 );
for i = 1 : ngrp
    idx = find( pairs( :, i ) );
    color = 'r';
    for j = 1 : length( idx )
        line( [centroid( i, 1 ), centroid( idx( j ), 1 )], [centroid( i, 2 ), centroid( idx( j ), 2 )], 'color', color, 'LineWidth', 2 )
    end
end

end