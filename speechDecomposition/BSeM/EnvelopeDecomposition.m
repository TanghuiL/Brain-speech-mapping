function varargout = EnvelopeDecomposition(varargin)
% ENVELOPEDECOMPOSITION MATLAB code for EnvelopeDecomposition.fig
%      ENVELOPEDECOMPOSITION, by itself, creates a new ENVELOPEDECOMPOSITION or raises the existing
%      singleton*.
%
%      H = ENVELOPEDECOMPOSITION returns the handle to a new ENVELOPEDECOMPOSITION or the handle to
%      the existing singleton*.
%
%      ENVELOPEDECOMPOSITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENVELOPEDECOMPOSITION.M with the given input arguments.
%
%      ENVELOPEDECOMPOSITION('Property','Value',...) creates a new ENVELOPEDECOMPOSITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EnvelopeDecomposition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EnvelopeDecomposition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EnvelopeDecomposition

% Last Modified by GUIDE v2.5 14-Jan-2014 12:32:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @EnvelopeDecomposition_OpeningFcn, ...
    'gui_OutputFcn',  @EnvelopeDecomposition_OutputFcn, ...
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


% --- Executes just before EnvelopeDecomposition is made visible.
function EnvelopeDecomposition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EnvelopeDecomposition (see VARARGIN)

% Choose default command line output for EnvelopeDecomposition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EnvelopeDecomposition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EnvelopeDecomposition_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Speech_File_Callback(hObject, eventdata, handles)
% hObject    handle to Speech_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_File_Callback(hObject, eventdata, handles)
% hObject    handle to Open_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{
[filename, pathname] = uigetfile( ...
{'*.m;*.fig;*.mat;*.mdl','MATLAB Files (*.m,*.fig,*.mat,*.mdl)';
   '*.m',  'M-files (*.m)'; ...
   '*.fig','Figures (*.fig)'; ...
   '*.mat','MAT-files (*.mat)'; ...
   '*.mdl','Models (*.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');
%}
[FileName,PathName] = uigetfile({'*.wav', 'wave files (*.wav)'},'Select a sound file');
[y, Fs] = wavread([PathName FileName]);
handles.FileName = FileName;
handles.PathName = PathName;
handles.current_data = y;
handles.Fs = Fs;
guidata(hObject, handles)


% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y =handles.current_data;
Fs = handles.Fs;
t = [0:1/Fs:(length(y)-1)/Fs]';
plot(t,y,'c-')
xlabel('time (sec)')
ylabel('amplitude')


% --- Executes on button press in pushbutton_decompose.
function pushbutton_decompose_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_decompose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tier ={'Signal','Envelope', 'Slow AM', ...
    'Stress AM', ...
    'Syllable AM', ...
    'Sub-beat AM', ...
    'Fast AM'}
[yd,ye] = decompose_envelope(handles.current_data, handles.Fs);

y = handles.current_data;
Fs = handles.Fs;
handles.envelope = ye;

t = [0:1/Fs:(length(y)-1)/Fs]';
if 0
    plot(handles.axes_plot,t,handles.current_data,'c-')
    hold on
    plot(handles.axes_plot, t, ye,'m-','LineWidth',2)
else
    figure(2)
    subplot(611)
    plot(t,handles.current_data,'c-')
    hold on;
    plot(t, ye,'m-','LineWidth',2)
    xlabel('time (sec)')
    ylabel('amplitude')
    legend(tier{1}, tier{2})
    hold off;
end


colors = 'kbrgm';
t = [0:100/Fs:100*(length(yd{1})-1)/Fs];

for i = 1:length(yd),
    if 0
        plot(handles.axes_plot,t,yd{i},[colors(i) '-'],'LineWidth',2)
    else
        figure(2)
        subplot(6,1,i+1)
        plot(t,yd{i},[colors(i) '-'],'LineWidth',2)
        xlabel('time (sec)')
        ylabel('amplitude')
        legend(tier{i+2})
    end
    
end
if 0
    legend('Signal','Envelope', 'Slow AM', ...
        'Stress AM', ...
        'Syllable AM', ...
        'Sub-beat AM', ...
        'Fast AM','Location','SouthEast');
    
    xlabel('time (sec)')
    ylabel('amplitude')
end

guidata(hObject, handles)

% --- Executes on button press in GetEnv.
function GetEnv_Callback(hObject, eventdata, handles)
% hObject    handle to GetEnv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tier ={'Signal','Envelope', 'Slow AM', ...
    'Stress AM', ...
    'Syllable AM', ...
    'Sub-beat AM', ...
    'Fast AM'}
[yd,ye] = decompose_envelope(handles.current_data, handles.Fs);

y = handles.current_data;
Fs = handles.Fs;
t = [0:1/Fs:(length(y)-1)/Fs]';
if 0
    plot(handles.axes_plot,t,handles.current_data,'c-')
    hold on
    plot(handles.axes_plot, t, ye,'m-','LineWidth',2)
else
    figure(2)
    subplot(611)
    plot(t,handles.current_data,'c-')
    hold on;
    plot(t, ye,'m-','LineWidth',2)
    xlabel('time (sec)')
    ylabel('amplitude')
    legend(tier{1}, tier{2})
    hold off;
end


colors = 'kbrgm';
t = [0:100/Fs:100*(length(yd{1})-1)/Fs];

for i = 1:length(yd),
    if 0
        plot(handles.axes_plot,t,yd{i},[colors(i) '-'],'LineWidth',2)
    else
        figure(2)
        subplot(6,1,i+1)
        plot(t,yd{i},[colors(i) '-'],'LineWidth',2)
        xlabel('time (sec)')
        ylabel('amplitude')
        legend(tier{i+2})
    end
    
end
if 0
    legend('Signal','Envelope', 'Slow AM', ...
        'Stress AM', ...
        'Syllable AM', ...
        'Sub-beat AM', ...
        'Fast AM','Location','SouthEast');
    
    xlabel('time (sec)')
    ylabel('amplitude')
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10


% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12


% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14


% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15


% --- Executes on button press in recontruct_white_pushbutton.
function recontruct_white_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to recontruct_white_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ye = handles.envelope;
n_sample = length(ye);
white_noise = randn(1,n_sample);
%white_noise = 2*(white_noise - mean(white_noise));
if size(ye,2)==2
    for i =1:2
        yech = ye(:,i);
        rec_signal = yech(:).*white_noise(:);
        filename = [handles.PathName handles.FileName(1:end-4) 'white_noise' num2str(i) 'ch'];
        wavwrite(rec_signal,handles.Fs, filename)
    end
else
    
    rec_signal = ye(:).*white_noise(:);
    filename = [handles.PathName handles.FileName(1:end-4) 'white_noise'];
    wavwrite(rec_signal,handles.Fs, filename)
    
end