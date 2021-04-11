function R = gradient_ascent(...
    grad, ...
    r_0, ...
    delta, ...
    lambda_0, ...
    tolerance, ...
    n_max ...
)
% gradient_ascent  perform gradient ascent on a multivariate function
% 
% Usage
%   R = gradient_ascent(grad, r_0, delta, lambda_0, tolerance, n_max)
% Arguments
%   grad = (function handle) gradient of function-to-maximize, must return
%          a vector
%   r_0 = (vector) initial guess
%   delta = (float) stepsize decay parameter; should have delta < 1
%   lambda_0 = (float) initial stepsize
%   tolerance = (float) gradient convergence tolerance
%   n_max = (int) maximum iteration count
% Returns
%   R = (matrix) full iteration history

%% Setup
r_i = r_0;
grad_i = grad(r_i);
n = 0;
lambda = lambda_0;
R = [r_i];

%% Main loop
while (n < n_max) && (norm(grad_i) > tolerance)
    % Gradient ascent step
    r_i = r_i + lambda * grad_i;
    
    % Iterate loop variables
    grad_i = grad(r_i);
    lambda = delta * lambda;
    n = n + 1;
    R(end + 1, :) = r_i;
end

end