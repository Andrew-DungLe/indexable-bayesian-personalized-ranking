function dataFileName=loadData(str)

dataFolder='Data/';
if strcmpi(str,'Netflix')
    dataFolder=[dataFolder,'Netflix/'];
    dataFileName{1} = [dataFolder,'NetflixMovieCompressed'];
    dataFileName{2} = [dataFolder,'NetflixViewerCompressed']; 
    dataFileName{3} = [dataFolder,'NetflixQuizSet.mat'];
    dataFileName{4}  =[dataFolder,'NetflixTestSet.mat'];
elseif strcmpi(str,'YahooKDD')
    dataFolder=[dataFolder,'YahooKDD/'];
    dataFileName{1} = [dataFolder,'YahooKDDMovieCompressed'];
    dataFileName{2} = [dataFolder,'YahooKDDViewerCompressed']; 
    dataFileName{3} = [dataFolder,'YahooKDDQuizSet.mat'];
    dataFileName{4}  =[dataFolder,'YahooKDDTestSet.mat'];
    error('Undefined data set')
end