function [ faults, instability ] = SelectFaults( m, fms, friction )
% 根据失稳准则从震源机制的两个节面中选择发震断层面

ngrp = length( fms );
m = reshape( m, 5, ngrp );
faults = cell( ngrp, 1 );
instability = cell( ngrp, 1 );

for i = 1 : ngrp
    
    NP1 = fms{ i };
    NP2 = PlaneConvert( NP1 );
    nbr = size( NP1, 1 );
    
    ST = m2stresstensor( m( :, i ) );
    ins1 = FaultInstability( ST, NP1, friction( i ) );
    ins2 = FaultInstability( ST, NP2, friction( i ) );
    idx = ins1 - ins2 > 0;
    
    selected = nan( nbr, 3 );
    selected( idx, : ) = NP1( idx, : );
    selected(~idx, : ) = NP2(~idx, : );
    faults{ i } = selected;
    
    ins = nan( nbr, 1 );
    ins( idx ) = ins1( idx );
    ins(~idx ) = ins2(~idx );
    instability{ i } = ins;
    
end


end







