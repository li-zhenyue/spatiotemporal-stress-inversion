function groups = noisy_realizations( groups, pairs, repeats, iterations, varargin )
% 通过给震源机制添加噪声，多次反演应力场评估应力场的不确定性

[ lamuda, initial_iterations, invert_shear_stress, noise ] = input_parser( varargin );
ngrp = size( groups, 1 );

% 不同分组之间的相邻关系
% pairs = neighbouring_relations( groups.grid_coordinate ); 

fms = cell2mat( groups.fms );
nfms = size( fms, 1 );
stress_statistics = nan( 5 * ngrp, repeats );
for k = 1 : repeats
    
    clc
    fprintf( '> the present realization is %d of %d \n', k, repeats )
    
    % 震源机制中添加随机噪声
    NP1 = nan( nfms, 3 );
    NP2 = nan( nfms, 3 );
    for i = 1 : nfms
        [ NP1( i, : ), NP2( i, : ) ] = noisy_mechanism( fms( i, : ), noise );
    end
    
    m0 = nan( 5 * ngrp, initial_iterations );
    for i = 1 : initial_iterations
        
        % 各分组随机选择断层面，估计初始应力
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
    for i = 1 : iterations
        
        [ faults, ~ ] = SelectFaults( m0, faults, groups.friction );
        [ G, d, L ] = coefficient_matrix( faults, pairs );
        
        if invert_shear_stress
            ss = ShearStress( m0, faults );
            d = d .* ss;
        end
        
        generalized_inverse = ( G' * G + lamuda^2 * ( L' * L ) ) \ G';
        m = generalized_inverse * d;
        m = normalize_stress( m );
        m0 = m;
        
    end
    
    stress_statistics( :, k ) = m;
    
end

stress_statistics = mat2cell( stress_statistics, ones( 1, ngrp ) * 5 );
groups.stress_statistics = stress_statistics;

groups = uncertainty_estimation( groups );


end


function [ lamuda, initial_iterations, invert_shear_stress, noise ] = input_parser( varargin )

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

idx = find( strcmp( varargin{ : }, 'noise' ) );
if ~isempty( idx )
    noise = varargin{ : }{ idx + 1 };
else
    noise = 10;
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
    ST = ST / norm( ST );
    normalized( :, i ) = transpose( [ ST( 1, 1 ), ST( 1, 2 ), ST( 1, 3 ),...
        ST( 2, 2 ), ST( 2, 3 ) ] );
end

normalized = reshape( normalized, 5 * ngrp, 1 );


end