clear all; close all;

%% Load gaze samples
fname = csvread('../matrix/mat670.csv');


%% Plot of visualizations
% clr1 = 'm*'; clr2 = 'b*'; clr3 = 'g*'; clr4 = 'y*'; clr5 = 'k*'; clr6 = 'c*';
% clr = [clr1;clr2;clr3;clr4;clr5;clr6];
figure, hold on;

% for i=1:6
% plot(find(fname(:,i)~=0),fname((fname(:,i)~=0),i),strcat(clr(i),'*'));
% end

[total_frames users] = size(fname);

params = zeros(total_frames,1);

all_medians = zeros(total_frames,1);
medians = zeros(total_frames,1);
means = zeros(total_frames,1);

med_diff = zeros(total_frames,1);

old_breakpts = [];
breakpts = [];

for frame=1:total_frames

	data_cur = fname(frame,fname(frame,:) ~= 0);
	all_medians(frame) = median(data_cur);
	q1 = []; q3 = []; j=1; k=1;
	for i=1:numel(data_cur)
		if data_cur(i) < all_medians(frame)
			q1(j) = data_cur(i);
			j = j + 1;
		elseif data_cur(i) > all_medians(frame)
			q3(k) = data_cur(i);
			k = k + 1;
		end
	end
	q1_med = median(q1);
	q3_med = median(q3);
	interq_rng = q3_med - q1_med;
	outer_fence = 1.5*interq_rng;
	q3_outer = q3_med + outer_fence;
	q1_outer = q1_med - outer_fence;

	new_data_cur = []; j=1; 
	for i=1:numel(data_cur)
		if data_cur(i) <= q3_outer && data_cur(i) >= q1_outer
			new_data_cur(j) = data_cur(i);
			j = j + 1;
		end
	end

	n_pts = numel(new_data_cur);
	% if mod(n_pts,2) == 0
		% medians(frame) = new_data_cur(n_pts/2);
	% else	
		medians(frame) = median(new_data_cur);
	% end

	means(frame) = mean(new_data_cur);

	med_diff(frame) = abs(medians(frame) - all_medians(frame));

end

plot(1:1:total_frames, medians,'b-');
% plot(1:1:total_frames, all_medians,'r-')
% plot(1:1:total_frames, means,'r-');

% window_size = 5;
% a = 1; b = (1/window_size)*ones(1,window_size);
% medians = filter(b,a,medians);
% plot(1:1:total_frames,medians,'r*');

params = medians;

% j=1; flg=0; frame=1;
% while(frame <= (total_frames-4))
	
% 	if (abs(params(frame+3) - 3*params(frame+2) + 3*params(frame+1) - params(frame)) >= 200) && (abs(params(frame+1) - params(frame)) >= 180)
		
% 		flg = 1;	
% 		if frame <= total_frames-25
% 			cnt = frame + 25;
% 		else
% 			cnt = total_frames;
% 		end
% 		fprintf('Before x, frame= %d, median= %d, next_med= %d\n',frame, params(frame), params(frame+1));
% 		for x=frame+1:cnt
% 			if x < total_frames
% 				new_frame = x + 1;

% 				fprintf('new_frame= %d, med(new_frame)= %d, med(frame)= %d\n', new_frame, params(new_frame), params(frame))
% 				if (abs(params(new_frame) - params(frame)) >= 180)
% 					flg = 1;
% 				else
% 					flg = 0;
% 					frame = new_frame;
% 					break;
% 				end
% 			end
% 		end

% 		fprintf('After x, flg= %d, new_frame= %d\n', flg, new_frame);
% 		if flg == 1
% 			fprintf('After flg= %d, frame= %d, median= %d, next_med= %d\n', flg, frame, params(frame), params(frame+1));
% 			old_breakpts(j) = frame;
% 			j = j+1;
% 			frame = frame + 26;
% 		end

% 	else
% 		frame = frame + 1;
% 	end

% end

% temp = 1; j = 1;
% for k=1:numel(old_breakpts)
% 	difference = old_breakpts(k) - temp;
% 	if k ~= numel(old_breakpts)
% 		diff_2 = old_breakpts(k+1) - old_breakpts(k);
% 	else
% 		diff_2 = total_frames - old_breakpts(k) + 1;
% 	end
	
% 	if diff_2 >= 25
% 		breakpts(j) = old_breakpts(k);
% 		j = j + 1;
% 		temp = old_breakpts(k);
% 	end
% end

break_len = numel(breakpts);
bestpath = []
% for i=1:break_len
% 	if i==1
% 		med_segment1 = params(1:breakpts(i)-1,1);
% 		output1 = cvx_opt(med_segment1,3000,100,500);
% 		plot(1:1:breakpts(i)-1,output1,'r*');
		
% 		if i == break_len
% 			last_med_segment = params(breakpts(i):total_frames,1);
% 			output2 = cvx_opt(last_med_segment,3000,100,500);
% 			plot(breakpts(i):1:total_frames,output2,'r*');
			
% 		else
% 			med_segment2 = params(breakpts(i):breakpts(i+1)-1,1);
% 			output2 = cvx_opt(med_segment2,3000,100,500);
% 			plot(breakpts(i):1:breakpts(i+1)-1,output2,'r*');
% 		end

% 		bestpath = vertcat(output1, output2);
% 	else
% 		if i == break_len
% 			last_med_segment = params(breakpts(i):total_frames,1);
% 			output = cvx_opt(last_med_segment,3000,100,500);
% 			plot(breakpts(i):1:total_frames,output,'r*');
% 			bestpath = vertcat(bestpath, output);
% 		else
% 			new_med_segment = params(breakpts(i):breakpts(i+1)-1,1);
% 			output = cvx_opt(new_med_segment,3000,100,500);
% 			plot(breakpts(i):1:breakpts(i+1)-1,output,'r*');

% 			bestpath = vertcat(bestpath, output);
% 		end

% 	end

% end

if break_len == 0
	f_output = cvx_opt(params,1000,100,500);
	plot(1:1:total_frames,f_output,'r*');
	% bestpath = vertcat(bestpath, f_output);
end

% croppath(bestpath);