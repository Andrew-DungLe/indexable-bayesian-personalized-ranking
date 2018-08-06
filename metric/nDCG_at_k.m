function x = nDCG_at_k(test, U, I, k, dist_metric)
    nDCG = 0; 
    num_user = size(U, 2); 
    count = 0;
    parfor u = 1 : num_user
        u_rating = test(test(:,1) == u, 2:3); 
        rated_items = u_rating(:,1);  
        vals = u_rating(:,2); 
        if (length(rated_items) > k && min(vals) ~= max(vals))
            count = count + 1;

            uDCG = 0; % compute the DCG for each user
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
            for i = 1 : k
                r_i = vals(sorted_dist_item_idx(i));
                uDCG = uDCG + (2^r_i - 1)/log2(i + 1);
            end
            
            uIDCG = 0;
            sorted_rating   = sort(vals, 'descend'); 
            for i = 1 : k
                r_i = sorted_rating(i);
                uIDCG = uIDCG + (2^r_i - 1)/log2(i + 1);
            end
            nDCG = nDCG + uDCG/uIDCG;
        end
    end    
    x = nDCG/count;
end