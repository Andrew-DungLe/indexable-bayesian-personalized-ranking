function x = average_rating_knn (R, U, I, k, dist_metric)
    avg_rating = 0; num_user = size(U, 2);
    count = 0;
    for u = 1 : num_user
        u_rating = R(R(:,1) == u, 2:3); rated_items = u_rating(:,1);  vals = u_rating(:,2); 
        if (length(rated_items) > k)
            count = count + 1;
            dist_to_items = zeros(1, length(rated_items));

            switch dist_metric
                case {'geod'}
                    for i = 1 : length(rated_items)
                        dist_to_items(i) = acos(U(:,u)' * I(:, rated_items(i)));
                    end
                case {'eud'}
                    for i = 1 : length(rated_items)
                        dist_to_items(i) = norm(U(:,u) - I(:, rated_items(i)));
                    end
                otherwise
                    error('Unknown distance metric')
            end
            [~, sorted_idx] = sort(dist_to_items);
            j = min(k, length(sorted_idx));
            for i = 1 : j
                avg_rating = avg_rating + 1/j * vals(sorted_idx(i));
            end
        end
        x = avg_rating/count;
    end
end