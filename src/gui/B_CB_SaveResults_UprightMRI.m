function GD = B_CB_SaveResults(hObject, GD)
if ishandle(hObject); GD = guidata(hObject); end
cd(GD.ToolPath)

if isfield(GD.Results, 'PlaneRotMat')
    
    PRM = GD.Results.PlaneRotMat;
    
    load(GD.Subject.PathMAT)
    
    S(1).USP.TFM  = GD.Subject.STL.TFM * PRM;
    S(1).USP.PFEA = [GD.Results.pFociLine(1:3)*PRM(1:3,1:3), GD.Results.pFociLine(4:6)*PRM(1:3,1:3)];
    S(1).USP.Ell  = GD.Results.Ell;
    
    save(GD.Subject.PathMAT, 'S', 'Subject')

    display('Results saved.')
else
    uiwait(errordlg('There are no results to save'));
end

if isfield(GD.Results, 'B_H_SaveResults')
    set(GD.Results.B_H_SaveResults,'Enable','off')
end

if ishandle(hObject); guidata(hObject,GD); end;
end