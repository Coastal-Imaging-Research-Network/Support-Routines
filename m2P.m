function P = m2P(m)
%
% P = m2P(m)
%
% This function "converts" an m-vector into a P-matrix.
%

% simplified by Holman (again) 05/06/08

m = m(:)';
P = [m(1:4); m(8:11); [m(5:7) 1]];

%
% Copyright by Oregon State University, 2002
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: m2P.m 14 2016-02-11 01:33:40Z  $
%
% $Log: m2P.m,v $
% Revision 1.1  2008/05/06 23:15:38  stanley
% Initial revision
%
%
%key homogeneous new
%comment converts an m-vector into a P-matrix
%
