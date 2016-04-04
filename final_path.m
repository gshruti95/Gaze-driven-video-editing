
function [final] = final_path(Q1,Q2,fname)

xmed = zeros(numel(Q1),1);
   
%% Calc medians across all frames

for i=2:numel(Q1)

        %fprintf('i=%d \n\n',i);
        
        data_cur = fname(i,fname(i,:) ~= 0);
        xmed(i) = median(data_cur);
        data_prev = fname(i-1,fname(i-1,:) ~= 0);
        xmed(i-1) = median(data_prev);
end

%% Check first 20 frames to pick the closest curve to the data

dist1 = 0; dist2 = 0;
        for k=1:20  
 
        dist1 = dist1+(xmed(k,1) - Q1(k,1))^2;        
        dist2 = dist2+(xmed(k,1) - Q2(k,1))^2;
        
        end
        if dist1 < dist2    
            final =Q1;       
        else        
            final= Q2;      
        end
   
%% Check for cuts
  
% flg =1 indicates possible candidate for cut
flg = 0;
i=2;
 
while(i <= numel(Q1))


%fprintf('entered out\n');

        %% Cut condition
        
        if abs(xmed(i,1) - xmed(i-1,1)) >= 140 && abs(Q1(i,1) - Q2(i,1)) >= 250
            
            %fprintf('entered i=%d\n',i);
            %fprintf('xmed(i)=%d xmed(i-1)=%d\n\n',xmed(i),xmed(i-1));
           
            flg=1;

            if i <= numel(Q1) -5
                var = i+5;
            else
                var = numel(Q1);
            end
            
            % Check if candidate cut doesn't cut again within next 5 frames
            % i.e. flg should remain flg=1
            
            for x=i+1:var
                %fprintf('ent inner x=%d\n',x);
                %fprintf('inner loop xmed(x) = %d xmed(x-1)=%d\n\n',xmed(x),xmed(x-1));
                
                if abs(xmed(x,1) - xmed(x-1,1)) >= 140 && abs(Q1(x,1) - Q2(x,1)) >= 100
                    flg = 0;
                    %fprintf('ent flg =0 cond\n');
                    i=x+1;
                    break;
                end

            end
            

            % Switch curve from point i onwards
            % Also check if cur xmed has moved away from old curve
            % If it has moved away, then switch curves, as the med shift
            % is not a sufficient indicator to decide if curves need to be
            % switched
            
            if flg==1
                %fprintf('i before flg=1 =%d\n',i);
                
               % for h=i:numel(Q1)
                    %fprintf('final=%d\n\n',final(i,1));
                    if final(i,1) == Q1(i,1) && abs(xmed(i)-Q1(i,1)) > abs(xmed(i)-Q2(i,1))
                        final(i:numel(Q1),1) = Q2(i:numel(Q1),1);
                    else
                        final(i:numel(Q1),1) = Q1(i:numel(Q1),1);
                    end
                    
                    %fprintf('final=%d\n\n',final(i:numel(Q1),1));

               % end

                i=i+5;
                %fprintf('i after flg=1 =%d\n',i);
                
            end
     
        else
        
            i=i+1;
        
        end
        
        
end    

%end