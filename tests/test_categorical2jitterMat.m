rawdata = rand(50, 1);
rawcats = randi(5, 50, 1);

histcounts(rawcats)

[dataMat, jitterMat, groupMat] = categorical2jitterMat(rawdata, rawcats);

figure(); hold on
plot(jitterMat, dataMat, 'ko')
boxplot(dataMat)