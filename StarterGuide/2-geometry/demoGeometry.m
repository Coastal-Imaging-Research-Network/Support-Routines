% Solve for R (rotation matrix) and c (camera location) using GCP
% identification. Recall that the projection matrix, P, is given as 
% P = kR[I|-c]. k has already been found, so here we solve for the
% remaining free parameters in P.
%
%
%
% Required inputs:
%   1. The lcp structure from Practicum 1 (saved in Outputs folder)
%   2. A .mat file describing your GCPs. This is a matrix with columns:
%      number, name, x,y,z. The necessary one is provided called 
%      demoGeometryGCPFile.mat
%   3. The image file which you are trying to rectify. Here we are going to
%   rectify demoGeometryImage.jpg
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all

% Load the lcp structure from step 1 %
    foo = what('Outputs');
    load([foo.path,'/lcp.mat'])
    
% 1. Start establishing inputs, including the directories of the GCP file
%    and image to be rectified
    inputs.stationStr = 'Aerielle';
    display('Select directory that contains demoGeometryGCPFile.mat')
        gcpFileDir = uigetdir([]);
        inputs.gcpFn = [gcpFileDir,filesep,'demoGeometryGCPFile.mat'];
    display('Select the image to use for geom demo');
        [imageFile,imagePath] = uigetfile('*');
        inputs.Ifn = [imagePath,imageFile];
    
% 2. Establish the rest of the inputs by specifying initial guesses for the
%    (at most) 6 unknowns being solved for 
    prompt = {['This vector defines the six extrinsic variables: the (x,y,z) camera ',...
        'location and the three viewing angles in the order [ xCam yCam zCam Azimuth',...
        'Tilt Roll]. Enter 1 in knownFlags for known variables and 0 for unkowns.  For example,',...
        'knownFlags = [1 1 0 0 0 1] means that camX and camY and roll are ',...
        'known so should not be solved for. knowFlags = '], 'Input (x,y) location of camera',...
        'Input elevation of camera','Input azimuth and tilt','Input roll'};
    dlg_title = 'Extrinsic Inputs';
    num_lines = 1;
    defaultans = {'0 0 0 0 0 0','0 600','100','95 60','0'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

    inputs.knownFlags = logical(str2num(cell2mat(answer(1))));
    inputs.xyCam = str2num(cell2mat(answer(2)));
    inputs.zCam = str2num(cell2mat(answer(3)));             % based on last data run                
    inputs.azTilt = str2num(cell2mat(answer(4))) / 180*pi;          % first guess
    inputs.roll = str2num(cell2mat(answer(5))) / 180*pi; 
    betas = [inputs.xyCam inputs.zCam inputs.azTilt inputs.roll];  % fullvector
    inputs.beta0 = betas(find(~inputs.knownFlags));
    inputs.knowns = betas(find(inputs.knownFlags));

% 3. Specify which of your GCPs are visible in your image %
    prompt = {'Examine your image and determine which GCPs can be seen and digitized.  List them in the order that you want to digitize them.'};
    dlg_title = 'GCP Inputs';
    num_lines = 1;
    defaultans = {'1 2 3 6 7'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    inputs.gcpList = str2num(cell2mat(answer)); 
    
% 4. Establish the metas variable %
    meta.globals.knownFlags = inputs.knownFlags;
    meta.globals.knowns = inputs.knowns;   
    meta.globals.lcp = lcp;
    
% 5. Load the GCPs and image     
    load(inputs.gcpFn);             % load gcps
    I = imread(inputs.Ifn);
    [NV, NU, NC] = size(I);

% 6. Solve for the unknowns, i.e. find the geometry %
    beta = find6DOFGeom(I, gcp, inputs, meta);
    
% 7. Save the beta vector, image data, and meta file into the Outputs
%    folder for use in the next practicum
    save([foo.path,'/beta.mat'],'beta')
    save([foo.path,'/image.mat'],'I')
    save([foo.path,'/meta.mat'],'meta')

    
    
    