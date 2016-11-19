clear;clc;
load('../../data/final/hp_x.csv')
matrix_new = dos_x;


fname = csvread('../../data/final/hp_x.csv');


%% Plot of visualizations
% clr1 = 'm*'; clr2 = 'b*'; clr3 = 'g*'; clr4 = 'y*'; clr5 = 'k*'; clr6 = 'c*'; clr7 = 'b+'; clr8 = 'g+'; clr9 = 'k+';
% clr = [clr1;clr2;clr3;clr4;clr5;clr6;clr7;clr8;clr9];
figure, hold on;

% for i=1:6
% plot(find(fname(:,i)~=0),fname((fname(:,i)~=0),i),strcat(clr(i),'*'));
% end

% %for i=7:9
% i=7
% plot(find(fname(:,i)~=0),fname((fname(:,i)~=0),i),strcat(clr(i),'+'));


path=[];
per = 0.80;
length=720*per;
max_count= 0 ;
fps =24;
for i=1:size(matrix_new,1)   
    max_count= -1;
    for j=1:size(matrix_new,2)
        count=0;
        min=matrix_new(i,j)-length/2;
        max=matrix_new(i,j)+length/2;        
        for k=1:size(matrix_new,2)
            if(matrix_new(i,k)<max && matrix_new(i,k)>min)
                count=count+1;
            end
        end
        if(count >max_count)
            max_count=count;
            index=matrix_new(i,j);
        end
    end
    path=vertcat(path,index);
end

plot(path, 'k+');

splits=[];
for i=1:size(path)-1
   if(abs(path(i)-path(i+1)) > length/2)
        splits=vertcat(splits,i);
   end
end

for i=1:size(splits)-1
    if(splits(i+1)-splits(i) < fps*2)
        path(splits(i):splits(i+1))=path(splits(i)-1);
    end
    
end

splits=[];
for i=1:size(path)-1
   if(abs(path(i)-path(i+1)) > length/2)
        splits=vertcat(splits,i);
   end
end

most_optimal_path=[];
start=1;
for i=1:size(splits,1)+1
    
    if(i==size(splits,1)+1)
        last=size(path,1);
    else
        last=splits(i);
    end
    sub_part = cvx_opt(path(start:last),1000,100,500);
    most_optimal_path=vertcat(most_optimal_path,sub_part);
    
    if(i==size(splits,1)+1)
    else
        start=splits(i)+1;
    end
end

most_optimal_path=round(most_optimal_path);
plot(most_optimal_path, 'r*');  
neg = find(most_optimal_path<=0);
most_optimal_path(neg)=1;



