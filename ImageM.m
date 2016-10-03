function ImageM
% ImageM is a GUI program that aims to provide ImageJ-like experience in
% MATLAB.
%
% In this very first version, the only usable function is to allow drag and
% drop display of image file. Users can drage a file from file explorer and
% drop it over the text area. If the file is an image file supported by
% MATLAB, it'll be displayed in a new figure.
%
% Copyright, Chao-Yuan Yeh, 2016

hFig = figure('Name','ImageM', 'NumberTitle', 'off', 'position', ...
    [300 600 500 20], 'MenuBar', 'None');

tbh = uitoolbar(hFig);
a = .20:.05:0.95;
img1(:,:,1) = repmat(a,16,1)';
img1(:,:,2) = repmat(a,16,1);
img1(:,:,3) = repmat(flip(a),16,1);

pth = uipushtool(tbh,'CData',img1, 'TooltipString','My push tool',...
           'HandleVisibility','off','ClickedCallBack', 'disp(''clicked'')');

f = uimenu('Label','File');
uimenu(f,'Label','Open','Callback','disp(''Open'')');
    uimenu(f,'Label','Save','Callback','disp(''Save'')');
    uimenu(f,'Label','Quit','Callback','disp(''Exit'')',... 
           'Separator','on','Accelerator','Q');

dndcontrol.initJava();

% Create figure


% Create Java Swing JTextArea
jTextArea = javaObjectEDT('javax.swing.JTextArea', ...
    sprintf('ImageM version 1.0'));

% Create Java Swing JScrollPane
%             jScrollPane = javaObjectEDT('javax.swing.JScrollPane', jTextArea);
%             jScrollPane.setVerticalScrollBarPolicy(jScrollPane.VERTICAL_SCROLLBAR_ALWAYS);

% Add Scrollpane to figure
[~,hContainer] = javacomponent(jTextArea,[],hFig);
set(hContainer,'Units','normalized','Position',[0 0 1 1]);

% Create dndcontrol for the JTextArea object
dndobj = dndcontrol(jTextArea);

% Set Drop callback functions
dndobj.DropFileFcn = @demoDropFcn;
dndobj.DropStringFcn = @demoDropFcn;

% Callback function
function demoDropFcn(~,evt)
    txt = '';
    switch evt.DropType
        case 'file'
%                 jTextArea.setText('ImageM version 1.0')
            for n = 1:numel(evt.Data)
                jTextArea.setText(['Opening ', evt.Data{n}]);
                figure;
                imshow(evt.Data{1})
                
            end
        case 'string'
            jTextArea.append(sprintf('Dropped text:\n%s\n',evt.Data));
    end
    jTextArea.append(sprintf('\n'));
end
       
       
end