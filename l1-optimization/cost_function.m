% Function to evaluate to optimize cost function w1|D1| + w2|D2| + w3|D3|
function total_cost = cost_function(vals,w)
	% vals = [B(t) B(t+1) B(t+2) B(t+3)]
	% total_cost = w(1)*d1(vals) + w(2)*d2(vals) + w(3)*d3(vals);
	total_cost = 0;
	len = numel(vals);
	for i=4:len
		cur_cost = w(1)*d1(vals(i-3:i)) + w(2)*d2(vals(i-3:i)) + w(3)*d3(vals(i-3:i));
		total_cost = total_cost + cur_cost;
	end
end

function val=d1(B)
	% Calculate |B(t+1) - B(t)| as distance differential
	val = abs(B(2) - B(1));
end

function val=d2(B)
	% Calculate |B(t+2) - 2B(t+1) + B(t)| as velocity differential
	val = abs(B(3) - 2*B(2) + B(1));
end

function val=d3(B)
	% Calculate |B(t+3) - 3B(t+2) + 3B(t+1) - B(t)| as acceleration differential
	val = abs(B(4) - 3*B(3) + 3*B(2) - B(1));
end

function [c,ceq] = constraint()
	c = [];
	ceq = [];
end