function [max] = findmax(m)
    max = m(1,1);
    [r c] = size(m);
    for i = 1 : r
        for j = 1 : c
            if max < m(i,j)
                max = m(i,j);
            end
        end
    end
end

