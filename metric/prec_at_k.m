function x = prec_at_k(R, U, I, k, dist_metric)
    num_user = size(U, 2);
    prec_k = 0; count  = 0;
    parfor u = 1 : num_user
        u_rating = R(R(:,1) == u, 2:3); 
        rated_items = u_rating(:,1); vals = u_rating(:, 2); 
        if (length(rated_items) > k && min(vals) ~= max(vals))
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

            [~, sorted_dist_item_idx] = sort(dist_to_items);

            total_pair = 0; correct_pair = 0;
            for i = 1 : k
                r_i = vals(sorted_dist_item_idx(i));
                for j = (k + 1): length(sorted_dist_item_idx) 
                   r_j = vals(sorted_dist_item_idx(j)); 
                   if (r_i ~= r_j)
                       total_pair = total_pair + 1;
                       if (r_i > r_j)
                           correct_pair = correct_pair + 1;
                       end
                   end
                end
            end
            prec_k = prec_k + correct_pair/total_pair;
        end
    end
    x = prec_k/count;
end