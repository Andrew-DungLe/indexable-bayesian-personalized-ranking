function x = mean_var_at_k(R, U, I, k, dist_metric)
    U = normc(real(U)); I = normc(real(I));
    num_user = size(U, 2);
    
    mean_diff = 0; var_diff = 0;
    count = 0; % count the number of users having more than k items in their test sets
    parfor u = 1 : num_user
        u_rating = R(R(:,1) == u, 2:3); 
        rated_items = u_rating(:,1);  
        vals = u_rating(:,2); 
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

            u_mean_diff  = 0; u_var_diff   = 0;
            for i = 1 : k
                d_ui = dist_to_items(sorted_dist_item_idx(i))/pi;
                for j = (k + 1): length(sorted_dist_item_idx) 
                   d_uj = dist_to_items(sorted_dist_item_idx(j))/pi;
                   u_mean_diff = u_mean_diff + (d_uj - d_ui);
                   u_var_diff = u_var_diff + d_ui *(1 - d_ui) + d_uj *(1 - d_uj); 
                end
            end
            mean_diff = mean_diff + u_mean_diff/(k * (length(rated_items)-k));
            var_diff = var_diff + u_var_diff/(k * (length(rated_items)-k));
        end
    end
    x = [mean_diff/count, var_diff/count];
end