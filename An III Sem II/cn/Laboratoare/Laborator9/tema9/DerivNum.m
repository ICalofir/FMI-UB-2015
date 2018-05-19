function dy = DerivNum(x, y, metoda)
    m = size(x, 2) - 1;
    dy = zeros(1, m);

    switch metoda
        case 'diferente finite progresive'
            for i = 2:m
                dy(i) = (y(i + 1) - y(i)) / (x(i + 1) - x(i));
            end
        case 'diferente finite regresive'
            for i = 2:m
                dy(i) = (y(i) - y(i - 1)) / (x(i) - x(i - 1));  
            end
        otherwise
            for i = 2:m
                dy(i) = (y(i + 1) - y(i - 1)) / (x(i + 1) - x(i - 1));
            end
    end
end