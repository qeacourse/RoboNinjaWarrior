function duration = rostoc(ticIn)
global ticInternal;
t = rostime('now');
if nargin < 1
    delta = t - ticInternal;
else
    delta = t - ticIn;
end
duration = delta.seconds;
end