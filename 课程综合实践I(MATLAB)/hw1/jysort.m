function [result] = jysort(m)
    [r c] = size(m);
    for i = 1 : r
        for j = 1 : c
            result( (i-1) * c + j ) = m(i,j);
        end
    end
    for i = 1 : r * c
        for j = i : r * c
            if result(i) > result(j)
                temp = result(i);
                result(i) = result(j);
                result(j) = temp;
            end
        end
    end
end

