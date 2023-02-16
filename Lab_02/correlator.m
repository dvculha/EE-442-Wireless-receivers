function [c, c_norm] = correlator(p,r)
% Input:  p: preamble (shape = (Np, 1)), r: received signal (shape = (Nr, 1))
% output: c: correlated signal (shape = (Nr-Np+1, 1)), c_norm: normalized correlated signal (shape = (Nr-Np+1, 1))
Np = size(p,1);
Nr = size(r,1);


% length of correlation is Nr-Np+1
c = zeros(Nr-Np+1, 1);
c_norm = zeros(Nr-Np+1, 1);


% for each element in correlated signal
for i = 1:Nr-Np+1
    
    %eq 2.1
    c(i)= sum(conj(p).*r(i:i+Np-1));
    % eq. 2.2
    energyR = r(i:i+Np-1)'*r(i:i+Np-1);
    c_norm(i)=abs(c(i))^2./energyR;
end

end

