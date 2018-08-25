function varargout = LibFinder(varargin)
% LIBFINDER MATLAB code for LibFinder.fig
%      LIBFINDER, by itself, creates a new LIBFINDER or raises the existing
%      singleton*.
%
%      H = LIBFINDER returns the handle to a new LIBFINDER or the handle to
%      the existing singleton*.
%
%      LIBFINDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIBFINDER.M with the given input arguments.
%
%      LIBFINDER('Property','Value',...) creates a new LIBFINDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LibFinder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LibFinder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LibFinder

% Last Modified by GUIDE v2.5 20-Aug-2018 23:10:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LibFinder_OpeningFcn, ...
                   'gui_OutputFcn',  @LibFinder_OutputFcn, ...
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


% --- Executes just before LibFinder is made visible.
function LibFinder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LibFinder (see VARARGIN)

% Choose default command line output for LibFinder
handles.output = hObject;


handles.size_apk = 10508;
handles.size_lib = 1729;
% we should make the 50 equal to or more than the size of 'Libary.csv'
handles.selectedLibs = zeros(handles.size_lib,1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LibFinder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LibFinder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in LibraryList.
function LibraryList_Callback(hObject, eventdata, handles)
% hObject    handle to LibraryList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LibraryList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LibraryList
    display('--> List: Candidate Library List is Clicked');
    contents = cellstr(get(hObject,'String'));
    display(strcat('LibName --> ',contents{get(hObject,'Value')}));
    display(strcat('Libid   --> ',num2str(get(hObject,'Value'))));
    % this id equal to the ranking in the 'Library.csv'
    handles.SelectingLibId=get(hObject,'Value');
    handles.SelectingLibName=contents{get(hObject,'Value')};
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function LibraryList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LibraryList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    % make the candidate lib list--> listbox 01
    Library = importdata('Library.csv');
    hObject.String = Library;
    KnownID = importdata('KnownID.csv');
    handles.KnownID = KnownID;
    handles.SelectingLibId=0;
    handles.SelectingLibName='';
    handles.Libnames = Library;
    guidata(hObject,handles);


% --- Executes on button press in Button_Add.
function Button_Add_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
    errStr = 'No Problem';
    isOk = 1;
    % check selected libname and libid from candidate lib listbox
    display('--> Button: Add To App');
    % this id equal to the ranking in the 'Library.csv', so can be used
    % directly;
    LibId = handles.SelectingLibId;
    LibName = handles.SelectingLibName;
    display(strcat('Selected Lib Id --> ',num2str(LibId)));
    display(strcat('Selected Lib Name --> ',num2str(LibName)));
    selectedLibs = handles.selectedLibs;

    %check whether the new lib has been selected.
    if LibId==0
        isOk = 0;
        errStr = 'Please Click your invoked library from the left lisbox';
    elseif  selectedLibs(handles.KnownID(LibId)) == 1
        errStr = 'Sorry, this library has been invoked.';
        isOk = 0;    
    else
        %this is a new lib, so add to the selected lib listbox
        % change the listbox
        list_content = handles.LibrarySelect.String;
        new_lib = LibName;
        if isOk && size(list_content,1)==1 && strcmp(list_content,'Select Used Libaries From Left')
            %this is the first lib being selected
            handles.LibrarySelect.String = cellstr(new_lib);
            handles.LibrarySelect.FontAngle = 'normal';
            size(cellstr(new_lib))
        else
            %more than 1 lib has been selected
            Cur_size = size(list_content,1); 
            new_list = cellstr(list_content);
            new_list{Cur_size+1,1}=new_lib;
            handles.LibrarySelect.String = new_list;
            size(new_list)
        end
        selectedLibs(handles.KnownID(LibId)) = 1;
        % Update handles structure
        handles.selectedLibs = selectedLibs;
        guidata(hObject, handles);
        errStr = 'The new library selected has been added.';
    end    
    %change the hints at lower right corner.
    if isOk
        handles.Hint.String=errStr;
        handles.Hint.ForegroundColor=[0,0.5,0];
    else
        handles.Hint.String=errStr;
        handles.Hint.ForegroundColor=[1,0,0];
    end


% --- Executes on button press in Button_Del.
function Button_Del_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%index = contents{get(handles.LibraryList,'Value')};
    display('--> Button: Del From App');
    DelName = handles.DeletingLibName;
    
    % this id is not equal to the ranking in the 'Library.csv'
    % so we employ a linear search to find the real id.
    Libnames = handles.Libnames;
    i=0;
    DelId=0;
    for i=1:size(Libnames,1);
        if strcmp(DelName,Libnames(i))
            DelId=i;            
            break;
        end
    end   
    
    %check if user wants to delete a selected lib
    if DelId==0 %haven't select the lib to be deleted
        handles.Hint.String = 'Please select the library to be deleted from Listbox.';
        handles.Hint.ForegroundColor=[1,0,0];        
    else
        %delete the lib from listbox 02
        selectedLibs = handles.selectedLibs;
        if selectedLibs(handles.KnownID(DelId))==1
            % change the matrix;
            selectedLibs(handles.KnownID(DelId))=0;
            handles.selectedLibs=selectedLibs;
            % change listbox 02 (selected librarys);
            newStr = handles.LibrarySelect.String;  
            size(newStr)
            id =  handles.DeletingLibId
            newStr(id)=[];
            handles.LibrarySelect.String = newStr; 
            % all libs have been removed.     
            size(newStr)
            if size(newStr,2)==0               
                handles.LibrarySelect.String = 'Select Used Libaries From Left';
                handles.LibrarySelect.FontAngle = 'italic';
                % change the Hits
                handles.Hint.String = 'All selected libraries have been removed.';
                handles.Hint.ForegroundColor=[0,0.5,0];
                handles.selectedLibs = zeros(handles.size_lib,1);
            end
            
            % change the Hits
            handles.Hint.String = 'The selected library have been removed.';
            handles.Hint.ForegroundColor=[0,0.5,0];
            guidata(hObject, handles);
        else
            % The library is not exists, change the Hits
            handles.Hint.String = 'The library is not exists.';
            handles.Hint.ForegroundColor=[1,0,0];    
        end
        display(strcat('  |-->Removed Lib Id --> ',num2str(DelId)));
        display(strcat('  |-->Removed Lib Name --> ',num2str(DelName)));
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



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in LibrarySelect.
function LibrarySelect_Callback(hObject, eventdata, handles)
% hObject    handle to LibrarySelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LibrarySelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LibrarySelect
    handles.DeletingLibId=get(hObject,'Value');
    contents = cellstr(get(hObject,'String'));
    handles.DeletingLibName=contents{get(hObject,'Value')};
    guidata(hObject,handles);
    display('ListBox 02 : Select libs to be deleted');
    display(strcat('  |-->Removed Lib Id --> ',num2str(handles.DeletingLibId)));
    display(strcat('  |-->Removed Lib Name --> ',handles.DeletingLibName));
    

% --- Executes during object creation, after setting all properties.
function LibrarySelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LibrarySelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    handles.DeletingLibId=0;
    handles.DeletingLibName='';
    guidata(hObject,handles);


% --- Executes on button press in Button_Rec.
function Button_Rec_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    isOk = 1;
    size_apk = handles.size_apk;
    size_lib = handles.size_lib;
    %?????lib?? handles.selectedLibs?
        
    user_u = zeros(size_lib,1);
    user_u = handles.selectedLibs; %???????lib??user??
    itemU = find(user_u==1);
    if  size(itemU,1)<4 
        %not enough libraries have been selected
        isOk = 0;
        errStr = 'At least 4 libraries are needed.';
    else
        %recommendation        
        topk = 10;
        alpha = handles.alpha;
        tuijian = 10;
        tuijianC = zeros(size_lib,1); %????????;
        tuijianU = zeros(size_lib,1); %????????;
        tuijianI = zeros(size_lib,1); %????????;
        xs = csvread('xs.csv');
        sum_ref_relation = csvread('sum_ref_relation.csv');
        relation = csvread('relation.csv');
        formatSpec ='%C%C%C';
        LibInfo = readtable('LibInfo.csv','Format',formatSpec,'ReadVariableNames',false);
        
        %%%% lib based recommendation  %%%%        
        for i=1:size(itemU,1)
            tuijianI(:,1) = tuijianI(:,1) + xs(:,itemU(i));
        end
        
        %%%%  app based recommendation  %%%%%%
        maxV = zeros(topk,1);
        maxP = zeros(topk,1);
        sortA = zeros(size_apk,1);
        xiabiao = zeros(size_apk,1);
        fenzi = relation*user_u; 
        fenmu = (sum(user_u) + sum_ref_relation)' - fenzi;
        xiangsi = fenzi./fenmu;
        %???A?topk???????????????maxV??????maxP
        [sortA,xiabiao]=sort(xiangsi,'descend' );%??????
        maxV(1:topk,1)=sortA(1:topk,1); %????u?topk???
        maxP(1:topk,1)=xiabiao(1:topk,1);%????u?topk?????
        %???????lib??????
        ref_relation = relation';
        for i=1:topk %topk????                
            tuijianU = tuijianU + ref_relation(:,maxP(i))*maxV(i);
            %????????????
        end
        tuijianC = tuijianI*alpha +  tuijianU*(1-alpha);             
        for i=1:size(itemU,1)
            tuijianC(itemU(i),1) = 0;
        end
        %sort and give the result;
        [Value,Position]=sort(tuijianC,'descend' );
        finalList = Position(1:tuijian);
        %Value(1:tuijian)
        finalList(find(Value(1:tuijian)==0))=[];
        finalList
        %trans to listbox03(table)
        %size(LibInfo)
        NewData = cellstr(table2array(LibInfo(finalList,:)));
        %size(table2array(LibInfo))
        TableData = cell(10,3);
        TableData(:)={''};
        TableData(1:size(finalList,1),1:2) = NewData(1:size(finalList,1),1:2);
        TableData(1:size(finalList,1),3) = {'http://'};
        %display('Final recommendation lib List: id =');
        %display('NewData=');
        %NewData
        %class(NewData)
        %display('TableData=');
        %TableData
        %class(TableData)
        set(handles.FinalResult,'Data',TableData);
        errStr = 'New libraries recommended are listed above.';
    end    
    
    %change the hints at lower right corner.
    if isOk
        handles.Hint.String=errStr;
        handles.Hint.ForegroundColor=[0,0.5,0];
    else
        handles.Hint.String=errStr;
        handles.Hint.ForegroundColor=[1,0,0];
    end




% --- Executes on button press in RemoveAll.
function RemoveAll_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Remove All libraries from Selected lists.
    handles.LibrarySelect.String = 'Select Used Libaries From Left';
    handles.LibrarySelect.FontAngle = 'italic';
    % change the Hits
    handles.Hint.String = 'All selected libraries have been removed.';
    handles.Hint.ForegroundColor=[0,0.5,0];
    handles.selectedLibs = zeros(handles.size_lib,1);
    % Update handles structure
    guidata(hObject, handles);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    cuValue = get(hObject,'Value');
    handles.AlphaV.String = cuValue;
    handles.alpha = cuValue;
    % Update handles structure
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    handles.alpha = 0.6;
    % Update handles structure
    guidata(hObject, handles);



function AlphaV_Callback(hObject, eventdata, handles)
% hObject    handle to AlphaV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AlphaV as text
%        str2double(get(hObject,'String')) returns contents of AlphaV as a double


% --- Executes during object creation, after setting all properties.
function AlphaV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AlphaV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
