function [SPL_Mic1, SPL_Mic2, Time] = SPLvTimePlot(dataFrameName)
    FS = 1./mean(diff(dataFrameName(:,1)));
    SPL_Mic1 = SPL(dataFrameName(:,3),'air',0.5,FS);
    SPL_Mic2 = SPL(dataFrameName(:,2),'air',0.5,FS);
    Time = dataFrameName(:,1);
end