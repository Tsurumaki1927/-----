function [r, v] = sv_from_coe(coe)
% sv_from_coe - Compute state vector (position and velocity) from classical orbital elements
%
% Input:
%   coe = [h e RA incl w TA]
%         h    = specific angular momentum (km^2/s)
%         e    = eccentricity
%         RA   = right ascension of ascending node (rad)
%         incl = inclination (rad)
%         w    = argument of perigee (rad)
%         TA   = true anomaly (rad)
%
% Output:
%   r = position vector in geocentric equatorial frame (km)
%   v = velocity vector in geocentric equatorial frame (km/s)
%
% Requires: global gravitational parameter mu (km^3/s^2)

global mu

% Extract orbital elements
h    = coe(1);
e    = coe(2);
RA   = coe(3);
incl = coe(4);
w    = coe(5);
TA   = coe(6);

% Position and velocity in the perifocal frame (pqw)
rp = (h^2 / mu) / (1 + e * cos(TA)) * [cos(TA); sin(TA); 0];
vp = (mu / h) * [-sin(TA); e + cos(TA); 0];

% Rotation matrices
R3_RA = [ cos(RA),  sin(RA), 0;
         -sin(RA),  cos(RA), 0;
               0,        0, 1];

R1_i = [1,        0,         0;
        0,  cos(incl), sin(incl);
        0, -sin(incl), cos(incl)];

R3_w = [ cos(w),  sin(w), 0;
        -sin(w),  cos(w), 0;
              0,       0, 1];

% Total transformation from perifocal to geocentric equatorial frame
Q_pX = R3_RA * R1_i * R3_w;

% Transform vectors
r = Q_pX * rp;
v = Q_pX * vp;

% Return as row vectors (optional, for consistency with some conventions)
r = r';
v = v';

end