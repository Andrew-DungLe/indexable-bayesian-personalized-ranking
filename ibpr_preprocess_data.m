addpath(genpath(['util']));
addpath(genpath(['metric']));

K = 1;
dataset = 'nfl';
numWorkers = 8;
disp(sprintf('-------- data: %s --------------', dataset));

for f = 1 : K
    disp(sprintf('-------- fold %d --------------', f));
    data_path = strcat('data/', dataset, '/sample_', num2str(f),'.mat');
    %------------------------------------------------------------------------
    train  = load(strcat('data/', dataset,'/train_', num2str(f), '.data'));
    test   = load(strcat('data/', dataset, '/test_', num2str(f), '.data'));
    num_user = length(unique([train(:, 1); test(:, 1)]));
    num_item = length(unique([train(:, 2); test(:, 2)]));
    
    disp('---- preparing data ---------');
    user_data = cell(num_user, 1);
    rated_item = cell(num_user, 1); 
    startPool(numWorkers);
    
    parfor u = 1 : num_user
        u_rating = train(train(:,1) == u, 2:3); 
        u_rated_item = u_rating(:,1); rated_item{u} = u_rated_item;  
        vals = u_rating(:,2);
        descend_unq_vals = sort(unique(vals), 'descend');
        u_triples = cell(1, length(descend_unq_vals));
        for vi = 1 : (length(descend_unq_vals))
            i_item_idx = u_rated_item(vals == descend_unq_vals(vi));
            u_triples{vi} = i_item_idx;
        end
        user_data{u} = u_triples;
    end
    
    rated_by = cell(num_item, 1);
    parfor i = 1 : num_item
        i_rated_by = train(train(:, 2) == i, 1); 
        rated_by{i} = i_rated_by;
    end
    
    disp('--- generating triples------');
    triples = cellfun(@(y) cell2mat((cellfun(@(x) combvec(y, user_data{y}{x}', user_data{y}{x+1}')', num2cell(1:(length(user_data{y}) - 1)), 'Uni', 0))'), num2cell(1:num_user), 'Uni', 0);
    triples = triples(~cellfun('isempty', triples));
    triples = cell2mat(triples');
    clear user_data 
    disp('--------- preprocessing triples ----------------')	
    triples = sortrows(triples, 1);
    uu = triples(:, 1);
    [im, ut_begin] = ismember(1:num_user, uu);
    [~,  ut_begin_flip]  = ismember(1:num_user, flipud(uu));
    ut_end = ((length(uu) + 1) - ut_begin_flip) .* im;
    %ui = triples(:, 2); uj = triples(:, 3); 
    u_triples = triples(:, [2, 3]);
    disp('finished indexing user');
    %save(data_path, 'u_triples', 'ut_begin', 'ut_end', '-v7.3', '-append');
    %clear uu u_triples ut_begin ut_end
    
    triples = sortrows(triples, 2);
    ii = triples(:, 2);
    [im, it_begin] = ismember(1:num_item, ii);
    [~,  it_begin_flip]  = ismember(1:num_item, flipud(ii));
    it_end = ((length(ii) + 1) - it_begin_flip) .* im;
    %iu = triples(:, 1); ij = triples(:, 3);
    i_triples = triples(:, [1, 3]);
    %save(data_path, 'i_triples', 'it_begin', 'it_end', '-v7.3', '-append');
    %clear ii i_triples it_begin it_end
    
    triples = sortrows(triples, 3);
    jj = triples(:, 3);
    [im, jt_begin] = ismember(1:num_item, jj);
    [~,  jt_begin_flip]  = ismember(1:num_item, flipud(jj));
    jt_end = ((length(jj) + 1) - jt_begin_flip) .* im;
    %ju = triples(:, 1); ji = triples(:, 2);
    j_triples = triples(:, [1, 2]);
    save(data_path, 'test', 'num_user', 'num_item', 'rated_item', 'rated_by','u_triples', 'ut_begin', 'ut_end','i_triples', 'it_begin', 'it_end', 'j_triples', 'jt_begin', 'jt_end', '-v7.3');
    %clear triples jj j_triples jt_begin jt_end
    disp('finished indexing item');
    disp('---- finished preparing triples data ---------');  
end

