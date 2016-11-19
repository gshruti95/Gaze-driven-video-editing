clear all; close all;

%% Load gaze samples
fname = csvread('../../data/final/matrix2.csv');
% dos_x = load('../../data/final/hp_x.csv');
% fname = csvread('../../data/shruti_clip2/matrix2_new.csv');
% fname = csvread('../../data/matrix_data/matrix_new.csv');

%% Plot of visualizations
clr1 = 'm*'; clr2 = 'b*'; clr3 = 'g*'; clr4 = 'y*'; clr5 = 'k*'; clr6 = 'c*'; clr7 = 'b+'; clr8 = 'g+'; clr9 = 'k+';
clr = [clr1;clr2;clr3;clr4;clr5;clr6;clr7;clr8;clr9];
figure, hold on;

for i=1:6
plot(find(fname(:,i)~=0),fname((fname(:,i)~=0),i),strcat(clr(i),'*'));
end

%for i=7:9
% i=7;
% plot(find(fname(:,i)~=0),fname((fname(:,i)~=0),i),strcat(clr(i),'+'));
% %end

% nonzero_inds = find(fname(:,:))

% for i=1:6
% plot((find(nonzero_inds>=61000 & nonzero_inds<=71000)),fname((nonzero_inds>=61000 & nonzero_inds<=71000),i),strcat(clr(i),'*'));
% end

% for i=7:9
% plot((find(nonzero_inds>=61000 & nonzero_inds<=71000)),fname((nonzero_inds>=61000 & nonzero_inds<=71000),i),strcat(clr(i),'+'));
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
	if numel(data_cur) ~= 1
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
	else
		new_data_cur = data_cur;
	end

	medians(frame) = median(new_data_cur);
	means(frame) = mean(new_data_cur);

	med_diff(frame) = abs(medians(frame) - all_medians(frame));

end

plot(1:1:total_frames, medians,'b-');

params = medians;

% path=[];
% per = 0.80;
% length=720*per;
% max_count= 0 ;
% for i=1:size(dos_x,1)   
%     max_count= -1;
%     for j=1:size(dos_x,2)
%         count=0;
%         min=dos_x(i,j)-length/2;
%         max=dos_x(i,j)+length/2;        
%         for k=1:size(dos_x,2)
%             if(dos_x(i,k)<max && dos_x(i,k)>min)
%                 count=count+1;
%             end
%         end
%         if(count >max_count)
%             max_count=count;
%             index=dos_x(i,j);
%         end
%     end
%     path=vertcat(path,index);
% end

% % params = path;
% plot(1:1:total_frames, path,'k-');

fps = 60;

j=1; flg=0; frame=1;
while(frame <= (total_frames-4))
	
	if (abs(params(frame+3) - 3*params(frame+2) + 3*params(frame+1) - params(frame)) >= 200 && (abs(params(frame+1) - params(frame)) >= 265))
		% 
		
		flg = 0;	
		if frame <= total_frames - fps
			cnt = frame + fps;
		else
			cnt = total_frames;
		end
		fprintf('Before x, frame= %d, median= %d, next_med= %d\n',frame, params(frame), params(frame+1));
		% st = frame; next_st = frame+1;
		for x=frame+1:cnt
			if x < total_frames
				new_frame = x + 1;

				fprintf('new_frame= %d, med(new_frame)= %d, med(frame)= %d\n', new_frame, params(new_frame), params(frame))
				if (abs(params(new_frame) - params(frame)) >= 265)%(abs(params(frame) - params(frame+1))/2) )
					flg = 1;
				else
					flg = 0;
					frame = new_frame;
					break;
				end
			end
		end

		fprintf('After x, flg= %d, new_frame= %d\n', flg, new_frame);
		if flg == 1
			fprintf('After flg= %d, frame= %d, median= %d, next_med= %d\n', flg, frame, params(frame), params(frame+1));
			old_breakpts(j) = frame;
			j = j+1;
			frame = frame + fps + 1;
		end

	else
		frame = frame + 1;
	end

end

temp = 1; j = 1;
for k=1:numel(old_breakpts)
	difference = old_breakpts(k) - temp;
	if k ~= numel(old_breakpts)
		diff_2 = old_breakpts(k+1) - old_breakpts(k);
	else
		diff_2 = total_frames - old_breakpts(k) + 1;
	end
	
	if diff_2 >= fps
		breakpts(j) = old_breakpts(k);
		j = j + 1;
		temp = old_breakpts(k);
	end
end

break_len = numel(breakpts);
bestpath = []
l1 = 5000; l2 = 100 ; l3 = 500;

for i=1:break_len
	if i==1
		med_segment1 = params(1:breakpts(i),1);
		output1 = cvx_opt(med_segment1, l1 ,l2 , l3);
		% plot(1:1:breakpts(i)-1,output1,'r*');
		
		if i == break_len
			last_med_segment = params(breakpts(i)+1:total_frames,1);
			output2 = cvx_opt(last_med_segment, l1 ,l2 , l3);
			% plot(breakpts(i):1:total_frames,output2,'r*');
			
		else
			med_segment2 = params(breakpts(i)+1:breakpts(i+1),1);
			output2 = cvx_opt(med_segment2, l1 ,l2 , l3);
			% plot(breakpts(i):1:breakpts(i+1)-1,output2,'r*');
		end

		bestpath = vertcat(output1, output2);
	else
		if i == break_len
			last_med_segment = params(breakpts(i)+1:total_frames,1);
			output = cvx_opt(last_med_segment, l1 ,l2 , l3);
			% plot(breakpts(i):1:total_frames,output,'r*');
			bestpath = vertcat(bestpath, output);
		else
			new_med_segment = params(breakpts(i)+1:breakpts(i+1),1);
			output = cvx_opt(new_med_segment, l1 ,l2 , l3);
			% plot(breakpts(i):1:breakpts(i+1)-1,output,'r*');

			bestpath = vertcat(bestpath, output);
		end

	end

end

if break_len == 0
	f_output = cvx_opt(params, l1 ,l2 , l3);
	plot(1:1:total_frames,f_output,'r*');
	bestpath = vertcat(bestpath, f_output);
else
	plot(1:1:total_frames,bestpath,'r*');
end

% croppath(bestpath);
