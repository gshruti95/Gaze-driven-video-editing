clear all; close all;

%% Load gaze samples

fname = csvread('waterfront_new.csv');
%im = imread('waterfront_001.jpg');
%figure, imshow(im);

%% Plot of visualizations
clr1 = 'r*'; clr2 = 'b*'; clr3 = 'g*'; clr4 = 'y*'; clr5 = 'k*'; clr6 = 'c*';
clr = [clr1;clr2;clr3;clr4;clr5;clr6];
figure, hold on;
for i=1:6
plot(find(fname(:,i)~=0),fname((fname(:,i)~=0),i),strcat(clr(i),'*'));
end
%hold off;

%% Represent curve

[total_frames users] = size(fname);
a = 1; b = total_frames;

rng = round(1:b/4:b-1);
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

T_data1 = [];

for i=1:4
    
    user_no = randperm(users,1);
    data = fname(T_frames1(i),user_no);
    
    
    while data == 0
        user_no = randperm(users,1);
        data = fname(T_frames1(i),user_no);
    end
    
    T_data1 = [T_data1 data]; % rand selection of one point from each of the T_frames correspondingly
end

%% alp,bet,lam,mu
params1 = [450,850,110,200];
params2 = [850,300,120,200];

%% Constraints
% a - lam <= 0
% lam - mu <= K=40
% mu <= b
% (1 + 720/2)= 361 <= alp , bet <= (1280 - 720/2) = 920

A = [0 0 -1 0; 0 0 1 -1; 0 0 0 1];
D = [-a; 40; b];
LB = zeros(4,1); UB = zeros(4,1);

LB(1) = 361; LB(2) = 362; LB(3) = 1; LB(4) = 1;
UB(1) = 920; UB(2) = 920; UB(3) = b; UB(4) = b;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_data1 = vec2mat(T_data1,1); 
params1 = vec2mat(params1,1); 
T_frames1 = vec2mat(T_frames1,1);  

%[total_err1,Q1] = err_fun(params1,T_frames1);
%plot(T_frames1,Q1);
%[total_err2,Q2] = err_fun(params2,T_frames2);
%plot(T_frames2,Q2);

%% Minimization 

%f = @err_fun;
f = @(params1)err_fun(params1,T_frames1);
%x = lsqcurvefit(@err_fun,params,T_frames,T_data);
[fparams ferr] = fmincon(f,params1,A,D,[],[],LB,UB);


