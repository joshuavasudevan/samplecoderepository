function varargout = Thermal_image(varargin)
% Initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Thermal_image_OpeningFcn, ...
                   'gui_OutputFcn',  @Thermal_image_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Thermal_image is made visible.
function Thermal_image_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = Thermal_image_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1 (Load thermal image)
function pushbutton1_Callback(hObject, eventdata, handles)
global R G B range img unit
% Ask user to load input image. The input 
% image must contain thermal image to analyse
% and a colormap to map temprature range
[File,Path] = uigetfile({'*.jpg;*.tif;*.png;*.gif'},... 
                         'Select image to analyse'); %%browse menu take file name and path
img = imread([Path File]);
f_image = figure() ;imshow(img); %Showing loaded image
set(f_image,'Position',[60 60 1200 600]); % Zooming image
title('Select the colormap','FontSize',15)
rect = getrect; %Select the color map in image
Colormap=imcrop(img,rect); % Saving color map in another image
title('Select the analysis area','FontSize',15)
rect = getrect; %Select the area to analyse in image
img=imcrop(img,rect); % Croping image to analysis area

% Ask user for temp range
prompt = {'Colormap Max end:','Colormap Min end:','Unit:'};
answer = inputdlg(prompt,'Input',[1 50]);
range(1) = str2double(cell2mat(answer(1)));
range(2) = str2double(cell2mat(answer(2)));
unit = cell2mat(answer(3));
close(f_image);axes(handles.axes1)
imshow(img); %Updating loaded image

% Extract data from images
idx = fix(size(Colormap,2)/2);
R = Colormap(2:end-1,idx,1); %Range of red color
G = Colormap(2:end-1,idx,2); %Range of green color
B = Colormap(2:end-1,idx,3); %Range of blue color

% --- Executes on button press in pushbutton2 (Get temp at point)
function pushbutton2_Callback(hObject, eventdata, handles)
global R G B range img unit
[c,row] = ginput(1); % Get point position from user
c = fix(c); row = fix(row);
% Create temperature as function in RGB
T = linspace(range(1),range(2),length(R)); T = T';
r = img(row,c,1); % Red component of selected point
g = img(row,c,2); % Green component of selected point
b = img(row,c,3); % Blue component of selected point
%Looking for the closest point on the colormap
for tol = 1:length(R);
idx=((R<r+tol)&(R>r-tol))&((G<g+tol)&(G>g-tol))&((B<b+tol)&(B>b-tol));
t = T(idx);
if ~isempty(t),break,end
end
t=mean(t); % Calculated temperature is the mean of the tempretaure (t)
imshow(img),hold on,plot(c,row,'*b'),hold off %Show point
title(['Temperature = ',num2str(t),' ^o',unit],'FontSize',15); %show result

% --- Executes on button press in pushbutton3 (Get HotSpot)
function pushbutton3_Callback(hObject, eventdata, handles)
global R G B range img unit
S = size(img); n = S(1)*S(2);
t=zeros(S(1),S(2)); %Preallocation teperature matrix
% Create temperature as function in RGB
T = linspace(range(1),range(2),length(R)); T = T';
WB = waitbar(0,'Processing image ....');
count = 0;
for row=1:S(1)% Scan point position
    for c=1:S(2)
        r = img(row,c,1); % Red component of selected point
        g = img(row,c,2); % Green component of selected point
        b = img(row,c,3); % Blue component of selected point
        %Looking for the closest point on the colormap
        for tol = 1:length(R);
            idx=((R<r+tol)&(R>r-tol))&((G<g+tol)&(G>g-tol))&((B<b+tol)&(B>b-tol));
            tmp = T(idx);
            if ~isempty(tmp),break,end
        end
        t(row,c)=mean(tmp); % Calculated temperature
        count=count+1; waitbar(count/n,WB);
    end
end
thres = 0.95*max(T); %Threshold temp for a part to be hotspot
[row,c] = find(t>thres); temp=mean(mean(t(row,c)));
close(WB); % End of analysis
imshow(img),hold on %Show hotspot area
plot(c,row,'g.'),hold off 

if(temp<32.5)
title(['Temperature = ',num2str(temp),' ^o',unit,'  Fanger Scale = Cold'],'FontSize',15); %show result
elseif (temp>= 32.5 && temp <33.2)
 title(['Temperature = ',num2str(temp),' ^o',unit,'  Fanger Scale = Cool'],'FontSize',15); %show result 
elseif (temp>= 33.2 && temp <33.9)
 title(['Temperature = ',num2str(temp),' ^o',unit,'  Fanger Scale = Slightly Cool'],'FontSize',15); %show result
elseif (temp>= 33.9 && temp <35.1)
 title(['Temperature = ',num2str(temp),' ^o',unit,'  Fanger Scale = Neutral'],'FontSize',15); %show result
 elseif (temp>= 35.1 && temp <35.8)
 title(['Temperature = ',num2str(temp),' ^o',unit,'  Fanger Scale = Slightly Warm'],'FontSize',15); %show result
 elseif (temp>= 35.8 && temp <=36.1)
 title(['Temperature = ',num2str(temp),' ^o',unit,'  Fanger Scale = Warm'],'FontSize',15); %show result
 elseif (temp> 36.1)
 title(['Temperature = ',num2str(temp),' ^o',unit,'  Fanger Scale = Hot'],'FontSize',15); %show result
end


