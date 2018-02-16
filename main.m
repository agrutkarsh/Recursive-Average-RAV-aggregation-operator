clc
clear all;
close all;

%% define the fuzzy densities for the FM 
densities = [0.6216, 0.6703, 0.5977, 0.4931, 0.3655, 0.3942];
% densities = [0.8175, 0.7986, 0.6623, 0.6089, 0.6806, 0.6976];
% densities = [0.2881, 0.1542, 0.1029, 0.0408, 0.0940, 0.1000];
% densities = [0.7293, 0.5240, 0.3128, 0.1875, 0.3068, 0.3617];

%% define the number of sources
N=length(densities);

%% passing the FM densities to generate the FM lattice
[FM, FM_combinations] = generate_lambdaFM(densities, N);

%% checking FM at each level
temp_init = FM_combinations{2};
temp=[];
for loop = 1:length(temp_init)
    temp = [temp; FM(temp_init(loop))];
end

