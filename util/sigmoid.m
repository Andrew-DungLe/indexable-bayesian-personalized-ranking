function y = sigmoid(x, s)
    %y = 1.0 ./(1.0 + exp(-s * x));
    y = sigmf(x, [s, 0]);
end