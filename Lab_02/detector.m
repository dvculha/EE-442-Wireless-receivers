function [start] = detector(p,r, thr)
% Input :   p: preamble (shape = (100, 1)), r: received signal (shape = (Nr, 1)), thr: scalar threshold 
% output:   start: signal start index
Np = size(p,1);
Nr = size(r,1);
c = zeros(Nr-Np, 1);
c_norm = zeros(Nr-Np, 1);
start = 0;


for i = 1:Nr-Np+1
    % correlation
    c(i)= sum(conj(p).*r(i:i+Np-1));
    energyR = r(i:i+Np-1)'*r(i:i+Np-1);
    c_norm(i)=abs(c(i))^2./energyR;
    
    % if correlation bigger than threshold, it is the start
    if c_norm(i)>thr
        start = i; %starting index of the preamble
        start = start + Np
        break;
    end
end
% after loop no threshold reached
if start == 0
    disp('Frame start not found.')
    start = -1;
end
end

