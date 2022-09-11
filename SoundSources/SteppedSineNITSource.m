clear all; close all; clc;
amp = 0.5;
Fs = sum(linspace(377,3400,50));                        
Ts = 1./Fs;
t = 0:Ts:3;
x = [];
for freq = linspace(377,3400,50)
    x = [x amp * sin(2*pi*freq*t)];
end
filename = 'SteppedSineNITSource.wav';
audiowrite(filename,x,Fs);