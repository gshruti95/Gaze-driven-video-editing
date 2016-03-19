function [i] = reti(frame,knots_i)

list1 = [frame knots_i];
list1 = sort(list1);
[v ind] = find(list1==frame);
index = ind(numel(ind)) - 1;

if index == 4
    index = 3;
elseif index == 0
    index = 1;
end;

knots_no = [3,5,7,8];

i = knots_no(index);

end