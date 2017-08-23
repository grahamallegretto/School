function plotMultiBias( data, discardZero )
%PLOTMULTIBIAS Summary of this function goes here
%   Detailed explanation goes here

close all;
hold on

for i = 1:size(data,3)
    fitLine = vBiasMeasure( data(:,:,i), discardZero );
    scatter( data(:,1,i), data(:,2,i) );
    ax = gca;
    ax.ColorOrderIndex = i;
    h(i) = plot( fitLine(:,1), fitLine(:,2) );
    pause( 0.5 );
    
    legStr{i} = num2str(i); 
end
hold off

legend(h,legStr);

end

