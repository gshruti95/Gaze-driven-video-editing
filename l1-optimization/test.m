clear all; close all;

%% Load gaze samples
fname = csvread('../chauffeur/chauffeur_new.csv');


%% Plot of visualizations
clr1 = 'm*'; clr2 = 'b*'; clr3 = 'g*'; clr4 = 'y*'; clr5 = 'k*'; clr6 = 'c*';
clr = [clr1;clr2;clr3;clr4;clr5;clr6];
figure, hold on;
for i=1:6
plot(find(fname(:,i)~=0),fname((fname(:,i)~=0),i),strcat(clr(i),'*'));
end

[total_frames users] = size(fname);

params = zeros(total_frames,1);
medians = zeros(total_frames,1);

for frame=1:total_frames

	data_cur = fname(frame,fname(frame,:) ~= 0);
	medians(frame) = median(data_cur);
	params(frame)=400;
	
end



% plot(1:1:total_frames,medians,'g*');

output = cvx_opt(medians,1000,100,500);

plot(1:1:total_frames,output,'r*');


% croppath(output);