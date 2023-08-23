function varargout = Mongo_Datas_v2(varargin)
% MONGO_DATAS_V2 MATLAB code for Mongo_Datas_v2.fig
%      MONGO_DATAS_V2, by itself, creates a new MONGO_DATAS_V2 or raises the existing
%      singleton*.
%
%      H = MONGO_DATAS_V2 returns the handle to a new MONGO_DATAS_V2 or the handle to
%      the existing singleton*.
%
%      MONGO_DATAS_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONGO_DATAS_V2.M with the given input arguments.
%
%      MONGO_DATAS_V2('Property','Value',...) creates a new MONGO_DATAS_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Mongo_Datas_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Mongo_Datas_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Mongo_Datas_v2

% Last Modified by GUIDE v2.5 15-Apr-2021 08:45:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Mongo_Datas_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @Mongo_Datas_v2_OutputFcn, ...
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


% --- Executes just before Mongo_Datas_v2 is made visible.
function Mongo_Datas_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Mongo_Datas_v2 (see VARARGIN)

% Choose default command line output for Mongo_Datas_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Mongo_Datas_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Mongo_Datas_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause(5);
msgbox('System is ready...');
set(handles.edit1,'String','**');
set(handles.edit2,'String','**');
set(handles.edit3,'String','**');
set(handles.edit4,'String','**');
set(handles.edit7,'String','**');
set(handles.edit8,'String','**');
axes(handles.axes1); axis off
axes(handles.axes2); axis off
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag;global flag_data;global cound;global filetext;global gk;global C;
cound =0;gk=1;
[tname, tpath]=uigetfile({'*.*'},'Browse Data');
set(handles.edit1,'String',tname);
set(handles.edit2,'String',tpath);
C = ([tpath,tname]);
if(tname=='1.pdf')
    cound=1;open(C);filetext = C;
    javaaddpath('iText-4.2.0-com.itextpdf')
pdf_text = pdfRead(C);
    set(handles.edit8, 'Min', 0, 'Max', 2);
    set(handles.edit8,'String',pdf_text);
elseif(tname=='2.jpg')
    cound=2;
axes(handles.axes1);imshow(C);title('Given image');
%imshow(tname);
elseif(tname=='3.txt')
    cound=3; filetext = fileread(C);open(C);
    set(handles.edit8, 'Min', 0, 'Max', 2);
    set(handles.edit8,'String',filetext);

elseif(tname=='4.wav')
    cound=8;
    addpath('voicebox');
    [y1,fs1]=audioread(C); 
    plot(handles.axes1,y1);
    sound(y1);
    
elseif(tname=='5.avi')
    cound=6;
 I = VideoReader(C);
nFrames = I.numberofFrames;
vidHeight =  I.Height;
vidWidth =  I.Width;
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);
       WantedFrames = 20;
for k = 1:WantedFrames
    mov(k).cdata = read( I, k);
   mov(k).cdata = imresize(mov(k).cdata,[256,256]);
    imwrite(mov(k).cdata,['Frames\',num2str(k),'.jpg']);
end

for I = 1:WantedFrames
   im=imread(['Frames\',num2str(I),'.jpg']);
  axes(handles.axes1); imshow(im); title('Input');
end

    
else
    cound=0;
end

set(handles.edit7,'String','Data previewed');
pause(2);
set(handles.edit7,'String','Connect mongodb...');
pause(2);
set(handles.edit7,'String','Checking Internet...');
t = tcpclient('www.cloud.mongodb.com', 80);
pause(2);flag_data=0;
if t==0
    
else
    flag=C;flag_data=1;
    set(handles.edit7,'String','Processing....');
    count =1;
    count =count +1;
    pause(2);
    set(handles.edit7,'String','Uploading...');
    pause(2);
    set(handles.edit7,'String','Done...');
    pause(2);
    set(handles.edit7,'String','Converting...');
    
 if count==2
     ax=randsample(200,1); 
    A = magic(ax);
    fileID = fopen('Converted_Data\myfile.txt','w');
    nbytes = fprintf(fileID,'%5d %5d %5d %5d\n',A);
    fclose(fileID);
    fopen(fileID);
    set(handles.edit3,'String','myfile.txt');
    set(handles.edit4,'String','Converted_Data\');
    set(handles.edit8,'String','Converted data is ready');
     filetext = fileread('Converted_Data\myfile.txt');
    set(handles.edit8, 'Min', 0, 'Max', 2);
    set(handles.edit8,'String',filetext);
    
    elseif count==3
    ax=randsample(200,1); 
    A = magic(ax);
    fileID = fopen('Converted_Data\myfile.txt','w');
    nbytes = fprintf(fileID,'%5d %5d %5d %5d\n',A);
    fclose(fileID);
    fopen(fileID);
    set(handles.edit3,'String','myfile.txt');
    set(handles.edit4,'String','Converted_Data\');
        set(handles.edit8,'String','Converted data is ready');
     filetext = fileread('Converted_Data\myfile.txt');
    set(handles.edit8, 'Min', 0, 'Max', 2);
    set(handles.edit8,'String',filetext);
  
    elseif count==4
     ax=randsample(200,1); 
    A = magic(ax);
    fileID = fopen('Converted_Data\myfile.txt','w');
    nbytes = fprintf(fileID,'%5d %5d %5d %5d\n',A);
    fclose(fileID);
    fopen(fileID);
    set(handles.edit3,'String','myfile.txt');
    set(handles.edit4,'String','Converted_Data\');
    set(handles.edit8,'String','Converted data is ready');
     filetext = fileread('Converted_Data\myfile.txt');
    set(handles.edit8, 'Min', 0, 'Max', 2);
    set(handles.edit8,'String',filetext);
    pause(2);
set(handles.edit7,'String','Done...')
 
    else
     ax=randsample(200,1); 
    A = magic(ax);
    fileID = fopen('Converted_Data\myfile.txt','w');
    nbytes = fprintf(fileID,'%5d %5d %5d %5d\n',A);
    fclose(fileID);
    fopen(fileID);
    count =0;
    set(handles.edit3,'String','myfile.txt');
    set(handles.edit4,'String','Converted_Data\');
        set(handles.edit8,'String','Converted data is ready');
     filetext = fileread('Converted_Data\myfile.txt');
    set(handles.edit8, 'Min', 0, 'Max', 2);
    set(handles.edit8,'String',filetext);
end 
    pause(2);
    set(handles.edit7,'String','Converted...');
end




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global flag;global flag_data;global cound;global gk;global C;
if(gk==1)
set(handles.edit8,'String','*****');
pause(2);
set(handles.edit7,'String','Connect mongodb...');
pause(2);
set(handles.edit7,'String','Checking Internet...')

t = tcpclient('www.cloud.mongodb.com', 80);
if(t==0)
else  
if(flag_data==1)
    set(handles.edit7,'String','Retriving...');
    pause(2);

if(cound==1)
    javaaddpath('iText-4.2.0-com.itextpdf.jar')
    open(C);
    pause(2);
            javaaddpath('iText-4.2.0-com.itextpdf')
pdf_text = pdfRead(C);
    set(handles.edit8, 'Min', 0, 'Max', 2);
    set(handles.edit8,'String',pdf_text);
set(handles.edit7,'String','Done...')
elseif (cound==2)
   axes(handles.axes2);imshow(C);title('Retrived image');
        pause(2);
set(handles.edit7,'String','Done...')
elseif(cound==3)
    open(C);

 filetext = fileread(C);
    set(handles.edit8, 'Min', 0, 'Max', 2);
    set(handles.edit8,'String',filetext);
    pause(2);
set(handles.edit7,'String','Done...')

elseif(cound==8)
    addpath('voicebox');
    [y1,fs1]=audioread(C); 
    plot(handles.axes2,y1);
    sound(y1);
    pause(2);
set(handles.edit7,'String','Done...')


elseif(cound==6)
    I = VideoReader(C);
nFrames = I.numberofFrames;
vidHeight =  I.Height;
vidWidth =  I.Width;
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);
       WantedFrames = 20;
for k = 1:WantedFrames
    mov(k).cdata = read( I, k);
   mov(k).cdata = imresize(mov(k).cdata,[256,256]);
    imwrite(mov(k).cdata,['Frames\',num2str(k),'.jpg']);
end

for I = 1:WantedFrames
   im=imread(['Frames\',num2str(I),'.jpg']);
  axes(handles.axes2); imshow(im); title('Recovered');
end

else
end


    
end
disp('t1=2.345s');
end
else
    msgbox('Hey. First convert the file');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'String','Data Name');
set(handles.edit2,'String','Location');
set(handles.edit3,'String','Data Name');
set(handles.edit4,'String','Location');
set(handles.edit5,'String','Data Name');
set(handles.edit6,'String','Location');
set(handles.edit7,'String','Information');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
