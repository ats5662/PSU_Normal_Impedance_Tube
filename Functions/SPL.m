function [SPL] = SPL(p_Pa,ref,windowSize,Fs)
% Calculate sound pressure level (in dB) of given pressure signal 'p_Pa'.
% 
% 
% SYNTAX
%  spl_dB  = spl(p_Pa,ref)
%  spl_dB  = spl(p_Pa,ref,windowSize)
%  spl_dB  = spl(p_Pa,ref,windowSize,Fs)
% 
%   
% DESCRIPTION 
% spl_dB  = spl(p_Pa,ref) returns sound pressure level in decibels
% referenced to reference pressure |ref| in pascals. This usage returns a
% scalar value of spl_dB for the entire p_Pa signal. 
% 
% spl_dB  = spl(p_Pa,ref,windowSize) returns a moving SPL calculation
% along the window size specified by windowSize, where the units of
% windowSize are number of time indicies. 
% 
% spl_dB  = spl(p_Pa,ref,windowSize,Fs) returns a moving SPL, where
% windowSize is not indices of time, but _units_of time equivalent to
% units of 1/Fs. 
% 
%
% INPUTS: 
% p_Pa       =  vector of pressure signal in units of pascals. Can be other units
%               if you declare a reference pressure of matching units. 
%
% ref        =  reference pressure in units matching p_Pa or simply 'air' or
%               'water' if p_Pa is in pascals. 
%
% windowSize =  window size of moving spl calculation. If no windowSize is
%               declared, the spl of the entire input signal will be
%               returned as a scalar. If windowSize is declared, but Fs is
%               not declared, the units of windowSize are number of
%               elements of the input vector. If windowSize and Fs are
%               declared, the units of windowSize are time given by 1/Fs. 
% 
% Fs         =  (optional) sampling frequency.  Note! including Fs changes
%               how this function interprets the units of windowSize. 
% 
%
% OUTPUT: 
% SPL        =  sound pressure level in decibels. If windowSize is declared
%               SPL is a vector of the same length as p_Pa. If windowSize
%               is not declared, SPL is a scalar. 
%
% Note that this does account for frequency content.  A-weighted decibels
% (dBA) are frequency-dependent.  This function does not compute dBA. 
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% Written by Chad A. Greene, with code from Jos van der Geest.
% Version 1 uploaded to FEX in 2012. Version 1 was absolutely lousy.
% Version 2 uploaded to FEX in 2014. The current version, Version 2, is medium-okay.
% Version 3 uploaded to FEX in May 2014, same usability, but now includes slidefun. 
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% EXAMPLES 
% * * * Example 1: * * *
% 
% load train % (let's assume y is has pascals as its units)
% spl(y,'air')
% ans = 
%        84.6
%    
% 
% * * * Example 2: Enter your own custom reference pressure: * * *
% 
% load train % (let's assume y is has pascals as its units)
% spl(y,20*10^-6)
% ans = 
%        84.6
%
% 
% * * * Example 3: A moving window of 501 elements and plot: * * *
% 
% load train
% SPL = spl(y,'air',501); % <-- Here's how to use the function. 
%  
% t = cumsum(ones(size(y))/Fs);
% figure
% subplot(2,1,1)
% plot(t,y)
% axis tight
% ylabel('pressure (Pa)')
% 
% subplot(2,1,2)
% plot(t,SPL)
% axis tight
% ylabel('spl (dB)')
% xlabel('time (s)')
% 
% 
% * * * Example 3: A 10 ms moving window and plot: * * *
%
% load train 
% SPL = spl(y,'air',0.010,Fs);
%  
% t = cumsum(ones(size(y))/Fs);
% figure
% subplot(2,1,1)
% plot(t,y)
% axis tight
% ylabel('pressure (Pa)')
% 
% subplot(2,1,2)
% plot(t,SPL)
% axis tight
% ylabel('spl (dB)')
% xlabel('time (s)')
%
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
% Note: Typically we only write decibels to integer values or one decimal
% place.  Anything on the hundredth-of-a-decibel level is probably just
% noise and can be ignored. 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

%% check inputs: 
assert(length(p_Pa)>1&&length(p_Pa)==numel(p_Pa),'Input p_Pa should be a vector.');

if exist('Fs','var')
    assert(numel(Fs)==1,'Sampling frequency Fs must be a scalar.')
    windowSize = ceil(windowSize*Fs); 
end

%% Define reference pressure: 

switch ref
    case {'air','Air','AIR','gas','Gas','GAS'}
        p_ref = 20*1e-6; % reference pressure in air is typically 20 uPa

    case {'water','Water','WATER','liquid','Liquid','LIQUID','SALTWATER','saltwater','Saltwater'}
        p_ref = 1*1e-6; % reference pressure in water is typically 1 uPa
        
    otherwise
        p_ref = ref; % reference pressure can be any user-defined value 'ref'
end


%% spl subfunction: 

function pointspl = calcspl(p_Pa,p_ref)
    p_rms = sqrt(mean(p_Pa.^2));
    pointspl = 20*log10(p_rms/p_ref);
end


%% final calculation: 

if exist('windowSize','var')
    assert(~mod(windowSize,1),'windowSize must be an integer');
    assert(windowSize<length(p_Pa),'windowSize must be smaller than the length of p_Pa'); 
    splz = @(p_Pa) calcspl(p_Pa,p_ref); 
    SPL = slidefun(splz,windowSize,p_Pa); 
else
    SPL = calcspl(p_Pa,p_ref);
end

end

% The following is a very slightly edited version of Jos van der Geest's
% slidefun function v4,(which was based on John D'Errico's movingstd) found here:
% www.mathworks.com/matlabcentral/fileexchange/12550 
function R = slidefun (FUN, W, V, windowmode, varargin) 

% check input arguments,expected
% <function name>, <window size>, <vector>, <windowmode>, <optional arguments ...>
error(nargchk(3,Inf,nargin)) ;

if nargin==3 || isempty(windowmode),
    windowmode = 'central' ;
end

% based on code by John D'Errico
if ~ischar(windowmode),
    error('WindowMode should be a character array') ;
else
    validmodes = {'central','backward','forward'} ;
    windowmode = strmatch(lower(windowmode), validmodes) ; %#ok
    if isempty(windowmode),
        error('Invalid window mode') ;
    end
end
% windowmode will 1, 2, or 3

if (numel(W) ~= 1) || (fix(W) ~= W) || (W < 1),
    error('Window size W must be a positive integer scalar.') ;
end

nV = numel(V) ;

if isa(FUN,'function_handle')
    FUNstr = func2str(FUN);
end

if nV==0,
    % trivial case
    R = V ;
    return
end

% can the function be applied succesfully?
try
    R = feval(FUN,V(1:min(W,nV)),varargin{:}) ;
    % feval did ok. Now check for scalar output
    if numel(R) ~= 1,
        error('Function "%s" does not return a scalar output for a vector input.', FUNstr) ;
    end
    
catch
    % Rewrite the error, likely to be caused by feval
    % For instance, function expects more arguments, ...    
    ERR = lasterror ;
    if numel(varargin)>0,
        ERR.message = sprintf('%s\r(This could be caused by the additional arguments given to %s).',ERR.message, upper(mfilename)) ;
    end
    rethrow(ERR) ;
end % try-catch

% where is the first relative element
switch windowmode 
    case 1 % central
        x0 = -floor(W/2) ;
    case 2 % backward
        x0 = -(W-1) ;
    case 3 % forward
        x0 = 0 ;
end
x1 = x0+W-1 ; % last relative element
x = x0:x1 ; % window vector (has W elements)

R = R(ones(size(V))) ; % pre-allocation !!

% The engine: seperation in three sections is faster than using a single
% loop with calls to min and max. 

% 1. leading elements
iend = min(-x0,nV-x1) ; % what is the last leading element, note that this might not exist
for i=1:iend,
    R(i) = feval(FUN,V(1:i+x1),varargin{:}) ;
end

% 2. main portion of V, start were section 1 finished
for i=(iend+1):(nV-x1),
    R(i) = feval(FUN,V(x+i),varargin{:}) ;
end

% 3. trailing elements, start were section 2 finished
for i=(i+1):nV,
    R(i) = feval(FUN,V((i+x0):nV),varargin{:}) ;
end
end

