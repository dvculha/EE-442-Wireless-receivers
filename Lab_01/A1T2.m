const_blue = [-6-6i,-3i,3i,-3,3,6+6i];
const_red = [-3-3i,-3+3i,3-3i,3+3i];
average_energy_blue = sum(abs(const_blue).^2*1/length(const_blue))
average_energy_red = sum(abs(const_red).^2*1/length(const_red))

const_blue_norm = const_blue/sqrt(average_energy_blue);
const_red_norm = const_red/sqrt(average_energy_red);

plot(const_blue,'bo'),hold on,grid on
plot(const_red,'ro')
plot(const_blue_norm,'bx')
plot(const_red_norm,'rx')

legend("const A","const B","const A normalized","const B normalized")
% 3.2 observations
%Because of the points with higher energy in the blue constellation, after normalization, the points with %lower energy are closer to each other, which leads to less resilience to noise. Thus the blue %constellation is not very efficient.
