function iteSurface( L,  alpha, rateConstant, eRange )
%ITESURFACE Creates an ITE surface based on diffsim

close all
z = zeros( L, size(eRange,2) );

% Constants
dma              = 0.45;

for i = 1:size(eRange,2)
    [z(:,i),T] = diffSim( L, 5, alpha, rateConstant, eRange(i), false );
end

% Constants
leng = floor(sqrt(dma*L) + 1); % Used to ensure same dimensionless x 
                                   % value for different L values for
                                   % plotting
surf( eRange, T(1:leng), z(1:leng,:) );
view(142.5,30);
xlabel('Applied Potential (V)');
ylabel('Dimensionless Time');
zlabel('Dimensionless Current');
