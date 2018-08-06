% function poolMatlab
%% setup work directory and number of workers for the pool
wdir = getenv('ML_WDIR');
cluster = parcluster();
set(cluster,'JobStorageLocation',wdir);
thrds = str2num(getenv('PBS_NP'));
set(cluster,'NumWorkers',thrds);
%% start up a pool for the cluster defined above - with a random
%  delay, to overcome the port clash problem (two pools trying to use
%  the same TCP port)
ranseed = str2num(getenv('ML_RANDOM'));
rng(ranseed);
pause(1+10*rand());
if verLessThan('matlab', '8.2') % parpool introduced in R2013b
    matlabpool(cluster);
else
    parpool(cluster);
end
