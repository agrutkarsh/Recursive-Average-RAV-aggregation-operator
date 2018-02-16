%Discrete Choquet integral
% example -> ChoquetIntegral( confidences , measure )
%   [ result ] = ChoquetIntegral( [ 0.5 0.6 0.9 ] , FM )
% make sure measure is sized [1 x 2^n-1]
  
clc
clear all

p=2;
% confidences = [0.1 0.3 0.35];
confidences = [0.9 0.7 0.65];
% confidences = [0.1 0.2 0.9];
% confidences = [0.1 0.3 0.35 0.4 0.49];
% confidences = [confidences; 0.9 0.7 0.65 0.6 0.51];
measure = [0.85 0.5 0.9 0.5 0.9 0.6 1];
% measure = [0.99 0.99 1 1 1 1 1];
% measure = [1.89737505577984e-14;3.92025428264966e-14;9.08908754682952e-14;8.92071117997776e-14;2.98606338714045e-13;3.01636560764532e-13;3.91664319002580e-13;2.27755842296238e-13;9.12947895644932e-13;9.16474837472809e-13;1.45752082239230e-12;9.21290740623803e-13;1.46072106289774e-12;1.46428988391388e-12;1.65323871369801e-12;0.478582170335461;0.478582170335564;0.478582170335565;0.478582170335924;0.478582170335565;0.478582170335925;0.478582170335926;0.478582170336641;0.924205284175187;0.924205284175272;0.924205284175266;0.924205284175505;0.951331201985564;0.951331201985689;0.999999999999825;1];
% measure = [0.2 0.25 0.30 0.30 0.35 0.35 0.35 0.35 0.4 0.45 0.45 0.5 0.5 0.5 0.5...
%     0.4 0.5 0.6 0.6 0.6 0.6 0.6 0.65 0.65 0.65 0.65 0.7 0.7 0.7 0.75 1];

    [n,d]=size(confidences);
v=1:d;
for i=1:numel(v)
    combnz{i}=nchoosek(v,i);
end
N=d;
ps1 = zeros((2^N)-1,N);
loop = 1;
for i = 1:N
    temp = combnz{i};
    for j = 1:size(temp,1)
        for k = 1:size(temp,2)
            temp1 = temp(j,k);
            ps1(loop,temp1) = 1;
        end
        loop = loop+1;
    end
end
ps1 = [ps1, sum(ps1,2)];
ps2=sortrows(ps1);
ps2 = [ps2, measure'];
ps2=[fliplr(ps2(:,1:N)) ps2(:,N+1:end)];
% ps2 = [ps2, measure'];


result = [];
for i = 1:size(confidences,1)
    rav = zeros(length(measure),1);
    temp=[];
    for k = 1:length(rav)
        if ps2(k,d+1)==1
            temp = [temp; k];
        end
    end
    for k = 1:length(temp)
        rav(temp(k)) = confidences(i,k);
    end
        
    for j = 2:d
        temp=[];
        for k = 1:length(rav)
            if ps2(k,d+1)==j
                temp = [temp; k];
            end
        end
        for k = 1:length(temp)
            temp2 = ps2(temp(k),1:d);
            temp2 = find(temp2 ==1);
            temp2 = nchoosek(temp2,j-1);%(length(temp2)-1)
            temp3 = zeros(size(temp2,1),d);
            for l = 1:size(temp2,1)
                for m = 1:size(temp2,2)
                    temp3(l,temp2(l,m))=1;
                end
            end
            num=0;
            den=0;
            for l = 1:size(temp3,1)
                temp4=0;
                for m = 1:size(ps2,1)
                    temp4 = isequal(temp3(l,:),ps2(m,1:d));
                    if temp4==1
%                         num = num+(ps2(m,end)*(rav(m).^p));
                        if rav(m)<0
                            num = num+(ps2(m,end)*-1*(abs(rav(m)).^p));
                        else
                            num = num+(ps2(m,end)*(rav(m).^p));
                        end
                        den = den+ps2(m,end);
                        temp4=0;
                    end
                end
            end
%             rav(temp(k))=(num/den).^(1/p);
            if (num/den)<0
                rav(temp(k))=-1*((abs(num/den)).^(1/p));
            else
                rav(temp(k))=(num/den).^(1/p);
            end
        end
        
    end
    result = [result; rav(end)];
end
result
%     result1 = sum(measure(i).*(SortVal(:,1:end-1)-SortVal(:,2:end)),2);