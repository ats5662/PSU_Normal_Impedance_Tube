function [SPL_Mic1, SPL_Mic2, Time] = SPLvTimePlot(dataFrameName)
    FS = 1./mean(diff(dataFrameName(:,1)));
    Mic1Data = dataFrameName(:,3);
    Mic2Data = dataFrameName(:,2);
    SPL_Mic1 = SPL(Mic1Data(2:8:end,:),'air',0.05,FS);
    SPL_Mic2 = SPL(Mic2Data(2:8:end,:),'air',0.05,FS);
    Time = dataFrameName(:,1);
    Time = Time(2:8:end,:);
end