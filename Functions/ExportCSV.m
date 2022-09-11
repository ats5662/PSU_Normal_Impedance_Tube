function ExportCSV(dataFrameName,nameOfFile)
    FS = 1./mean(diff(dataFrameName(:,1)));
    c = 343;
    s = 3.75./100;
    L = 33./100;
    x1 = 13.75./100;
    bandwidth = 5;
    overlap_fraction = 0.5;
    binwidth = 2.^nextpow2(FS./bandwidth);
    noverlap = floor(overlap_fraction.*binwidth);
    window = hann(binwidth);
    y1 = dataFrameName(:,3);
    y2 = dataFrameName(:,2);
    [H12,freq]=tfestimate(y1,y2,window,noverlap,[],FS);
    k=(2.*pi.*freq)./c;
    Hh = exp(-1i.*k.*s);
    Hr = exp(1i.*k.*s);
    r = ((H12-Hh)./(Hr-H12)) .* exp(1i.*2.*k.*(x1));
    rabs = abs(((H12-Hh)./(Hr-H12)) .* exp(1i.*2.*k.*(x1)));
    alpha = 1-abs(r).^2;
    aten = -10.*log10(1-alpha);
    z_pc =(1+r)./(1-r);
    z_pc_real = real(z_pc);
    z_pc_imag = imag(z_pc);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ResultsDataFrame = array2table([freq, rabs, alpha, aten, z_pc_real, z_pc_imag],...
    'VariableNames', {'Frequency_Hz', 'Reflection_Coefficient', 'Absorption_Coefficient', 'Attenuation_dB',...
    'Specific_Resistance_Ratio', 'Specific_Reactance_Ratio'});
    ResultsDataFrame(ResultsDataFrame.Frequency_Hz>3400,:)=[];
    ResultsDataFrame(ResultsDataFrame.Frequency_Hz<377,:)=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SPL_Mic1 = SPL(dataFrameName(:,3),'air',0.5,FS);
    SPL_Mic2 = SPL(dataFrameName(:,2),'air',0.5,FS);
    Time = dataFrameName(:,1);
    TimeseriesSPL = array2table([Time, SPL_Mic1, SPL_Mic2],...
    'VariableNames', {'Time_s', 'Mic1_SPL_dB', 'Mic_2_SPL_dB'});
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    writetable(ResultsDataFrame,strcat(string(nameOfFile),"_AllData",".csv"))
    writetable(TimeseriesSPL,strcat(string(nameOfFile),"_TimeseriesSPL",".csv"))
end