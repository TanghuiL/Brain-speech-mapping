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

% Last Modified by GUIDE v2.5 28-Jan-2014 17:40:47

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
    'Fast AM'};
[yd,ye] = decompose_envelope(handles.current_data, handles.Fs);

y = handles.current_data;
Fs = handles.Fs;
handles.envelope = ye;

% spetrogram
lwindow = round(.05*Fs);
noverlap = round(.04*Fs);
nfft = round(.05*Fs);
figure();
F = 0:80;
[S,F,T] = spectrogram(ye',lwindow,noverlap,F,Fs,'yaxis');
imagesc(T,F,abs(S))
set(gca,'YDir','normal')
xlabel('Time(s)')
ylabel('Frequency (Hz)')
title('Spectrogram')
t = [0:1/Fs:(length(y)-1)/Fs]';
if 1
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
%     hold off;
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
%Nbank = 16;
Nbank = handles.Nbank;

nbits = 32;
if 0
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
elseif Nbank == 1.16
    for nk = [1 2 4 6 8 10 12 14 16],
        env_f = envelope_filterbank(handles.current_data, handles.Fs ,nk);
        len_signal = length(handles.current_data);
        fin_f = fin_structure_filterbank(handles.Fs,len_signal, nk);
        env_white_noise = comb_env_fin(env_f, fin_f);
        filename = [handles.PathName handles.FileName(1:end-4) '_white_noise_filterbank_cochlea_' num2str(nk)];
        wavwrite(env_white_noise,handles.Fs, nbits, filename)
    end
elseif 0
    env_f = envelope_filterbank(handles.current_data, handles.Fs , Nbank);
    len_signal = length(handles.current_data);
    fin_f = fin_structure_filterbank(handles.Fs,len_signal, Nbank);
    fin_all = fin_structure_filterbank(handles.Fs,len_signal, 1);
    env_white_noise = comb_env_fin(env_f, fin_f,2,fin_all);
    filename = [handles.PathName handles.FileName(1:end-4) '_white_noise_filterbank_cochlea_2_' num2str(Nbank)];
    wavwrite(env_white_noise,handles.Fs, nbits, filename)
else
    signal = handles.current_data;
    Fs = handles.Fs;
    env_f_16 = envelope_filterbank(signal, Fs, 16);
    env_f_1 = envelope_filterbank(signal, Fs, 1);
    
    len_signal = length(signal);
    fin_f = fin_structure_filterbank(Fs,len_signal, Nbank);
    fin_all = fin_structure_filterbank(Fs,len_signal, 1);
    
    env_white_noise1 = comb_env_fin(env_f_16, fin_f,2,fin_all);
    [yd,ye1] = decompose_envelope(env_white_noise1, Fs);
    
    env_white_noise16 = comb_env_fin(env_f_16, fin_f,1,fin_all);
    [yd,ye16] = decompose_envelope(env_white_noise16, Fs);
    [yd,ye_signal] = decompose_envelope(signal, Fs);
    %{
    figure
    plot(ye_signal)
    hold on
    plot(ye1,'g-')
    plot(ye16,'r-')
    %}
    % Force the envelopes to be the same
    r16 = ye_signal./(ye16+(abs(ye16)<1e-2));
    r1 = ye_signal./(ye1+(abs(ye1)<1e-2));
    yer1 = ye1.*r1;
    yer16 = ye16.*r16;
    env_white_noise1_r = env_white_noise1.*r1;
    env_white_noise16_r = env_white_noise16.*r16;
    % force the energy to be the same
    e_signal = sum(signal(abs(signal)>1e-2).^2);
    e1 = sum(env_white_noise1(abs(env_white_noise1)>1e-2).^2);
    e16 = sum(env_white_noise1(abs(env_white_noise1)>1e-2).^2);

    env_white_noise1_r = env_white_noise1_r.*sqrt(e_signal./e1);
    env_white_noise16_r = env_white_noise16.*sqrt(e_signal./e16);

    filename = [handles.PathName handles.FileName(1:end-4) '_white_noise_filterbank_cochlea_nbank_noise1_env16_test_ener'];
    wavwrite(env_white_noise1_r,handles.Fs, nbits, filename)
    filename = [handles.PathName handles.FileName(1:end-4) '_white_noise_filterbank_cochlea_nbank_noise16_env16_test_ener'];
    wavwrite(env_white_noise16_r,handles.Fs, nbits, filename)

end



function edit_Nbank_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Nbank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Nbank as text
%        str2double(get(hObject,'String')) returns contents of edit_Nbank as a double

handles.Nbank = get(hObject,'String');
handles.Nbank = str2num(handles.Nbank);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_Nbank_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Nbank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
