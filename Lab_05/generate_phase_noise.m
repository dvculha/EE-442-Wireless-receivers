function theta_n = generate_phase_noise(length_of_noise, sigmaDeltaTheta)
    % Create phase noise
    theta_n = zeros(length_of_noise,1);
    %% TODO
    
    %delta_theta = Gaussian rv w mean 0 and variance sigmaDeltaTheta
    delta_theta = sigmaDeltaTheta * randn(length_of_noise,1);
    
    % for i = 1:
    % start somewhere
    theta_n(1) = rand(1,1)*2*pi + delta_theta(1);

    %for i = 2 forwards:
    % walk from there
    for i=2:length(theta_n)
        theta_n(i) = theta_n(i-1) + delta_theta(i);
    end
    
    
end