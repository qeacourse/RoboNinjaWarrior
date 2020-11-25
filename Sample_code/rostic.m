function ticOut = rostic()
global ticInternal;
t = rostime('now');
if nargout < 1
    ticInternal = t;
else
    ticOut = t;
end
end