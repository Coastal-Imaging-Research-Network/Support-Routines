% Solve for k (intrinsic matrix) using camera calibration. Recall 
% that the projection matrix, P, is given as P = kR[I|-c]. Here we solve 
% for k, the intrinsic matrix. The CalTech calibrtation toolbox is used 
% for this.
%
%
%
% Required inputs:
%   1. A bunch of images of a checkerboard pattern. See resources for tips 
%      on acquiring these images
%   2. The CalTech toolbox, contained in the TOOLBOX_calib folder.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all

% 1. Start the CalTech toolbox
    disp('Select folder containing the calibration images');
    cd(uigetdir([])); % Need to be in the same folder as the images %
    calib_gui % This runs the Caltech toolbox %
    
    % Choose standard or memory efficient %
    % Follow the prompts from top-left to bottom right, starting with 'Image Names'
    % Enter 'DJI_' then 'j'
    % Click 'Extract Grid Corners'
    % Use defaults for numbers of images, wintx and winty (window size), and auto square counting
    % Extract the corners of the first image. See resources on how to do this
    % Enter 60 for the square size in both dimensions
    % Extract corners of all remaining images %
    % Click 'Calibration' to perform calibration
    % Add/surpress images as needed
    % Save the results. Saved to current directory.

% 2. Once you are happy with calibration, create the Lens Calibration Profile (LCP) structure %
    lcp.NU = nx;            % number of pixel columns
    lcp.NV = ny;            % number of pixel rows
    lcp.c0U = cc(1);        % 2 components of principal points    
    lcp.c0V = cc(2);   
    lcp.fx = fc(1);         % 2 components of focal lengths (in pixels)   
    lcp.fy = fc(2);
    lcp.d1 = kc(1);         % radial distortion coefficients
    lcp.d2 = kc(2);
    lcp.d3 = kc(5);
    lcp.t1 = kc(3);         % tangential distortion coefficients
    lcp.t2 = kc(4);
    lcp.r = 0:0.001:1.5;
    lcp = makeRadDist(lcp); % computes the radial stretch factor
    lcp = makeTangDist(lcp);% computes the tangential stretch factor
    
% 3. Save the lcp structure to the Outputs folder for use in the next step
    foo = what('Outputs');
    save([foo.path,'/lcp.mat'],'lcp')
    