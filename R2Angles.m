function [az,tilt,roll] = R2Angles(R)

% function [az,tilt,roll] = R2Angles(R)
%
% Opposite of angles2R
%

tilt = acos(R(3,3)*-1);
roll = asin(R(1,3) / sin(tilt));
az1 = acos(R(3,2) / sin(tilt));
az2 = asin(R(3,1) / sin(tilt));

if (sign(az1) ~= sign(az2))
  az = az1*-1;
else
  az = az1;
end

az = mod(az, 2*pi);

%
% Copyright by Oregon State University, 2002
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: R2Angles.m 6 2016-02-11 00:46:00Z  $
%
% $Log: R2Angles.m,v $
% Revision 1.2  2005/06/09 17:45:53  stanley
% fix help
%
% Revision 1.1  2005/04/26 23:09:10  stanley
% Initial revision
%
%
%key geometry 
%comment  convert R to angles
%
