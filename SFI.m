
clc; clear; close all

%% This section is used to load your data 
% including earthquake event longitude, latitude, magnitude, 
% and focal mechanism parameters (strike, dip, and rake).

data_file = '1_20200202FinalData0FX.xlsx';
T = readmatrix( data_file );
lat = T( :, 2 );
lon = T( :, 3 );
sdr = T( :, 6:8 );
mag = T( :, 5 );

%% This section selects data within the study area boundaries.

lon_range = [ 95.5, 107 ]; % longitude range
lat_range = [ 21, 31 ]; % latitude range

ind = lon > lon_range( 1 ) & lon < lon_range( 2 ) &...
      lat > lat_range( 1 ) & lat < lat_range( 2 );
lon = lon( ind );
lat = lat( ind );
mag = mag( ind );
sdr = sdr( ind, : );

%% The data is categorized into clusters using the k-means algorithm.

category = 20; % Define the number of clusters

[ groups, idx, C ] = focal_mechanisms_clustering( lon, lat, sdr, category );
plot_clusters( lon, lat, idx, C )
colormap( jet( category ) );

[ vx, vy ] = voronoi( C( :, 1 ), C( :, 2 ) );
plot( vx, vy, 'color', [0, 0.45, 0.74], 'Linewidth', 1 )

% Order the clusters based on the centroid longitude values in increasing order.
groups = reorder_groups( groups );

%% Establish the adjacency between different cluster groups.

% The maximum distance between two centroids defines whether 
% they are neighboring regions.
max_distance = 3; 

% If multiple neighboring regions have centroid distances to
% the same target region (main region) that are less than the 
% defined maximum distance, all such neighbors are connected to 
% the main region. However, if the angle between any two connecting 
% lines is less than the specified threshold, only the neighbor 
% with the shorter centroid distance is retained.
min_angle = 60;

pairs = neighbourship( groups.centroid, max_distance, min_angle );
plot_neighbourship( groups.centroid, pairs )

%% Determine the damping coefficient using the L-curve method

lamuda = 0 : 0.5 : 5;
[ G, d, L ] = coefficient_matrix( groups.fms, pairs );
compromise_curve( G, d, L, lamuda );

%% Solve for the optimal stress field
lamuda = 1.5; % damping coefficient
iterations = 30; % Number of iterations for solving the stress field

groups.friction = ones( category, 1 ) * 0.6;
[ groups, m_evolution ] = iterative_stress_inversion_2D( groups, pairs, iterations, 'lamuda', lamuda, 'InvertShearStress', 1 );

plot_stress_orientation( groups )

%% Assess the uncertainty of the stress result.
repeats = 500; % Number of inversions with noise added to the data.
noise = 10;

groups = noisy_realizations( groups, pairs, repeats, iterations, 'lamuda', lamuda, 'InvertShearStress', 1, 'noise', noise );

%% Plot the results
map_range = [lon_range, lat_range];

plot_stress_stereonet( groups )
plot( vx, vy, 'color', [0, 0.45, 0.74], 'Linewidth', 1 )
axis( map_range )

plot_R_uncertity( groups )

groups = plot_SHmax( groups );
plot( vx, vy, 'color', [0, 0.45, 0.74], 'Linewidth', 1 )
axis( map_range )

