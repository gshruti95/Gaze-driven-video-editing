function [Q] = nubs(params,frames)
% knots_i = knots without multiplicity

% CP = [200,200,200,200,900,900,900,900];
% knots = [1,1,1,1,90,90,200,200,308,308,308,308];
% knots_i = [1,90,200,308];
% frames = [85,100,190,307];
% frames = 1:1:308;

%% Params

a=1; b=308;
alp = params(1); bet = params(2); lam = params(3); mu = params(4);
CP = [alp,alp,alp,alp,bet,bet,bet,bet]; % control pts
knots = [a,a,a,a,lam,lam,mu,mu,b,b,b,b]; % knots
knots_i = [a,lam,mu,b]; % knots no repetition 

%% Compute Q for each frame

    Q = zeros(numel(frames),1);
    
    for p = 1:numel(frames)
%p=308;
        k = 4;
        i = reti(frames(p),knots_i);
        %fprintf('reti=%d\n',i);
        B = zeros(4,1);
       
        % Compute B(i,4) to B(i-3,4) blends for Qi
%q=8;
       for q = (i+1):-1:i-2
           
            B(q,1) = blend(q,k,frames(p),knots);
            %fprintf('B = %d \n ',B(q,1));
            
            Q(p,1) = Q(p,1) + B(q,1)*CP(q);
            %fprintf('Q = %d\n',Q(p,1));
            
       end
        
       % Q = round(Q);
        
    end


end