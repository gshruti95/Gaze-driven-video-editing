function [count] = ransac(fpath,fname)

%% Count inliers within 1/3rd of window (240) for entire path

count = 0;

    for i=1:numel(fpath)
        data_cur = fname(i,fname(i,:) ~= 0);
        
        for j=1:numel(data_cur)
                
                if data_cur(j) >= (fpath(i,1) - 120) && data_cur(j) <= (fpath(i,1) + 120)
                        
                    %fprintf('data = %d, Q1 = %d\n',data_prev(j),Q1(i-1,1));
                    
                    count = count + 1;
                    %fprintf('count = %d\n',count1);
                   
                        
                end
               
        end
        
    end
        

end