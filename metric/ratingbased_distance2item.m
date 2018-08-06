function x = ratingbased_distance2item(R, U, I, dist_metric)
    user_id = R(:, 1); item_id = R(:, 2);
    distance = [];

    V_u = U(:, user_id); V_i = I(:, item_id);
    switch dist_metric
        case {'eud'}
            V_ui = V_u - V_i;
            distance = sqrt(sum(V_ui.^2, 1))';
        case {'geod'}
            distance = acos(dot(V_u, V_i))';
    end
    sum_dist = accumarray(R(:, 3), distance);
    freq = accumarray(R(:, 3), 1);
    avg_distance = sum_dist ./ freq;
    x = avg_distance/avg_distance(1);
end