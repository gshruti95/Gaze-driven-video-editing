clear all; close all;

%% Load gaze samples

fname = csvread('./shooting/shooting_new.csv');

%% Plot of visualizations
clr1 = 'm*'; clr2 = 'b*'; clr3 = 'g*'; clr4 = 'y*'; clr5 = 'k*'; clr6 = 'c*';
clr = [clr1;clr2;clr3;clr4;clr5;clr6];
figure, hold on;
for i=1:6
plot(find(fname(:,i)~=0),fname((fname(:,i)~=0),i),strcat(clr(i),'*'));
end
%hold off;

%% Represent curve

[total_frames users] = size(fname);
a = 1; b = total_frames;

count = zeros(10,1);
bestpath = zeros(b,1);
inliers = 0;

rng = round(1:b/4:b-1);

%% Start RANSAC

for z=1:1000
    
%% Get frames

T_frames1 = [];
T_frames1 = [T_frames1 randi([rng(1) rng(2)],1)];
T_frames1 = [T_frames1 randi([rng(2) rng(3)],1)];
T_frames1 = [T_frames1 randi([rng(3) rng(4)],1)];
T_frames1 = [T_frames1 randi([rng(4) b-1],1)];

T_frames2 = [];
T_frames2 = [T_frames2 randi([rng(1) rng(2)],1)];
T_frames2 = [T_frames2 randi([rng(2) rng(3)],1)];
T_frames2 = [T_frames2 randi([rng(3) rng(4)],1)];
T_frames2 = [T_frames2 randi([rng(4) b-1],1)];

% T_data1 = [];
% 
% for i=1:4
%     
%     user_no = randperm(users,1);
%     data = fname(T_frames1(i),user_no);
%     
%     
%     while data == 0
%         user_no = randperm(users,1);
%         data = fname(T_frames1(i),user_no);
%     end
%     
%     T_data1 = [T_data1 data]; % rand selection of one point from each of the T_frames correspondingly
% end

%% alp,bet,lam,mu
params1 = [362,850,110,200];
params2 = [900,365,120,200];

%% Constraints for curve 1
% a - lam <= 0
% lam - mu <= K=40
% mu <= b
% (1 + 720/2)= 361 <= alp , bet <= (1280 - 720/2) = 920

A1 = [0 0 -1 0; 0 0 1 -1; 0 0 0 1];
D1 = [-a; -30; b];
LB1 = zeros(4,1); UB1 = zeros(4,1);

LB1(1) = 361; LB1(2) = 361; LB1(3) = 90; LB1(4) = 120;
UB1(1) = 920; UB1(2) = 920; UB1(3) = b-130; UB1(4) = b-90;

%% Constraints for curve 2

A2 = [0 0 -1 0; 0 0 1 -1; 0 0 0 1];
D2 = [-a; -30; b];
LB2 = zeros(4,1); UB2 = zeros(4,1);

LB2(1) = 361; LB2(2) = 361; LB2(3) = 90; LB2(4) = 120;
UB2(1) = 920; UB2(2) = 920; UB2(3) = b-130; UB2(4) = b-90;

%% Minimization 

f1 = @(params1)err_fun(params1,T_frames1,a,b,fname);
[fparams1 ferr1] = fmincon(f1,params1,A1,D1,[],[],LB1,UB1);
f2 = @(params2)err_fun(params2,T_frames2,a,b,fname);
[fparams2 ferr2] = fmincon(f2,params2,A2,D2,[],[],LB2,UB2);

fparams1 = round(fparams1);
fparams2 = round(fparams2);

%% Get both splines with optimized params
all_frames = a:1:b;
Q1 = round(nubs(fparams1,all_frames,a,b));
%plot(all_frames,Q1);
Q2 = round(nubs(fparams2,all_frames,a,b));
%plot(all_frames,Q2);

%% Look for cuts and get final path

fpath = final_path(Q1,Q2,fname);

count(z,1) = ransac(fpath,fname);

if inliers < count(z,1)
   inliers = count(z,1);
   bestpath = fpath;
end


end

plot(all_frames,bestpath,'r*');
hold off;

croppath(bestpath);

