syms u;
% encode the fact that u is a real number (allows simplifications)
assume(u,'real');

% create a symbolic expression for an ellipse
R = sym([0.5*cos(u); 0.3*sin(u); 0]);

% compute the tangent vector
T = diff(R);
% compute That.  Simplify will make sure things are in a sane form.
That = simplify(T ./ norm(T));
Nhat = simplify(diff(That)./norm(diff(That)));
Bhat = simplify(cross(That, Nhat))
figure;
% make a plot
fplot3(R(1), R(2), R(3), [0, 2*pi]);