function R = makeResMapLocal(cA, XYZDesc)
%       R = makeResMapLocal(camArray, XYZDesc)
%
% makeResMapLocal - calculates resolution maps for a suite of cameras
%
%  Usage: R = makeResMap(camArrayStruct, XYZDesc)
%  Input: 
%    camArrayStruct is a vector of cameras, each with a structure
%    including:
%      [azimuth tilt horzFOV NU NV camX camY camZ]
%      All angles are in radians, azimuth is measured CW from the pos. 
%      y-axis,and tilt is measured from nadir (0 degrees is down).
%    XYZ is  a 6 element vector of the form
%      [xMin xMax yMin yMax dx dy zLevel].  
%    dx dy are the output array resolutions.
%    z is the vertical projection level, usually 0.
%
%  Output:
%  R is a structure with the fields (all in m/pixel units, out of range
%  values are indiated by NaNs, minimum values from overlapping cameras
%  are returned):
%    dRange - range-directed pixel footprint (azimuthal resolution) 
%    dcRange - cross-range pixel footprint (cross-azimuthal resolution)
%    daProj - maximum of alongshore projection of pixel footprint major axes
%    dcProj - maximum of cross-shore projection of pixel footprint major axes


% make x-y grid
x = [XYZDesc(1): XYZDesc(5): XYZDesc(2)];
y = [XYZDesc(3): XYZDesc(6): XYZDesc(4)];
[X,Y] = meshgrid(x,y);
XYZ = [X(:) Y(:) repmat(XYZDesc(7), size(X(:)))];
    
% find resolution for each camera, merge and reshape
for j = 1:size(cA,1)
    Rt(j) = resMapLocal(cA(j,:),XYZ);
end

R.dcRange = min([Rt.dcRange],[],2);
R.daRange = min([Rt.daRange],[],2);
R.daProj = min([Rt.daProj],[],2);
R.dcProj = min([Rt.dcProj],[],2);

[M, N] = size(X);
R.dcRange = reshape(R.dcRange,M,N);
R.daRange = reshape(R.daRange,M,N);
R.daProj= reshape(R.daProj,M,N);
R.dcProj= reshape(R.dcProj,M,N);
R.x = x;
R.y = y; 

