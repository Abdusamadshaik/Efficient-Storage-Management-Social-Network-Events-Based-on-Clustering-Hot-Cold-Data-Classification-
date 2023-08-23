classdef Image2ImageTool < handle
   %Image2ImageTool converts image files from one format to another.
   %    Image2ImageTool starts a GUI for converting image files.
   %
   %    The GUI allows you to search for image files from a specified directory
   %    and to create a copy of each image using the specified
   %    format. 
   %
   %    Possible input formats (source formats) are
   %    BMP, FIG, GIF, JPG/JPEG, PNG, PPM or TIF/TIFF.     
   %    These input formats can be converted to output formats (target 
   %    formats) which are BMP, EMF, EPS, FIG, GIF, JPG/JPEG, PDF, PNG, 
   %    PPM or TIF/TIFF.
   %
   %    In addition, you have the option to archive files and also to
   %    enhance the quality of a copied image.
   %    If you select the Archive Files option, the program will compress all 
   %    the image files into a gzipped tarfile named ImageFiles_created_(current
   %    date-time) and place the tarfile in the specified directory.
   %    If you select the High Quality option, the program tries to enhance the 
   %    quality and the resolution of the image. In most cases this will lead to 
   %    a much larger file size and the quality enhancement may not be 
   %    clearly visible. Use this option with caution.    
   %    
   %	This program has been inspired by an example in Mark Summerfield's manual 
   %	Advanced Qt Programming: Creating Great Software with C++ and Qt 4.
   %
   %
   %    Author: Mikko Leppänen 23/01/2013
   % 
   %    Version history:
   %      23/01/2013 - first release
    
   
    properties(Access = private)
        currentPath = '';
        hMainWindow;
        hConvertButton;
        hSourceFormatMenu;
        hTargetFormatMenu;
        hListboxView;
        hArchiveCheck;
        hQualityCheck;
        sourceFormats = {};
        targetFormats;
        listboxValues = {};
        fileNames;
        directoryName = tempname;
        numberOfFiles = 0;
        currentState;
    end
    
    events(ListenAccess = private)
        updateUI 
    end

    methods
        function obj = Image2ImageTool % class constructor
            clc;
            try
                createUI(obj)
            catch ME
               errordlg(ME.warning,ME.message) 
            end
        end
    end
    
    methods(Access = private)      
        function createUI(obj)
            screensize = get(0,'ScreenSize');
            obj.hMainWindow = figure('units','pixels',...
                                     'pos',[screensize(1)*2,screensize(2)*25,...
                                           screensize(3)*0.4,screensize(4)*0.4],...
                                     'name','Image2ImageTool',... 
                                     'numbertitle', 'off',... 
                                     'renderer','zbuffer',...
                                     'menubar','none',...
                                     'visible','on',...
                                     'toolbar','none',...
                                     'tag','Image2ImageToolWindow',...
                                     'CreateFcn','movegui(''center'')',...
                                     'DeleteFcn',@(varargin)figDeleteFcn(obj),...
                                     'keypressfcn',@(varargin)figKeyCallback(obj,varargin),...
                                     'color',[0.7137,0.7765,0.7843],...
                                     'resize','off');
            uicontrol('parent',obj.hMainWindow,...
                      'style','text',...
                      'string','Insert Path:',...
                      'units','normalized',...                 
                      'backgroundcolor',get(gcf,'color')',...
                      'pos',[0.05 0.90 0.3 0.075],...
                      'horizontalalignment','left',...
                      'fontname','verdana',...
                      'fontsize',10);
            uicontrol('parent',obj.hMainWindow,...
                      'style','edit',...                
                      'tag','pathField',...
                      'backgroundcolor','white',...
                      'units','normalized',...
                      'pos',[0.05 0.85 0.75 0.075],...
                      'visible','on',...
                      'string',matlabroot,...
                      'tooltipstring','Insert path',...
                      'horizontalalignment','left',...
                      'fontname','verdana',...
                      'fontsize',10);  
            uicontrol('parent',obj.hMainWindow,...
                      'style','push',...
                      'units','normalized',...
                      'userdata',1,...
                      'pos',[0.825 0.85 0.125 0.075],...
                      'backgroundcolor',get(gcf,'color'),...
                      'selectionhighlight','off',...
                      'enable','on',...
                      'tag','browseButton',...
                      'string','Browse...',...
                      'fontname','verdana',...
                      'fontsize',10,...
                      'callback',@(varargin)browseButtonCallback(obj));
            uicontrol('parent',obj.hMainWindow,...
                      'style','text',...
                      'string','Source Type: ',...
                      'units','normalized',...                 
                      'backgroundcolor',get(gcf,'color')',...
                      'pos',[0.05 0.74 0.15 0.075],...
                      'horizontalalignment','left',...
                      'fontname','verdana',...
                      'fontsize',10);
            obj.hSourceFormatMenu = uicontrol('parent',obj.hMainWindow,...
                                              'style','popupmenu',...
                                              'units','normalized',...
                                              'pos',[0.2 0.745 0.1 0.075],...
                                              'enable','on',...
                                              'value',1,...
                                              'string',' ',...
                                              'tag','sourceFormats',...
                                              'backgroundcolor','white',...
                                              'fontname','verdana',...
                                              'fontsize',10);
            uicontrol('parent',obj.hMainWindow,...
                      'style','text',...
                      'string','Target Type: ',...
                      'units','normalized',...                 
                      'backgroundcolor',get(gcf,'color')',...
                      'pos',[0.325 0.74 0.15 0.075],...
                      'horizontalalignment','left',...
                      'fontname','verdana',...
                      'fontsize',10);
            obj.hTargetFormatMenu = uicontrol('parent',obj.hMainWindow,...
                                              'style','popupmenu',...
                                              'units','normalized',...
                                              'pos',[0.475 0.745 0.1 0.075],...
                                              'enable','on',...
                                              'value',1,...
                                              'string',' ',...
                                              'tag','targetFormats',...
                                              'backgroundcolor','white',...
                                              'fontname','verdana',...
                                              'fontsize',10);                   
            obj.hConvertButton = uicontrol('parent',obj.hMainWindow,...
                                           'style','push',...
                                           'units','normalized',...
                                           'userdata',1,...
                                           'pos',[0.65 0.75 0.15 0.075],...
                                           'backgroundcolor',get(gcf,'color'),...
                                           'selectionhighlight','off',...
                                           'enable','on',...
                                           'tag','convertOrCloseButton',...
                                           'string','Convert',...
                                           'fontname','verdana',...
                                           'fontsize',10,...
                                           'callback',@(varargin)convertButtonCallback(obj),...
                                           'keypressfcn',@(varargin)figKeyCallback(obj,varargin));
            uicontrol('parent',obj.hMainWindow,...
                      'style','push',...
                      'units','normalized',...
                      'userdata',1,...
                      'pos',[0.825 0.75 0.125 0.075],...
                      'backgroundcolor',get(gcf,'color'),...
                      'selectionhighlight','off',...
                      'enable','on',...
                      'tag','executebutton',...
                      'string','Quit',...
                      'fontname','verdana',...
                      'fontsize',10,...
                      'callback',@(varargin)quitButtonCallback(obj));
           obj.hArchiveCheck = uicontrol('parent',obj.hMainWindow,...
                                         'style','checkbox',...                
                                         'tag','archiveFiles',...
                                         'backgroundcolor',get(gcf,'color'),...
                                         'units','normalized',...
                                         'pos',[0.05 0.68 0.2 0.075],...
                                         'Min',0,...
                                         'Max',1,...
                                         'visible','on',...
                                         'string','Archive Files',...
                                         'fontname','verdana',...
                                         'fontsize',10);
           obj.hQualityCheck = uicontrol('parent',obj.hMainWindow,...
                                         'style','checkbox',...                
                                         'tag','qualityFiles',...
                                         'backgroundcolor',get(gcf,'color'),...
                                         'units','normalized',...
                                         'pos',[0.275 0.68 0.2 0.075],...
                                         'Min',0,...
                                         'Max',1,...
                                         'visible','on',...
                                         'string','High Quality',...
                                         'fontname','verdana',...
                                         'fontsize',10);                           
           obj.hListboxView = uicontrol('parent',obj.hMainWindow,...
                                        'style','listbox',...
                                        'units','normalized',...
                                        'userdata',1,...
                                        'pos',[0.05 0.05 0.9 0.6],...
                                        'backgroundcolor','white',...
                                        'selectionhighlight','off',...
                                        'string',obj.listboxValues,...
                                        'enable','on',...
                                        'tag','listboxView',...
                                        'fontname','verdana',...
                                        'fontsize',10,...
                                        'value',1);
           setFormats(obj);
           addlistener(obj,'updateUI',@(varargin)UpdateUiEvent(obj,varargin));
        end 
        
        function setFormats(obj)
           obj.sourceFormats = {'BMP','FIG','GIF','JPG|JPEG','PNG','PPM','TIF|TIFF'};
           set(obj.hSourceFormatMenu,'string',obj.sourceFormats);
           obj.targetFormats = obj.sourceFormats;
           obj.targetFormats{end+1} = 'EPS';
           obj.targetFormats{end+1} = 'EMF';
           obj.targetFormats{end+1} = 'PDF';
           obj.targetFormats = sort(obj.targetFormats);
           set(obj.hTargetFormatMenu,'string',obj.targetFormats);       
        end
      
        function [file] = convertFile(obj,filename)
            if exist(fullfile(obj.currentPath,filename),'file')
                    filename = fullfile(obj.currentPath,filename);
                    [~,name,imgExt] = fileparts(filename);
                    imgExt = lower(imgExt(2:end));
            else 
                file = '';
                return
            end
            if ~sum(cell2mat(cellfun(@(x) ~isempty(regexpi(x,...
                    ['(^',imgExt,'$)|(^',...
                    imgExt,')|'])),...
                    obj.sourceFormats,'uni',false)))
                file = '';
                return
            else
                switch imgExt
                    case 'tiff'
                        imgExt = 'tif';
                    case 'jpeg'
                        imgExt = 'jpg';
                end
            end
            sourceExt = obj.sourceFormats{get(obj.hSourceFormatMenu,'value')};
            if numel(sourceExt) > 3
                sourceExt = sourceExt(1:3); 
            end
            targetExt = lower(obj.targetFormats{get(obj.hTargetFormatMenu,'value')});
            if numel(targetExt) > 3
                targetExt = targetExt(1:3); 
            end
            if ~strcmpi(sourceExt,imgExt)
                file = '';
                return
            end
            try 
                file = [name,'.',targetExt];
                file = fullfile(obj.currentPath,file);
                if ismember(file,obj.fileNames)     
                    warndlg(sprintf('File %s already exist...not converting.',file),'File Warning');
                    file = '';
                    return
                end
                if get(obj.hQualityCheck,'value')
                        jpegComp = '-djpeg100';
                        resValue = '-r300';
                        resValueForTiff = '-r600';
                        gifNColors = 256;
                    else
                        jpegComp = '-djpeg';
                        resValue = '';
                        resValueForTiff = '';
                        gifNColors = 64;
                end
                if strcmpi(sourceExt,'fig') && strcmpi(imgExt,'fig')
                    hFig = openfig(filename,'reuse','invisible');
                    set(hFig,'paperpositionmode','auto');
                    switch targetExt
                        case 'bmp'
                            print(hFig,file,'-dbmp','-opengl',resValue);
                        case 'emf'
                            print(hFig,file,'-dmeta',resValue,'-loose');
                        case 'eps'
                            print(hFig,file,'-depsc','-tiff',resValue,'-loose');
                        case 'gif'
                            tmp = tempname;
                            tmp = [tmp,'.png'];
                            print(hFig,tmp,'-dpng','-opengl',resValue);
                            [X,~] = imread(tmp);
                            delete tmp;
                            [Cdata,map] = rgb2ind(X,256);
                            imwrite(Cdata,map,file);
                        case 'jpg'
                            print(hFig,file,jpegComp,'-opengl',resValue);
                        case 'pdf'
                            print(hFig,file,'-dpdf',resValue,'-loose');
                        case 'png'
                            print(hFig,file,'-dpng','-opengl',resValue);
                        case 'ppm'
                            print(hFig,file,'-dppmraw','-opengl',resValue);
                        case 'tif'
                            print(hFig,file,'-dtiff','-opengl',resValueForTiff);
                    end
                    return
                %process vectors 
                elseif ismember(targetExt,{'eps','pdf','emf'}) &&... 
                       ~strcmpi(imgExt,'fig')
                   [X,~] = imread(filename);
                   imageH = size(X,1);
                   imageW = size(X,2);
                   hFig = figure('visible','off');
                   image(X);
                   axis off;
                   set(get(hFig,'CurrentAxes'),'units','normalized','pos',[0 0 1 1]);
                   set(hFig,'paperpositionmode','auto',...
                           'units','pixels','pos',[1 1 imageW imageH],...
                           'papersize',[imageW imageH]); 
                   switch targetExt
                       case 'eps'
                            print(hFig,file,'-depsc','-tiff',resValue,'-loose');
                       case 'pdf'
                            print(hFig,file,'-dpdf',resValue,'-loose');
                       case 'emf'
                            print(hFig,file,'-dmeta',resValue,'-loose');
                   end
                   return
                elseif strcmpi(targetExt,'gif') && ~strcmpi(imgExt,'fig')
                    [X,~] = imread(filename);
                    [Cdata,map] = rgb2ind(X,gifNColors);
                    imwrite(Cdata,map,file);
                    return
                else
                    if ~strcmpi(imgExt,'fig')
                        [X, map] = imread(filename);
                        if get(obj.hQualityCheck,'value')
                            jpegOpts = {'quality',100};
                            pngOpts = {'InterlaceType','adam7'};
                            tifOpts = {'resolution',[300,300],'compression','none'};
                        else
                            pngOpts = {};
                            jpegOpts = {};
                            tifOpts = {};
                        end
                        if (isempty(map))
                            switch targetExt
                                case 'bmp'
                                    imwrite(X,file);
                                case 'fig'
                                    imageH = size(X,1);
                                    imageW = size(X,2);
                                    hFig = figure('visible','off');
                                    image(X);
                                    axis off;
                                    set(get(hFig,'CurrentAxes'),'units','normalized','pos',[0 0 1 1]);
                                    set(hFig,'paperpositionmode','auto',...
                                           'units','pixels','pos',[1 1 imageW imageH],...
                                           'papersize',[imageW imageH]);
                                    saveas(hFig,file);   
                                case 'jpg'
                                    imwrite(X,file,jpegOpts{:});
                                case 'png'
                                    imwrite(X,file,pngOpts{:});
                                case 'ppm'
                                    imwrite(X,file);
                                case 'tif'
                                    imwrite(X,file,tifOpts{:});
                            end
                        else
                            switch targetExt
                                case 'bmp'
                                    imwrite(X,map,file);
                                case 'fig'
                                    imageH = size(X,1);
                                    imageW = size(X,2);
                                    hFig = figure('visible','off');
                                    image(X);
                                    axis off;
                                    set(get(hFig,'CurrentAxes'),'units','normalized','pos',[0 0 1 1]);
                                    set(hFig,'paperpositionmode','auto',...
                                           'units','pixels','pos',[1 1 imageW imageH],...
                                           'papersize',[imageW imageH]);
                                    saveas(hFig,file);
                                case 'jpg'
                                    imwrite(X,map,file,jpegOpts{:});
                                case 'png'
                                    imwrite(X,map,file,pngOpts{:});
                                case 'ppm'
                                    imwrite(X,map,file);
                                case 'tif'
                                    iimwrite(X,map,file,tifOpts{:});
                            end
                        end
                    end
                end
            catch ME
                file = containers.Map(file,false);
                warndlg(ME.message,ME.identifier);
                return
            end
        end
        function UpdateUiEvent(obj,varargin)
            if isConverting(obj.currentState)
                set(obj.hConvertButton,'string','Converting...')
            else
                set(obj.hConvertButton,'string','Convert')
            end
        end

        %------------------------------------------------------------------
        % Callback functions
        %------------------------------------------------------------------
        function browseButtonCallback(obj)
            if isempty(obj.currentPath)
                foldername = uigetdir();
            else
                foldername = uigetdir(obj.currentPath);
            end
            if isempty(foldername) || isequal(foldername,0)
                return
            end
            set(findobj('tag','pathField'),'string',foldername);
            obj.currentPath = foldername;
        end
        
        function figDeleteFcn(obj)
            if exist(obj.directoryName,'dir')
                rmdir(obj.directoryName,'s');
            end
            if isvalid(obj) && isobject(obj)
                delete(obj)
            end
        end
      
        function convertButtonCallback(obj)
            if strcmpi(obj.sourceFormats{get(obj.hSourceFormatMenu,'value')},...
                    obj.targetFormats{get(obj.hTargetFormatMenu,'value')})
                choise = questdlg(sprintf(['Image2ImageTool::Quest: Source and Target types are same.\n',...
                                      'Do you want to proceed?'],...
                                      obj.directoryName),'Format Types Warning',...
                                      'Yes','No','Yes');
                switch choise
                    case 'Yes'

                    case 'No'
                        obj.currentState = CurrentState.Stop;
                        return
                end                  
            end
            if ~strcmp(get(findobj('tag','pathField'),'string'),obj.currentPath)
                obj.currentPath = get(findobj('tag','pathField'),'string');
            end 
            directory = dir(obj.currentPath);
            if get(obj.hArchiveCheck,'value')
               [status,message,messageid] = mkdir(obj.directoryName);
                if ~status
                    fprintf(2,'%s\n%s',message,messageid);    
                    warndlg(sprintf('Image2ImageTool::Warning: unable to create directory %s',...
                            obj.directoryName),'File Warning');
                end
                if strcmp(messageid,'MATLAB:MKDIR:DirectoryExists')  
                    choise = questdlg(sprintf(['Image2ImageTool::Quest: directory %s already exist.\n',...
                                      'Do you want to remove it?'],...
                                      obj.directoryName),'DirectoryExists',...
                                      'Yes','No','Yes');
                    switch choise
                        case 'Yes'
                            rmdir(obj.directoryName,'s');
                            obj.directoryName = tempname;
                            mkdir(obj.directoryName);
                        case 'No'
                            return
                    end
                end
            end
            if ~isempty(directory)
                files = {};
                errorLog = {};
                obj.fileNames = {directory(~[directory.isdir]).name};
                obj.currentState = CurrentState.Converting;
                set(obj.hListboxView,'string',files,'value',1);
                notify(obj,'updateUI');
                uiwait(obj.hMainWindow,1);
                for k = 1:numel(obj.fileNames)
                   file = convertFile(obj,obj.fileNames{k});
                   if isempty(file)
                       continue
                   elseif isobject(file)
                       errorLog{end+1} = file.keys;
					   continue
                   else 
                       files{end+1} = sprintf('Saved: %s',file);
                       set(obj.hListboxView,'string',files,'value',numel(files));
                       obj.numberOfFiles = obj.numberOfFiles + 1;
                       if isdir(obj.directoryName)
                           [status,message,messageId] = movefile(file,...
                                                        obj.directoryName,'f');
                            if ~status  
                                fprintf(2,'Image2ImageTool::Error: while moving file %s to folder %s \n',...
                                      file,obj.directoryName);
                                fprintf(2,'%s\n%s',message,messageId);
                            end
                       end
                   end
                end  
                files{end+1} = sprintf('%d file(s) saved.',obj.numberOfFiles);
                set(obj.hListboxView,'value',numel(files));
                files{end+1} = sprintf('%s',repmat('-',1,20));
                if isempty(errorLog)
                    files{end+1} = sprintf('No errors found.');
                else 
                    for k = 1:numel(errorLog)
                        files{end+1} = sprintf('Error found in file %s\n while writing.',errorLog{k}{1});
                    end
                end
                set(obj.hListboxView,'string',files);
                obj.currentState = CurrentState.Stop;
                notify(obj,'updateUI');
                uiwait(obj.hMainWindow,1);
                if isdir(obj.directoryName)
                    if obj.numberOfFiles > 0
                        tar(fullfile(obj.currentPath,['ImageFiles_created_',datestr(now,'dd-mmm-yyyy_HHMMSS'),'.tgz']),'.',obj.directoryName);
                    end
                    rmdir(obj.directoryName,'s');
                end
                obj.numberOfFiles = 0;
            else
                errordlg(sprintf('Directory %s is not valid.',obj.currentPath),'Directory Error');
            end
        end
       
        function figKeyCallback(obj,varargin)
            if isConverting(obj.currentState)
                return
            end
            key = varargin{1}(2);
            if strcmp(key{1}.Key,'return')
                convertButtonCallback(obj)
            end
        end
        
        function quitButtonCallback(obj)
            if exist(obj.directoryName,'dir')
                rmdir(obj.directoryName,'s');
            end
            delete(gcbf)
        end
    end

end








