function [FM, i] = generate_lambdaFM(densities,N)
% densities - contains the FM densities of the sources
% N - contains the number of sources
% FM - cotains the final Fuzzy Measure values i.e. the whole lattice values
% i - contains the combinations at each level
%% define the lambda-fuzzy measure equation
syms x;
eqn = (1+densities(1)*x)*(1 + densities(2)*x)*(1+densities(3)*x)*...
    (1+densities(4)*x)*(1 + densities(5)*x)*(1+densities(6)*x) == x+1;

%% generate roots by calling the root solver function
roots = root_solver(eqn);

%% get the lambda value
lambda = roots(roots>-1 & roots~=0);

%% FM definition and pre-requisits
FM = ones(2^N-1,1);
binstr = de2bi([1:2^N-1]); 
nSub = sum(binstr,2);
i = cell(N,1); 
for l=1:N
    i{l} = find(nSub==l);
end

%% defining FM densisites 
temp_init = i{1};
for loop = 1:length(temp_init)
    FM(temp_init(loop)) = densities(loop);
end

%% calculating lambda-FM
for loop = 2:N
    temp = i{loop};
    for loop1 = 1:length(temp)
        temp_bin = binstr(temp(loop1),:);
        pos_max_temp = max(find(temp_bin==1));
        temp_bin(pos_max_temp)=0;
        FM(temp(loop1)) = FM(temp_init(pos_max_temp)) + FM(bi2de(temp_bin))...
            + lambda*FM(temp_init(pos_max_temp))*FM(bi2de(temp_bin));
    end
end
end