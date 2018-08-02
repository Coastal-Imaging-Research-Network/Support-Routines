% Perform the rectification using the 11 solved-for unknowns from
% the previous two practicums. Recall that the projection matrix, P, is given as 
% P = kR[I|-c]. We have now solved for k, R, and c, so here we create P and
% perform the rectification (conversion of image cordinates to real world
% coordinates). 
%
%
%
% Required inputs:
%   1. The lcp structure from Step 1
%   2. The beta vector from Step 2
%   3. The loaded image data 
% *We have saved all these to the Outputs folder during the previous two
% practicums*
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all

% 1. Load everything we need from the previous steps
    foo = what('Outputs');
    load([foo.path,'/lcp.mat']); 
    load([foo.path,'/beta.mat']); 
    load([foo.path,'/image.mat']); 

% 2. Define the world coordinate grid over which to interpolate the image
    xmin = 50;
    xmax = 500;
    dx = .2;
    ymin = 300;
    ymax = 1000;
    dy = .2;
    xy = [xmin dx xmax ymin dy ymax];
    
% 3. Establish the elevation to perform the rectification on %
    z = 0;
    
% 4. Perform the rectification
    % organize indices
    [NV,NU,NC] = size(I);
    Us = [1:NU];
    Vs = [1:NV]';

    % define x,y,z grids
    x = [xy(1):xy(2): xy(3)]; y = [xy(4):xy(5): xy(6)];
    [X,Y] = meshgrid(x,y);

    if length(z)==1
        xyz = [X(:) Y(:) repmat(z, size(X(:)))];
    else
        xyz = [X(:) Y(:) z(:)];
    end

    % Recall, Projection Matrix, P=KR[I|-C]
    %Calculate P matrix
    %define K matrix (intrinsics)
    K = [lcp.fx 0 lcp.c0U;  
         0 -lcp.fy lcp.c0V;
         0  0 1];
    %define rotation matrix, R (extrinsics)
    R = angles2R(beta(4), beta(5), beta(6));
    %define identity & camera center coordinates
    IC = [eye(3) -beta(1:3)'];
    %calculate P
    P = K*R*IC;
    %make P homogenous
    P = P/P(3,4);   

    % Now, convert XYZ coordinates to UV coordinates
    %convert xyz locations to uv coordinates
    UV = P*[xyz'; ones(1,size(xyz,1))];
    %homogenize UV coordinates (divide by 3 entry)
    UV = UV./repmat(UV(3,:),3,1);

    %convert undistorted uv coordinates to distorted coordinates
    [U,V] = distort(UV(1,:),UV(2,:),lcp); 
    UV = round([U; V]);%round to the nearest pixel locations
    UV = reshape(UV,[],2); %reshape the data into something useable

    %find the good pixel coordinates that are actually in the image 
    good = find(onScreen(UV(:,1),UV(:,2),NU,NV));
    %convert to indices
    ind = sub2ind([NV NU],UV(good,2),UV(good,1));

    % Finally, grab the RGB intensities at the indices you need and fill into your XYgrid
    %preallocate final orthophoto
    Irect = zeros(length(y),length(x),3);
    for i = 1:NC    % cycle through R,G,B intensities
        singleBandImage = I(:,:,i); %extract the frame
        rgbIndices = singleBandImage(ind); %extract the data at the pixel locations you need
        tempImage = Irect(:,:,i); %preallocate the orthophoto size based on your x,y 
        tempImage(good) = rgbIndices; %fill your extracted pixels into the frame
        Irect(:,:,i) = tempImage; %put the frame into the orthophoto
    end

    frameRect.x=x;
    frameRect.y=y;
    frameRect.I=Irect;

    % Plot the rectified image %
    figure;imagesc(frameRect.x,frameRect.y,uint8(frameRect.I));
    axis xy;axis image







