function [B] = blend(q,k,t,knots)

    if k == 1
    
        if (t >= knots(q)) && (t < knots(q+1))     
            B = 1;
            return;
        else
            B = 0;
            return;
        end
              
    else
        
         B1 = blend(q,k-1,t,knots);
         if B1~=0
             c1 = (t - knots(q))/(knots(q+k-1)-knots(q));
         else
             c1 = 0;
         end
         r1 = c1*B1;
%         fprintf('B1=%d c1=%d r1=%d\n',B1,c1,r1);
        
         B2 = blend(q+1,k-1,t,knots);
         if B2~=0
             c2 = (knots(q+k) - t)/(knots(q+k)-knots(q+1));
         else
             c2 = 0;
         end
         r2 = c2*B2;
%         fprintf('B2=%d c2=%d r2=%d\n',B2,c2,r2);
         
         B = r1 + r2;
        
     end

end