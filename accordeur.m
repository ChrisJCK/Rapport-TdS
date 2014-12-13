function varargout = accordeur(varargin)
% ACCORDEUR MATLAB code for accordeur.fig
%      ACCORDEUR, by itself, creates a new ACCORDEUR or raises the existing
%      singleton*.
%
%      H = ACCORDEUR returns the handle to a new ACCORDEUR or the handle to
%      the existing singleton*.
%
%      ACCORDEUR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACCORDEUR.M with the given input arguments.
%
%      ACCORDEUR('Property','Value',...) creates a new ACCORDEUR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before accordeur_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to accordeur_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help accordeur

% Last Modified by GUIDE v2.5 11-Dec-2014 22:40:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @accordeur_OpeningFcn, ...
                   'gui_OutputFcn',  @accordeur_OutputFcn, ...
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

% --- Executes just before accordeur is made visible.
function accordeur_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to accordeur (see VARARGIN)

% Choose default command line output for accordeur
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using accordeur.
if strcmp(get(hObject,'Visible'),'off')
   %% Déclaration des variables
    La =  440;
    ajoutDemiTon = 2^(1/12);
    ajoutTon = 2^(1/6);
    Octave3 = cell(2,12);
    Octave3(1,:)={'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
    
    %% Génération du tableau de la 3ème octave
    Octave3{2,10}=La;

    for i = 10:11
        Octave3{2,i+1}=Octave3{2,i}*ajoutDemiTon;
    end;
    for i = 10:(-1):2
        Octave3{2,i-1}=Octave3{2,i}/ajoutDemiTon;
    end;
    
    %% Génération des tableaux des différents accords
    % Classique E
    AccordE = cell(2,6);
    AccordE(1,:)={'E','A','D','G','B','E'};
    AccordE = initAccordEOpen(AccordE, Octave3);
    
    % Drop D
    AccordDropD = AccordE;
    AccordDropD{1,1}='D';
    for j= 1:12
        if (Octave3{1,j}==AccordDropD{1,1})
            AccordDropD{2,1} = Octave3{2,j}/4;
        end;
    end;
    
    % Quartes
    AccordQuartes = AccordE;
    AccordQuartes{1,5}='C';
    AccordQuartes{1,6}='F';
    for i = 5:6
        for j= 1:12
            if (Octave3{1,j}==AccordQuartes{1,i})
                AccordQuartes{2,i} = Octave3{2,j};
            end;
        end;
    end;

    % Open D
    AccordOpenD = cell(2,6);
    AccordOpenD(1,:)={'D','A','D','F#','A','D'};
    AccordOpenD = initAccordEOpen(AccordOpenD, Octave3);

    % Open G
    AccordOpenG = cell(2,6);
    AccordOpenG(1,:)={'D','G','D','G','B','D'};
    AccordOpenG = initAccordEOpen(AccordOpenG, Octave3);
    
    %% Memoriser les variables pour l'interface graphique
    handles.AccordE = AccordE;
    handles.AccordDropD = AccordDropD;
    handles.AccordQuartes = AccordQuartes;
    handles.AccordOpenD = AccordOpenD;
    handles.AccordOpenG = AccordOpenG;
    handles.Accord = AccordE;
    handles.Fs = 4000;
    handles.nBits = 8;
    handles.nChannel = 1;
    handles.length = 0.5;
    handles.L=10000;
    guidata(hObject, handles);
    
    %% Barre de départ et bouton de départ avec l'accord
    accordBar(40,100, '');
    setBoutonsNotes(AccordE, handles);
end
% Effacer l'écran
clc;

% UIWAIT makes accordeur wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = accordeur_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
% Sélection de l'accordage défini par l'utilisateur
switch popup_sel_index
    case 1
        Accord = handles.AccordE;  
    case 2
        Accord = handles.AccordDropD;
    case 3
        Accord = handles.AccordOpenD;
    case 4
        Accord = handles.AccordOpenG;
    case 5
        Accord = handles.AccordQuartes;
end
jouerAccord(Accord);
%Modification des boutons pour les notes
setBoutonsNotes(Accord, handles);
handles.Accord = Accord;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Standard E', 'Drop D', 'Open D', 'Open G', 'Quartes'});

% --- Executes on button press in note1.
function note1_Callback(hObject, eventdata, handles)
activerNote(1, handles);

% --- Executes on button press in note2.
function note2_Callback(hObject, eventdata, handles)
activerNote(2, handles);

% --- Executes on button press in note3.
function note3_Callback(hObject, eventdata, handles)
activerNote(3, handles);

% --- Executes on button press in note4.
function note4_Callback(hObject, eventdata, handles)
activerNote(4, handles);

% --- Executes on button press in note5.
function note5_Callback(hObject, eventdata, handles)
activerNote(5, handles);

% --- Executes on button press in note6.
function note6_Callback(hObject, eventdata, handles)
activerNote(6, handles);

%% Fonctions personnelles
% Fonction d'initialisation des accords de type E ou Open sur base de
% l'octave 3.
function [Accord] = initAccordEOpen(Accord, Octave3)
for i=1:6
    for j=1:12
        x=0;
        if (Octave3{1,j}==Accord{1,i})
            if (i==6)
                x=1;
            elseif (i<=2)
                x=4;
            else
                x=2;
            end;
            Accord{2,i} = Octave3{2,j}/x;
        end;
        
    end;
end;

% Fonction permettant de jouer l'accord en paramètre
function jouerAccord(Accord)
    tsec=0.5;
    a=2;
    F=44100;
    t = linspace(0,tsec,tsec*F);
    y=a*sin(2*pi*Accord{2,1}*t);
    for i=2 :6
        y = [y (a*sin(2*pi*Accord{2,i}*t))];
    end;
    sound(y,F);
    
% Calcul de la couleur de la barre d'accordage qui affiche où on en est par
% rapport à l'accord
function accordBar(frequence,x, note)
if(frequence>=(x+30) || frequence<=(x-30))
    color = [1 0 0]; % Rouge
elseif(frequence>=(x+15) || frequence<=(x-15))
    color = [1 0.5 0]'; % Orange
elseif(frequence>(x+2) || frequence<(x-2))
    color = [1 1 0]'; % Jaune
else 
    color=[0 1 0]; % Vert
end
bar(frequence,'facecolor', color);
xlim([0.6,1.4]);
set(gca,'xtick',[]);
xlabel(note);
ylim([(x-60),(x+60)]);

% Définition des noms des boutons de notes
function setBoutonsNotes(Accord, handles)
set(handles.note1,'string',Accord{1,1});
set(handles.note2,'string',Accord{1,2});
set(handles.note3,'string',Accord{1,3});
set(handles.note4,'string',Accord{1,4});
set(handles.note5,'string',Accord{1,5});
set(handles.note6,'string',Accord{1,6});

% Accordage d'une note en particulier pendant 5 secondes
function accorderNote(position,handles)
clc;
Accord = handles.Accord;
x = Accord{2,position};
% Récupération de variables
Fs = handles.Fs;
nBits = handles.nBits;
nChannel= handles.nChannel;
% Enregistrer le son
soundRecord = audiorecorder(Fs, nBits, nChannel);
record(soundRecord);
pause(0.3);
compte = 1;
% Pendant 5 sec, traiter le son enregistré pour accorder la guitare
while (compte < 50)
    myRecording = getaudiodata(soundRecord);
    myRecording = xcorr(myRecording);
    NFFT = Fs;
    Y = fft(myRecording,NFFT);
    f = (Fs/2*linspace(0,1,NFFT/2+1));
    [valeur, frequence]=max(Y(f>0 & f<(x+50)));
    accordBar(frequence,x, Accord{1,position});
    pause(0.1);
    compte = compte+1;
end

% Fonction pour enable et disable les boutons pendant l'accordage d'une
% note
function boutonOffOn(note, etat, handles)
if (note ~= 1) set(handles.note1,'Enable',etat); end
if (note ~= 2) set(handles.note2,'Enable',etat); end
if (note ~= 3) set(handles.note3,'Enable',etat); end
if (note ~= 4) set(handles.note4,'Enable',etat); end
if (note ~= 5) set(handles.note5,'Enable',etat); end
if (note ~= 6) set(handles.note6,'Enable',etat); end
set(handles.popupmenu1,'Enable',etat);

% Fonctions à exécuter lors de la sélection d'une note
function activerNote(pos, handles)
boutonOffOn(pos, 'off', handles);
accorderNote(pos,handles);
boutonOffOn(pos, 'on', handles);
xlabel('');
