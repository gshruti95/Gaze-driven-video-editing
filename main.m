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

%% Represent curve
[total_frames users] = size(fname);
% total_frames = 10;
%% Linear Programming Formulation
% Objective Function
% w1|D1|+w2|D2|+w3|D3|
% Constraints
% Assuming that the input video is already stabilized:-
% 1. Inclusion constraint : Full cropping window inside original video
% 2. Saliency constraint : Paper version may be inappropriate
% We need as many salient points inside window as possible

% Initialize all values to the median at that frame (right now done at center	)
params = zeros(total_frames,1);
medians = zeros(total_frames,1);
for frame=1:total_frames
	data_cur = fname(frame,fname(frame,:) ~= 0);
	medians(frame) = median(data_cur);
	params(frame)=400;
end

plot(1:1:total_frames,params,'g*')


% for frame=4:total_frames
% 	% Calculate cropping window location at every frame
% 	vals = [];
% 	vals(1) = params(frame - 3);
% 	vals(2) = params(frame - 2);
% 	vals(3) = params(frame - 1);
% 	vals(4) = params(frame);
% 	w = [1 1 1];
% 	f = @(vals)cost_function(vals,w);
% 	p = [];
% 	vals(5) = fname(frame-3,fname(frame-3,:) ~= 0);
% 	vals(6) = fname(frame-2,fname(frame-2,:) ~= 0);
% 	vals(7) = fname(frame-1,fname(frame-1,:) ~= 0);
% 	vals(8) = fname(frame,fname(frame,:) ~= 0);
% 	nonlcon = @constraint_function;
% 	[fparams ferr] = fmincon(f,vals,[],[],[],[],LB,UB,nonlcon);
% 	params(frame) = vals(4);
% 	disp(frame);
% end
LB = zeros(total_frames,1);
UB = zeros(total_frames,1);
A = zeros(8*total_frames,total_frames);
B = zeros(8*total_frames,1);
for i=1:total_frames-1
	LB(i) = 361;
	UB(i) = 920;

	% A(i,i) = 1;
	% A(total_frames + i, i) = -1;
	% B(i,1) = 50 + medians(i);
	% B(total_frames + i, 1) = 50 - medians(i);

	A(2*total_frames + i,i) = 1;
	A(2*total_frames + i,i+1) = -1;
	B(2*total_frames + i, 1) = 10;

	A(3*total_frames + i,i) = -1;
	A(3*total_frames + i,i+1) = 1;
	B(3*total_frames + i, 1) = 10;

	A(3*total_frames + i,i) = -1;
	A(3*total_frames + i,i+1) = 1;
	B(3*total_frames + i, 1) = 10;

	A(3*total_frames + i,i) = -1;
	A(3*total_frames + i,i+1) = 1;
	B(3*total_frames + i, 1) = 10;

	A(3*total_frames + i,i) = -1;
	A(3*total_frames + i,i+1) = 1;
	B(3*total_frames + i, 1) = 10;
	
	A(3*total_frames + i,i) = -1;
	A(3*total_frames + i,i+1) = 1;
	B(3*total_frames + i, 1) = 10;

end

% [1 0 0; 0 1 0; 0 0 1; -1 0 0; 0 -1 0; 0 0 -1;]
% [100+med(1); 100+med(2); 100+med(3); 100-med(1); 100-med(2); 100-med(3)]

vals = params;
w = [0 1 1];
f = @(vals)cost_function(vals,w);
% nonlcon = @constraint_function;
[fparams ferr] = fmincon(f,vals,A,B,[],[],LB,UB,[],optimoptions('fmincon','MaxFunEvals',10000));
params = fparams;

plot(1:1:total_frames,params,'r*')