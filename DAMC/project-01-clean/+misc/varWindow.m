function y = varWindow(x, ws)
    y = zeros(size(x, 1), size(x, 2) - ws);
    for i = 1:(size(x, 2)-ws)
        y(:,i) = var(x(:,i:i+ws),0,2);
    end
end