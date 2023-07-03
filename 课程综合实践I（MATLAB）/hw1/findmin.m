function [min] = findmin(m)
    min = m(1,1);
    [r c] = size(m);
    for i = 1 : r
        for j = 1 : c
            if min > m(i,j)
                min = m(i,j);
            end
        end
    end
end

