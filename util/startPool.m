function startPool(numWorkers)

if verLessThan('matlab', '8.2') % parpool introduced in R2013b
    if numWorkers>=1
        if (matlabpool('size') ~= numWorkers) && matlabpool('size')>0% checking to see if my pool is already open
            matlabpool close
        end
        if matlabpool('size') == 0 % checking to see if my pool is already open
            matlabpool(numWorkers) % My laptop
    %         poolMatlabDTU % DTU's HPC
        end
    elseif matlabpool('size') ~= 0
        matlabpool close
    end
else
    % Get size of the current pool
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        poolsize = 0;
    else
        poolsize = poolobj.NumWorkers;
    end
    
    if numWorkers>=1
        if poolsize ~= numWorkers && poolsize>0% checking to see if my pool is already open
            delete(gcp)
        end
        
        % Get size of the current pool
        poolobj = gcp('nocreate'); % If no pool, do not create new one.
        if isempty(poolobj)
            poolsize = 0;
        else
            poolsize = poolobj.NumWorkers;
        end
        
        if poolsize == 0 % checking to see if my pool is already open
            parpool('local',numWorkers); % My laptop
    %         poolMatlabDTU % DTU's HPC
        end
    elseif poolsize  ~= 0
        delete(gcp)
    end
end