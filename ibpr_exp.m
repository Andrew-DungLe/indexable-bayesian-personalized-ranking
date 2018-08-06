addpath(genpath(['util']));
addpath(genpath(['metric']));

K = 1; 
d = [20];
rng('shuffle')

dataset = 'ml_20m';
method  = 'ibpr';
numWorkers = 2;
disp(sprintf('----------- %s --------------', dataset));

for f = 1 : K    
    disp(sprintf('-------- fold %d --------------', f));
    
    %prepare ordinal data
    data_path = strcat('data/', dataset, '/sample_', num2str(f),'.mat');
    load(data_path);
    testRatings = cell(num_user, 1);
    for u = 1:num_user
        u_test = test(test(:, 1)== u, 2:3);
        testRatings{u} = u_test;
    end
    
    %------------------------- -----------------------------------------------
    for di = d
        disp(sprintf('---- dim   = %d ----', di));
        
        % hyper-paprameter setting:
        eta   = 0.001;   params.eta = eta;%- regularization cofficient
        lRate = 0.05 ;   params.lRate = lRate;% learning rate
        drat  = 0.99;    params.drat = drat;% decay ratio
        scl   = 1;       params.scl  = scl;% scaling factor of sigmoid function
        tolr  = 10e-8;   params.tolr = tolr;% tolerance for convergence condition      
        maxIter = 200;   params.maxIter = maxIter;% max #iteration
        disp(sprintf('-eta=%f -lRate=%f -drat=%f -scl=%f -maxIter= %f', eta, lRate, drat, scl, maxIter))
        
        
        %initialization
        P = normrnd(0, 1, di, num_user); 
        Q = normrnd(0, 1, di, num_item);
        
        loss = 0; 
        tic
        for iter = 1 : maxIter
            loss = 0; 
            lRate = drat * lRate; 
            current_loss = loss ; 
            
            current_P = P; 
            current_Q = Q;
            normalized_P = bsxfun(@rdivide, current_P, sqrt(sum(current_P.^2, 1)));
            normalized_Q = bsxfun(@rdivide, current_Q, sqrt(sum(current_Q.^2, 1)));
            
            %---------- update for user vectors --------------
            %startPool(numWorkers);
	    	
            for u = 1 : num_user
		        eGrad = zeros(di, 1); 
                pu = current_P(:, u); pu_norm = norm(pu); 
                u_rated_item = rated_item{u};
                normalized_pu = pu/pu_norm; 
                u_cos = normalized_Q(:, u_rated_item)' * normalized_pu;
                if ut_begin(u) > 0
                    u_indx = ut_begin(u):ut_end(u);
                    i_id = u_triples(u_indx, 1); 
                    j_id = u_triples(u_indx, 2);
                    
                    [~, loc_ui] = ismember(i_id, u_rated_item);
                    [~, loc_uj] = ismember(j_id, u_rated_item);
                    cos_ui = u_cos(loc_ui); 
                    cos_uj = u_cos(loc_uj); 
                    
                    X_uij  = acos(cos_uj) - acos(cos_ui);

                    loss  = loss - sum(log(1 + exp(- scl * X_uij)));
                    temp_sm = sm(-X_uij, scl);  
                    eGrad = eGrad + sum(bsxfun(@rdivide ,- normalized_Q(:, j_id) + normalized_pu * cos_uj', (sqrt(1 - cos_uj.^2)./temp_sm)'), 2); 
                    eGrad = eGrad + sum(bsxfun(@rdivide,   normalized_Q(:, i_id) - normalized_pu * cos_ui', (sqrt(1 - cos_ui.^2)./temp_sm)'), 2);
                end
                loss = loss - 0.5 * eta * dot(pu, pu);
                eGrad = scl/pu_norm * eGrad - eta * pu;
                P(:, u) = pu + eGrad * lRate;
            end

            %startPool(numWorkers);	
            %update for item vectors           
            for i = 1 : num_item
                eGrad = zeros(di, 1); 
                qi = current_Q(:, i); qi_norm = norm(qi); 
                i_rated_by = rated_by{i};
                normalized_qi = qi/qi_norm; 
                i_cos = normalized_P(:, i_rated_by)'* normalized_qi;
                if (it_begin(i) + jt_begin(i) > 0)
                    if(it_begin(i) > 0) 
                        i_indx = it_begin(i):it_end(i); 
                        u_id = i_triples(i_indx, 1);
                        normalized_Pu = normalized_P(:, u_id);
                        normalized_Qk = normalized_Q(:, i_triples(i_indx, 2));
                        
                        [~, loc_iu] = ismember(u_id, i_rated_by);
                        cos_ui = i_cos(loc_iu); 
                        X_uik  = acos(dot(normalized_Pu, normalized_Qk)') - acos(cos_ui);

                        loss = loss - sum(log(1 + exp(-scl * X_uik)));
                        eGrad = eGrad + sum( bsxfun(@rdivide, normalized_Pu - normalized_qi * cos_ui',(sqrt(1 - cos_ui.^2)./sm(-X_uik, scl))'), 2);
                    end

                    if (jt_begin(i) > 0)
                        j_indx = jt_begin(i):jt_end(i); 
                        v_id = j_triples(j_indx, 1);
                        normalized_Pv = normalized_P(:, v_id);
                        normalized_Ql = normalized_Q(:, j_triples(j_indx, 2));
                   
                        [~, loc_jv] = ismember(v_id, i_rated_by);
                        cos_vi = i_cos(loc_jv);
                        X_vli = acos(cos_vi) - acos(dot(normalized_Pv, normalized_Ql)');

                        loss = loss - sum(log(1 + exp(-scl * X_vli))) ;
                        eGrad = eGrad + sum(bsxfun(@rdivide, -normalized_Pv + normalized_qi * cos_vi',(sqrt(1 - cos_vi.^2)./sm(-X_vli, scl))'), 2);
                    end
                end
                loss = loss - 0.5 * eta * dot(qi, qi);
                eGrad = scl/qi_norm * eGrad - eta * qi;
                Q(:, i) = qi + eGrad * lRate;
            end
           
            if ( rem(iter, 25) == 0 )
                disp(sprintf('loss at %d-th iteration: %f', iter, loss));
            end

            if (abs(loss - current_loss) < tolr || norm(current_P - P, 'fro') + norm(current_Q - Q, 'fro') < tolr)
                disp('converged');
                break;
            end
        end
        elapsedTime = toc;
        U = P; V = Q;
        U_norm = sqrt(sum(U .^2, 1)); V_norm = sqrt(sum(V .^2, 1));
        U = bsxfun(@rdivide, U, U_norm); V = bsxfun(@rdivide, V, V_norm);
 	    
        %-- export the output model--
        outModel.numUser = num_user;
        outModel.numItem = num_item;
        outModel.userVector = U;
        outModel.itemVector = V;
        outModel.metaData   = params;
        %---------------- export output model ------------------------
        ui_res_file     = strcat('output_model/', dataset,'/', method,'/ibpr_sample_', num2str(f),'.mat');     
        save(ui_res_file, 'outModel', 'testRatings');      
    end
end
