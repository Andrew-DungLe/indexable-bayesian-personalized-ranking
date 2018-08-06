function closePool

if verLessThan('matlab', '8.2') % parpool introduced in R2013b
    if matlabpool('size') ~= 0
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
    
    if poolsize  ~= 0
        delete(gcp)
    end
end