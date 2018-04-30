rawdata = rand(100, 1);
rawcats = randi(5, 100, 1);

histcounts(rawcats);

[dataMat, jitterMat, groupMat] = categorical2jitterMat(rawdata, rawcats);

figure(); hold on
plot(jitterMat, dataMat, 'ko')
boxplot(dataMat)