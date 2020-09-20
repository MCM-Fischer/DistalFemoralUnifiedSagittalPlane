clearvars; close all; opengl hardware

% Add src path
addpath(genpath([fileparts([mfilename('fullpath'), '.m']) '\src']));

%% Clone example data
if ~exist('VSD', 'dir')
    try
        !git clone https://github.com/RWTHmediTEC/VSDFullBodyBoneModels VSD
        rmdir('VSD/.git', 's')
    catch
        warning([newline 'Clone (or copy) the example data from: ' ...
            'https://github.com/RWTHmediTEC/VSDFullBodyBoneModels' newline 'to: ' ...
            fileparts([mfilename('fullpath'), '.m']) '\VSD' ...
            ' and try again!' newline])
        return
    end
end

%% Load subject names
load('VSD\MATLAB\res\VSD_Subjects.mat', 'Subjects')
Subjects = table2cell(Subjects);
Subjects(1:2:20,4) = {'L'}; Subjects(2:2:20,4) = {'R'};

for s=1%:size(Subjects, 1)

    % Prepare distal femur
    load(['VSD\Bones\' Subjects{s,1} '.mat'], 'B');
    load(['data\' Subjects{s,1} '.mat'],'inertiaTFM','uspInitialRot','distalCutPlaneInertia');
    femurInertia = transformPoint3d(B(ismember({B.name}, ['Femur_' Subjects{s,4}])).mesh, inertiaTFM);
    distalFemurInertia = cutMeshByPlane(femurInertia, distalCutPlaneInertia);
 
    %% Select different options by (un)commenting
    % Default mode
    [USPTFM, PFEA, CEA] = USP(distalFemurInertia, Subjects{s,4}, uspInitialRot, ...
        'Subject',Subjects{s,1});
    % Silent mode
    % [USPTFM, PFEA, CEA] = USP(distalFemurInertia, Subjects{s,4}, uspInitialRot, ...
    %    'Subject',Subjects{s,1}, 'Visu',false, 'Verbose',false);
    % The other options
    % [USPTFM, PFEA, CEA] = USP(distalFemurInertia, Subjects{s,4}, uspInitialRot, ...
    %    'Subject',Subjects{s,1}, 'PlaneVariationRange',12, 'StepSize',3);
    % Special case: 'PlaneVariationRange', 0 -> 48 additional figures!
    % [USPTFM, PFEA, CEA] = USP(distalFemurInertia, Subjects{s,4}, uspInitialRot, ...
    %    'Subject',Subjects{s,1}, 'PlaneVariationRange',0, 'StepSize',2);
end


% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts('USP_GUI.m');
% List.f = List.f'; List.p = List.p';

% % For publication
% set(gcf, 'GraphicsSmoothing','off')
% export_fig('Figure6', '-tif', '-r300')
