function experimentAnalyzer()
%EXPERIMENTANALYZER Summary of this function goes here
%   Detailed explanation goes here
close all

% Open the folder to get the files
homeFolder = pwd;
folderName = uigetdir;
cd(folderName);
files = ls('*.csv');
cd(homeFolder);

frequencies = [1 2 5 10 15 20 25 30 35 40];

% Run dataCruncher on each of the files
out = zeros(size(frequencies,2),2,size(files,1));
for i = 1:size(files,1)
    out(:,:,i) = dataCruncher([folderName '\' files(i,:)], 0.005, frequencies, 4);
    waitforbuttonpress();
end

% Run dataCruncher on the Amplitude file
displacement = dataCruncher([folderName '\' files(1,:)], 0.005, frequencies, 4);

% Plot everything on the same plot
close all

subplot(1,2,2);
plot(displacement(:,1),displacement(:,2));
xlabel('Frequency (Hz)','FontWeight','bold');
ylabel('Displacement (µm)','FontWeight','bold');

leg = [];
subHand = subplot(1,2,1);
hold(subHand, 'on');

plot(out(:,1,i), out(:,2,i), '-o', 'Color', rand(1,3),...
    'DisplayName',files(i,1:end-4));
legend('-DynamicLegend');

for i = 2:size(files,1)
    plot(out(:,1,i), out(:,2,i), '-o', 'Color', rand(1,3),...
        'DisplayName',files(i,1:end-4));
    pause(0.5);
end
xlabel('Frequency (Hz)','FontWeight','bold');
ylabel('Peak-to-Peak Voltage (V_p_p)','FontWeight','bold');
legend( leg );
chillin = get( gca, 'children' );


