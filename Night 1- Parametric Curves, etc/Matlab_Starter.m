R = 2;% define a specific radius
u = linspace(0,2*pi,100); % define a set of evenly spaced points between 0 and 2*pi
r = [R*cos(u);R*sin(u);0*u];% define the position vector
That = [-sin(u);cos(u);0*u];% define the unit tangent (0*u is easy way to get set of 0's)
Nhat = [-cos(u);-sin(u);0*u];% define the unit normal (0*u is easy way to get set of 0's)
Bhat = [0*u;0*u;1*u./u];% define the unit binormal (1*u/.u is easy way to get set of 1's)
for n = 1:length(u)% loop through each of the points
    plot3(r(1,:),r(2,:),r(3,:)), axis([-3 3 -3 3 -3 3]),hold on % plot the entire curve
    quiver3(r(1,n),r(2,n),r(3,n),That(1,n),That(2,n),That(3,n),'r') % plot the unit tangent
    quiver3(r(1,n),r(2,n),r(3,n),Nhat(1,n),Nhat(2,n),Nhat(3,n),'b') % plot the unit normal
    quiver3(r(1,n),r(2,n),r(3,n),Bhat(1,n),Bhat(2,n),Bhat(3,n),'g'), hold off % plot the unit binormal
    drawnow % force the graphic to update as it goes
end