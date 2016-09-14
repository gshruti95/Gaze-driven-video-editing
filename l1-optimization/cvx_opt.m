function output_path   = cvx_opt(initial_path,weight1,weight2,weight3)

N = size(initial_path,1);
e = ones(N,1);

D1 = spdiags([-e e], 0:1, N-1, N);
D2 = spdiags([e -2*e e], 0:2, N-2, N);
D3 = spdiags([-e 3*e -3*e e], 0:3, N-3, N);

cvx_begin 
	variable x(N,1) 
	
	minimise(0.5*sum_square(x(1:N)-(initial_path(:,1))) + weight1*norm(D1*x,1)...
	 + weight2*norm(D2*x,1) + weight3*norm(D3*x,1));

	subject to
		x <= 920
		x >= 360	

cvx_end

output_path = x;

return

end