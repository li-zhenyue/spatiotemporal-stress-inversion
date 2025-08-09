function [ groups, m_evolution ] = iterative_stress_inversion_2D( groups, pairs, iterations, varargin )
% 考虑剪应力大小的二维应力场迭代反演
% 根据失稳准则选择发震断层面
% 例: groups = iterative_stress_inversion_2D( groups, iterations, 'lamuda', 1, 'InitialIterations', 10, 'InvertShearStress', false )

[ lamuda, initial_iterations, invert_shear_stress ] = input_parser( varargin );
ngrp = size( groups, 1 );

m0 = nan( 5 * ngrp, initial_iterations );
for i = 1 : initial_iterations
    
    % 各分组随机选择断层面，估计初始应力
    NP1 = cell2mat( groups.fms );
    NP2 = PlaneConvert( NP1 );
    nfms = size( NP1, 1 );
    idx = rand( nfms, 1 ) - 0.5 > 0;
    selected = nan( nfms, 3 );
    selected( idx, : ) = NP1( idx, : );
    selected(~idx, : ) = NP2(~idx, : );
    faults = mat2cell( selected, groups.number );
    
    [ G, d, L ] = coefficient_matrix( faults, pairs );
    m_i = ( G' * G + lamuda^2 * ( L' * L ) ) \ G' * d;
    
    m0( :, i ) = normalize_stress( m_i );
    
end

m0 = normalize_stress( sum( m0, 2 ) );

% 迭代选择断层面和反演应力场
m_evolution = nan( 5 * ngrp, iterations + 1 );
m_evolution( :, 1 ) = m0;
for i = 1 : iterations
    
    [ faults, instability ] = SelectFaults( m0, faults, groups.friction );
    [ G, d, L ] = coefficient_matrix( faults, pairs );
    
    if invert_shear_stress
        ss = ShearStress( m0, faults );
        d = d .* ss;
    end
    
    generalized_inverse = ( G' * G + lamuda^2 * ( L' * L ) ) \ G';
    m = generalized_inverse * d;
    m = normalize_stress( m );
    m0 = m;
    
    m_evolution( :, i + 1 ) = m;
    
end

groups.faults = faults; % 选择的发震断层面
groups.stress = mat2cell( m, ones( 1, ngrp ) * 5 );
groups.instability = instability;


end


function [ lamuda, initial_iterations, invert_shear_stress ] = input_parser( varargin )

idx = find( strcmp( varargin{ : }, 'lamuda' ) );
if ~isempty( idx )
    lamuda = varargin{ : }{ idx + 1 };
else
    lamuda = 1;
end

idx = find( strcmp( varargin{ : }, 'InitialIterations' ) );
if ~isempty( idx )
    initial_iterations = varargin{ : }{ idx + 1 };
else
    initial_iterations = 10;
end

idx = find( strcmp( varargin{ : }, 'InvertShearStress' ) );
if ~isempty( idx )
    invert_shear_stress = varargin{ : }{ idx + 1 };
else
    invert_shear_stress = false;
end


end

function ss = ShearStress( m, faults )

ngrp = length( faults );
m = reshape( m, 5, ngrp );
tau = cell( ngrp, 1 );
for i = 1 : ngrp
    ST = m2stresstensor( m( :, i ) );
    [ ~, tau{ i } ] = normal_shear_stress( ST, faults{ i } );
end

tau = cell2mat( tau );
ss = nan( 3 * length( tau ), 1 );
ss( 1 : 3 : end ) = tau;
ss( 2 : 3 : end ) = tau;
ss( 3 : 3 : end ) = tau;


end

function normalized = normalize_stress( m )

ngrp = length( m ) / 5;
m = reshape( m, 5, ngrp );
normalized = nan( 5, ngrp );
for i = 1 : ngrp
    ST = m2stresstensor( m( :, i ) );
    normalized( :, i ) = m( :, i ) / norm( ST );
end

normalized = reshape( normalized, 5 * ngrp, 1 );


end




