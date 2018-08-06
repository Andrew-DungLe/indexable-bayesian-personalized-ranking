function u_data = prepare_gen_triple(train, u)
    u_rating = train(train(:,1) == u, 2:3); 
    rated_items = u_rating(:,1);  
    vals = u_rating(:,2);
    descend_unq_vals = sort(unique(vals), 'descend');
    u_triples = cell(1, length(descend_unq_vals));
    for vi = 1 : (length(descend_unq_vals))
        i_item_idx = rated_items(vals == descend_unq_vals(vi));
        u_triples{vi} = i_item_idx;
    end
    u_data = u_triples;
end