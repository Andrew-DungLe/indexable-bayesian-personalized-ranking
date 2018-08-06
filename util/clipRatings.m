function Rhat=clipRatings(Rhat,dataSet)

if strcmpi(dataSet,'Netflix')
    range_ratings=[1 5];
elseif strcmpi(dataSet,'YahooKDD')
    range_ratings=[0 100];
elseif strcmpi(dataSet,'MovieLens10M')
    range_ratings=[0.5 5];
else
    error('Unknown data set')
end


Rhat(Rhat>range_ratings(end))=range_ratings(end);
Rhat(Rhat<range_ratings(1))=range_ratings(1);
