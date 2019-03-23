function varargout = startmain(varargin)
% STARTMAIN MATLAB code for startmain.fig
%      STARTMAIN, by itself, creates a new STARTMAIN or raises the existing
%      singleton*.
%
%      H = STARTMAIN returns the handle to a new STARTMAIN or the handle to
%      the existing singleton*.
%
%      STARTMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STARTMAIN.M with the given input arguments.
%
%      STARTMAIN('Property','Value',...) creates a new STARTMAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before startmain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to startmain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help startmain

% Last Modified by GUIDE v2.5 22-Mar-2019 17:37:49


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @startmain_OpeningFcn, ...
                   'gui_OutputFcn',  @startmain_OutputFcn, ...
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


% --- Executes just before startmain is made visible.
function startmain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to startmain (see VARARGIN)

% Choose default command line output for startmain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%���ó�ʼֵΪ0


% UIWAIT makes startmain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = startmain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function input_lon_Callback(hObject, eventdata, handles)
% hObject    handle to input_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_lon as text
%        str2double(get(hObject,'String')) returns contents of input_lon as a double

input_lon = str2double(get(hObject,'String'))
if is_err_lon(input_lon)
warndlg('���Ȳ���������-180��180��Χ�ڣ�','����')
end


    
    
    

% --- Executes during object creation, after setting all properties.
function input_lon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ��ȡ������ֵ
input_lon=str2double(get(handles.input_lon,'String'))
input_lat=str2double(get(handles.input_lat,'String'))
input_high=str2double(get(handles.input_high,'String'))
input_speed=str2double(get(handles.input_speed,'String'))
input_hxj=str2double(get(handles.input_hxj,'String'))
input_gl=str2double(get(handles.input_gl,'String'))
input_time=str2double(get(handles.input_time,'String'))

% �����ǲ���У�飬У��ʧ�ܵ�ʱ��ֱ�ӷ��أ������ú������з���
if is_err_lon(input_lon)
warndlg('���Ȳ���������-180��180��Χ�ڣ�','����')
return
end
if is_err_lon(input_lat)
warndlg('γ�Ȳ���������-90��90��Χ�ڣ�','����')
return
end
if is_err_high(input_high)
warndlg('�߶����ô���������1-12��������','����')
return
end
if is_err_speed(input_speed)
warndlg('�ٶ����ô���������800-1000��','����')
return
end
if is_err_hxj(input_hxj)
warndlg('��������ô���������0-360��','����')
return
end
if is_err_gl(input_gl)
warndlg('�������ô������������֣�','����')
return
end
if is_err_time(input_time)
warndlg('����ʱ�����ô������������֣�','����')
return
end



close % ����ǹرյ�ǰ��������Ľ���



% ������Ӧ�õ��������ķɻ��켣����

plane_tj(input_lon,input_lat,input_high,input_speed,input_gl,input_hxj,input_time)
% �ɻ��켣�����������




function input_lat_Callback(hObject, eventdata, handles)
% hObject    handle to input_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_lat as text
%        str2double(get(hObject,'String')) returns contents of input_lat as a double
input_lat = str2double(get(hObject,'String'))
if is_err_lon(input_lat)
warndlg('γ�Ȳ���������-90��90��Χ�ڣ�','����')
end

% --- Executes during object creation, after setting all properties.
function input_lat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_high_Callback(hObject, eventdata, handles)
% hObject    handle to input_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_high as text
%        str2double(get(hObject,'String')) returns contents of input_high as a double
input_high = str2double(get(hObject,'String'))
if is_err_high(input_high)
warndlg('�߶����ô���������0-12��������','����')
end

% --- Executes during object creation, after setting all properties.
function input_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_speed_Callback(hObject, eventdata, handles)
% hObject    handle to input_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_speed as text
%        str2double(get(hObject,'String')) returns contents of input_speed as a double

input_speed = str2double(get(hObject,'String'))
if is_err_speed(input_speed)
warndlg('�ٶ����ô���������800-1000��','����')
end

% --- Executes during object creation, after setting all properties.
function input_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_hxj_Callback(hObject, eventdata, handles)
% hObject    handle to input_hxj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_hxj as text
%        str2double(get(hObject,'String')) returns contents of input_hxj as a double

input_hxj = str2double(get(hObject,'String'))
if is_err_hxj(input_hxj)
warndlg('��������ô���������0-360��','����')
end

% --- Executes during object creation, after setting all properties.
function input_hxj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_hxj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_gl_Callback(hObject, eventdata, handles)
% hObject    handle to input_gl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_gl as text
%        str2double(get(hObject,'String')) returns contents of input_gl as a double

input_gl = str2double(get(hObject,'String'))
if is_err_gl(input_gl)
warndlg('�������ô������������֣�','����')
end

% --- Executes during object creation, after setting all properties.
function input_gl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_gl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_time_Callback(hObject, eventdata, handles)
% hObject    handle to input_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_time as text
%        str2double(get(hObject,'String')) returns contents of input_time as a double

input_time = str2double(get(hObject,'String'))
if is_err_time(input_time)
warndlg('����ʱ�����ô������������֣�','����')
end

% --- Executes during object creation, after setting all properties.
function input_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
