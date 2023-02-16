rng(123)
length_of_noise = 1000;
sigmaDeltaTheta = 0.004;
theta_n = generate_phase_noise(length_of_noise, sigmaDeltaTheta);
plot(theta_n)