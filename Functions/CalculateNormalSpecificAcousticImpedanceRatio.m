function [z_pc_real, z_pc_imag, freq] = CalculateNormalSpecificAcousticImpedanceRatio(dataFrameName)
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
    z_pc =(1+r)./(1-r);
    z_pc_real = real(z_pc);
    z_pc_imag = imag(z_pc);
end