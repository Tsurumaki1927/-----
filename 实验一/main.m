% mu - gravitational parameter (km^3/s^2)
% coe - orbital elements [h e RA incl w TA a]
%     where h = angular momentum (km^2/s)
%           e = eccentricity
%           RA = right ascension of the ascending node (rad)
%           incl = orbit inclination (rad)
%           w = argument of perigee (rad)
%           TA = true anomaly (rad)
%           a = semimajor axis (km)

% r - position vector (km) in geocentric equatorial frame
% v - velocity vector (km) in geocentric equatorial frame

% User M-functions required: sv_from_coe

clear
global mu
deg = pi/180;
mu = 398600;

% Input data (angles in degrees):
h = 40000;
e = 1.4;
RA = 47;
incl = 30;
w = 60;
TA = 30;

coe = [h, e, RA * deg, incl * deg, w * deg, TA * deg];

% Algorithm 4.2 (requires angular elements be in radians):
[r, v] = sv_from_coe(coe);

% Echo the input data and output the results to the command window:
fprintf('----------------------------------------\n')
fprintf('\n Example 4.5\n')
fprintf('\n Gravitational parameter (km^3/s^2) = %g\n', mu)
fprintf('\n Angular momentum (km^2/s) = %g', h)
fprintf('\n Eccentricity = %g', e)
fprintf('\n Right ascension (deg) = %g', RA)
fprintf('\n Argument of perigee (deg) = %g', w)
fprintf('\n True anomaly (deg) = %g', TA)

fprintf('\n\n State vector:\n')
fprintf('\n r (km) = [%g %g %g]', r(1), r(2), r(3))
fprintf('\n v (km/s) = [%g %g %g]\n', v(1), v(2), v(3))