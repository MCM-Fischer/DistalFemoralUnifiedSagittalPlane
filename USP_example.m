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
Subjects = dir('data\*.mat');
Subjects = strrep({Subjects.name}','.mat','');
Subjects(1:2:20,2) = {'L'}; Subjects(2:2:20,2) = {'R'};

for s=1%:size(Subjects, 1)
    name = Subjects{s,1};
    side = Subjects{s,2};

    % Prepare distal femur
    load(['VSD\Bones\' name '.mat'], 'B');
    load(['data\' name '.mat'],'inertiaTFM','uspInitialRot','distalCutPlaneInertia');
    femurInertia = transformPoint3d(B(ismember({B.name}, ['Femur_' side])).mesh, inertiaTFM);
    distalFemurInertia = cutMeshByPlane(femurInertia, distalCutPlaneInertia);
 
    %% Select different options by (un)commenting
    % Default mode
    [USPTFM, PFEA, CEA] = USP(distalFemurInertia, side, uspInitialRot, 'Subject',name);
    % Silent mode
    % [USPTFM, PFEA, CEA] = USP(distalFemurInertia, side, uspInitialRot, 'Subject',name,...
    %    'Visu',false, 'Verbose',false);
    % The other options
    % [USPTFM, PFEA, CEA] = USP(distalFemurInertia, side, uspInitialRot, 'Subject',name,...
    %    'PlaneVariationRange',12, 'StepSize',3);
    % Special case: 'PlaneVariationRange', 0 -> 48 additional figures!
    % [USPTFM, PFEA, CEA] = USP(distalFemurInertia, side, uspInitialRot, 'Subject',name,...
    %   'PlaneVariationRange',0, 'StepSize',2);
end


% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';