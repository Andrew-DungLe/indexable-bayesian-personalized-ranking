function [rmse_train,Rhat_train]=computeRMSEtrain(U,V,MovieB,MovieE,ViewerIndx,ViewerRank,meanRank,dataSet,disply)

% For test RMSE
if nargin<9
    disply=0;
end

if strcmpi(dataSet,'Netflix')
    range_ratings=[1 5];
elseif strcmpi(dataSet,'Yahoo')
    range_ratings=[0 100];
else
    error('Unknown data set')
end

M=length(MovieB);

% Train RMSE
Rhat_train=zeros(size(ViewerRank));
for j=1:M
    Rhat_train(MovieB(j):MovieE(j),1)=U(:,ViewerIndx(MovieB(j):MovieE(j)))'*V(:,j)+meanRank;
end
% Clip ratings
Rhat_train(Rhat_train>range_ratings(end))=range_ratings(end);
Rhat_train(Rhat_train<range_ratings(1))=range_ratings(1);
rmse_train=sqrt(mean((Rhat_train-double(ViewerRank)).^2));

if disply
    disp(['Training RMSE: ',num2str(rmse_train)]);
end

