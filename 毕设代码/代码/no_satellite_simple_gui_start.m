classdef no_satellite_simple_gui_start < handle
%% *********************************************************************
%
% @file         no_satellite_simple_gui_start.m
% @brief        Class definition for button 2 GUI.
%
% ******************************************************************************
    properties
        % Handle for this GUI.
        gui_p; 
        % GUI handle for the parent GUI.
        gui_m;
        % Width of the screen.
        width;
        % Height of the screen.
        height;
        % Width of the GUI.
        gui_width;
        % Height of the GUI.
        gui_height;
        % Width of the param settings panel.
        panel_width;
        % Height of the param settings panel.
        panel_height;
        
        % Plane number.飞机数量
        plane_num_txt;
        plane_num_edt;
          % Configuration file settings panel.
        config_auto;
        config_txt;
        config_edt;
        config_sct;
        config_con;
        config_man;
        config_path;
    
        
      
        
        % Panel handle of the plane settings panel.飞机1,2,3的panel
        panel_auto_config;
        panel_plane_1;
        panel_plane_2;
        panel_plane_3;
        plane_txt_times;%飞行时间
        plane_edt_times;
        panel_plane_start;
       
        %------自动配置区域的功率
        plane_txt_auto_power;
        plane_edit_auto_power;
        
        % Text handle for plane param, Lattitude, Longtitude, and height.
        plane_txt_lat1,plane_txt_lat2,plane_txt_lat3;
        plane_edt_lat1, plane_edt_lat2, plane_edt_lat3;%维度
        plane_txt_lon1,plane_txt_lon2,plane_txt_lon3;
        plane_edt_lon1, plane_edt_lon2, plane_edt_lon3;%经度
        plane_txt_alt1,plane_txt_alt2,plane_txt_alt3;
        plane_edt_alt1,plane_edt_alt2,plane_edt_alt3;%高度
        % Text handle for plane velocity, and azimuth.
        plane_txt_vh1,plane_txt_vh2,plane_txt_vh3;
        plane_edt_vh1,plane_edt_vh2,plane_edt_vh3;%速度
        plane_txt_az1,plane_txt_az2,plane_txt_az3;
        plane_edt_az1,plane_edt_az2,plane_edt_az3;%航向角
        plane_txt_icao1,plane_txt_icao2,plane_txt_icao3;
        plane_edt_icao1,plane_edt_icao2,plane_edt_icao3;%ICAO
        plane_txt_id1,plane_txt_id2,plane_txt_id3;
        plane_edt_id1,plane_edt_id2,plane_edt_id3;%ICAO
        plane_txt_pw1,plane_txt_pw2,plane_txt_pw3;
        plane_edt_pw1,plane_edt_pw2,plane_edt_pw3;%功率
        plane_txt_hy_speed1,plane_txt_hy_speed2,plane_txt_hy_speed3;
        plane_edt_hy_speed1,plane_edt_hy_speed2,plane_edt_hy_speed3;
        
        
        % Edit text.
        txt_echo;
        edt_echo;
        
        % Button handle 1.
        btn_c1;
        % Button handle 2.
        btn_c2;
        
       
        
     
        % Plane info cell.
        plane_info;
        
        plane_lon_result;
        plane_lat_result;
        plane_high_result;
        plane_lon_path;
        plane_lat_path;
        mess_rec_all;
        
        % Callback function flag.
        cb_auto_config = 0;
        cb_man_config = 0;
        
        % Plane parameter check flag.
        ppc = 0;
        % Receiver parameter check flag.
        rpc = 0;
    end
    
    methods
        % Create figure and init.
        function obj = no_satellite_simple_gui_start()
            screen_size = get(0, 'ScreenSize');
            screen_size(screen_size < 100) = [];
            obj.width  = screen_size(1);
            obj.height = screen_size(2);
            
            % Set the width and height of the GUI.
            obj.gui_width = obj.width-60;
            obj.gui_height = obj.height-100;
            % Set the plane param settings panel widht and height.
            obj.panel_width = obj.gui_width;
            obj.panel_height = obj.gui_height/5;%panel是5行，所以是panel除以5的高度.
            edit_area_width=120;%文本框的宽度固定为100
            txt_area_width_label=130;%label设置为130
            
            
            % The first row info.
            % Create figure and init.
            obj.gui_p = figure('Color', [0.83, 0.82, 0.78], ...
                'Numbertitle', 'off', 'Name', '无卫星简单模式', ...
                'Position', [floor((obj.width - obj.gui_width) / 2), ...
                floor((obj.height - obj.gui_height) / 2), obj.gui_width, ...
                obj.gui_height], 'Toolbar', 'none', 'Resize', 'off');
            
            % Create plane param settings panel.
            obj.panel_auto_config = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '自动配置参数区域', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - obj.panel_height-50 , obj.panel_width-10, ...
                obj.panel_height]);
            % Plane number settings.
            obj.plane_num_txt = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','飞机数量','position',[15 ...
                (obj.panel_height/3 -10) txt_area_width_label 40]);
            obj.plane_num_edt = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[1+txt_area_width_label obj.panel_height/3 ...
              edit_area_width 40]);
          
          
             % Init 报文功率
            obj.plane_txt_auto_power = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','报文功率（dbm）','position',[2+(txt_area_width_label+edit_area_width) ...
                (obj.panel_height/3 -10) txt_area_width_label 40]);
            obj.plane_edit_auto_power = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) obj.panel_height/3 ...
              edit_area_width 40]);
          
          

            % Automatic configure.自动配置飞机参数并仿真
            obj.config_auto = uicontrol('parent', obj.panel_auto_config, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '自动配置飞机参数并运行仿真', ...
                'Fontsize', 12, 'position', [5+(3*txt_area_width_label+2*edit_area_width), obj.panel_height/3, 240, 40]);
            
            
               % Init 仿真时长
            obj.plane_txt_times = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','仿真时长(s)','position',[7+(4*txt_area_width_label+3*edit_area_width) ...
                (obj.panel_height/3 -10) txt_area_width_label 40]);
            obj.plane_edt_times = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[8+(4*txt_area_width_label+4*edit_area_width) obj.panel_height/3 ...
              edit_area_width 40]);
            
            %--------------------panel分隔-------------------------
            
            % Create plane param settings panel.
            obj.panel_plane_1 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '飞机一参数设置区域', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - 2*obj.panel_height, obj.panel_width-10, ...
                obj.panel_height]);
            % panle位置设置
            
        
            % Init the Lattitude text for plane param.
            obj.plane_txt_lat1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','起始纬度','position',[0 obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_lat1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[txt_area_width_label+1 obj.panel_height - 80 ...
              edit_area_width 40]);
             
            % Init the Longtitude text for the plane.
            obj.plane_txt_lon1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','起始经度','position',[2+(txt_area_width_label+edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_lon1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) obj.panel_height - 80 ...
              edit_area_width 40]);
        
            % Init the transmit power of the plane.
            obj.plane_txt_pw1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','功率(dbm)','position',[4+(2*txt_area_width_label+2*edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_pw1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white','Fontsize',11,'position', ...
                [5+(3*txt_area_width_label+2*edit_area_width) obj.panel_height - 80 edit_area_width 40]);
            % Init the height text for the plane.
            obj.plane_txt_alt1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','飞行高度(空层)','position',[6+(3*txt_area_width_label+3*edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_alt1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) obj.panel_height - 80 ...
              edit_area_width 40]);
        
           % 初始化垂直速度
            obj.plane_txt_hy_speed1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','垂直速度(km/h)','position',[8+(4*txt_area_width_label+4*edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_hy_speed1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[9+(5*txt_area_width_label+4*edit_area_width) obj.panel_height - 80 ...
              edit_area_width 40]);
          
            % Init the velocity text for the plane.
            obj.plane_txt_vh1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','飞行速度(km/h)','position',[0 obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_vh1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[1+(txt_area_width_label) obj.panel_height - 130 ...
              edit_area_width 40]);
         
            % Init the azimuth of the plane.
            obj.plane_txt_az1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','航向角(度)','position',[2+(txt_area_width_label+edit_area_width) obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_az1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) obj.panel_height - 130 ...
              edit_area_width 40]);
         
           % 初始化ICAO
            obj.plane_txt_icao1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','ICAO','position',[4+(2*txt_area_width_label+2*edit_area_width) obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_icao1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[5+(3*txt_area_width_label+2*edit_area_width) obj.panel_height - 130 ...
              edit_area_width 40]);
          % 初始化ID
            obj.plane_txt_id1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','ID','position',[6+(3*txt_area_width_label+3*edit_area_width) obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_id1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) obj.panel_height - 130 ...
              edit_area_width 40]);
          
       
          
          % 开始设置第二个飞机的参数
           % Create plane param settings panel.
           obj.panel_plane_2 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '飞机二参数设置区域', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - 3*obj.panel_height, obj.panel_width-10, ...
                obj.panel_height]);
            % panle位置设置
            edit_area_width=120;%文本框的宽度固定为100
            txt_area_width_label=130;%label设置为130
            
            % The first row in the panel.
         
            % Init the Lattitude text for plane param.
            obj.plane_txt_lat2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','起始纬度','position',[0 obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_lat2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[txt_area_width_label+1 obj.panel_height - 80 ...
              edit_area_width 40]);
             
          
          
            % Init the Longtitude text for the plane.
            obj.plane_txt_lon2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','起始经度','position',[2+(txt_area_width_label+edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_lon2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) obj.panel_height - 80 ...
              edit_area_width 40]);
        
 
            % Init the transmit power of the plane.
            obj.plane_txt_pw2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','功率(dbm)','position',[4+(2*txt_area_width_label+2*edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_pw2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white','Fontsize',11,'position', ...
                [5+(3*txt_area_width_label+2*edit_area_width) obj.panel_height - 80 edit_area_width 40]);
            % Init the height text for the plane.
            obj.plane_txt_alt2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','飞行高度(空层)','position',[6+(3*txt_area_width_label+3*edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_alt2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) obj.panel_height - 80 ...
              edit_area_width 40]);
       
        % 初始化垂直速度
            obj.plane_txt_hy_speed2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','垂直速度(km/h)','position',[8+(4*txt_area_width_label+4*edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_hy_speed2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[9+(5*txt_area_width_label+4*edit_area_width) obj.panel_height - 80 ...
              edit_area_width 40]);
            % Init the velocity text for the plane.
            obj.plane_txt_vh2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','飞行速度(km/h)','position',[0 obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_vh2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[1+(txt_area_width_label) obj.panel_height - 130 ...
              edit_area_width 40]);
         
         
            % Init the azimuth of the plane.
            obj.plane_txt_az2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','航向角(度)','position',[2+(txt_area_width_label+edit_area_width) obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_az2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) obj.panel_height - 130 ...
              edit_area_width 40]);
           % 初始化ICAO
            obj.plane_txt_icao2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','ICAO','position',[4+(2*txt_area_width_label+2*edit_area_width) obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_icao2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[5+(3*txt_area_width_label+2*edit_area_width) obj.panel_height - 130 ...
              edit_area_width 40]);
          % 初始化ID
            obj.plane_txt_id2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','ID','position',[6+(3*txt_area_width_label+3*edit_area_width) obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_id2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) obj.panel_height - 130 ...
              edit_area_width 40]);
         
          
          % 第二个飞机参数设置完毕
          
          % 开始设置第三个飞机的参数
           % Create plane param settings panel.
           obj.panel_plane_3 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '飞机三参数设置区域', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - 4*obj.panel_height , obj.panel_width-10, ...
                obj.panel_height]);
            % panle位置设置
     
            
            % The first row in the panel.
         
            % Init the Lattitude text for plane param.
            obj.plane_txt_lat3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','起始纬度','position',[0 obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_lat3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[txt_area_width_label+1 obj.panel_height - 80 ...
              edit_area_width 40]);
             
          
          
            % Init the Longtitude text for the plane.
            obj.plane_txt_lon3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','起始经度','position',[2+(txt_area_width_label+edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_lon3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) obj.panel_height - 80 ...
              edit_area_width 40]);
        
 
            % Init the transmit power of the plane.
            obj.plane_txt_pw3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','功率(dbm)','position',[4+(2*txt_area_width_label+2*edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_pw3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white','Fontsize',11,'position', ...
                [5+(3*txt_area_width_label+2*edit_area_width) obj.panel_height - 80 edit_area_width 40]);
            % Init the height text for the plane.
            obj.plane_txt_alt3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','飞行高度(空层)','position',[6+(3*txt_area_width_label+3*edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_alt3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) obj.panel_height - 80 ...
              edit_area_width 40]);
            % 初始化垂直速度
            obj.plane_txt_hy_speed3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','垂直速度(km/h)','position',[8+(4*txt_area_width_label+4*edit_area_width) obj.panel_height - 90 ...
                txt_area_width_label 40]);
            obj.plane_edt_hy_speed3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[9+(5*txt_area_width_label+4*edit_area_width) obj.panel_height - 80 ...
              edit_area_width 40]);
        
            % Init the velocity text for the plane.
            obj.plane_txt_vh3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','飞行速度(km/h)','position',[0 obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_vh3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[1+(txt_area_width_label) obj.panel_height - 130 ...
              edit_area_width 40]);
         
         
            % Init the azimuth of the plane.
            obj.plane_txt_az3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','航向角(度)','position',[2+(txt_area_width_label+edit_area_width) obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_az3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) obj.panel_height - 130 ...
              edit_area_width 40]);
          % 初始化ICAO
            obj.plane_txt_icao3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','ICAO','position',[4+(2*txt_area_width_label+2*edit_area_width) obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_icao3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[5+(3*txt_area_width_label+2*edit_area_width) obj.panel_height - 130 ...
              edit_area_width 40]);
          % 初始化ID
            obj.plane_txt_id3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','ID','position',[6+(3*txt_area_width_label+3*edit_area_width) obj.panel_height - 140 ...
                txt_area_width_label 40]);
            obj.plane_edt_id3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) obj.panel_height - 130 ...
              edit_area_width 40]);
          
          % 第三个飞机参数设置完毕

          
           % 程序状态区域
           obj.panel_plane_start = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '程序运行区域', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - 5*obj.panel_height , obj.panel_width-10, ...
                obj.panel_height]);
            % panle位置设置
      
             % Create echo info window.
            obj.txt_echo = uicontrol('parent', obj.panel_plane_start, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','程序状态信息','position',[(obj.gui_width-3*obj.gui_width/4 -120) ...
                obj.panel_height - 90 120 40]);
            obj.edt_echo = uicontrol('parent', obj.panel_plane_start, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[obj.gui_width/4 ...
              obj.panel_height - 80 obj.gui_width/2 40]);
            % Create handle for button "Start programme".
            obj.btn_c1 = uicontrol('parent', obj.panel_plane_start, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '开始', ...
                'Fontsize', 15, 'position', [floor((obj.gui_width ) / 3), ...
                obj.panel_height - 130, 150, 40]);
            % Create handle for button "Stop programme"。
            obj.btn_c2 = uicontrol('parent', obj.panel_plane_start, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '退出', ...
                'Fontsize', 15, 'position', [floor((obj.gui_width ) / 3)+250 , ...
                obj.panel_height - 130, 150, 40]);
            
            % Mapping to the callback function.
            callback_mapping(obj);
        end
         
        % Callback function for automatic configuration button.
        function result =button_auto_config_callback(obj, source, eventdata)
             set(obj.edt_echo, 'string', '准备进行仿真...');
           if check_plane_num_times(obj)==0
                return ;
           end
            ftime = str2double(get(obj.plane_edt_times, 'string'));
            fnum = str2double(get(obj.plane_num_edt, 'string'));
            % 接下来需要调用随机方法生成随机的飞机信息矩阵
            set(obj.edt_echo, 'string', '正在进行仿真...');
  
            planes= PlaneDistribute1(fnum);
            set(obj.edt_echo, 'string', '正在进行仿真...');
            % 接下来调用紫童的方法传递参数，进行仿真
            [obj.mess_rec_all,result_lon,result_lat,result_high] =no_satellite_simple_main(planes,ftime);
             obj.plane_lon_result=result_lon;
             obj.plane_lat_result=result_lat;
             obj.plane_high_result=result_high;
            obj.plane_lat_path = 90-obj.plane_lat_result;
            for i = 1:size(obj.plane_lon_result,1)
               if obj.plane_lon_result(i,1)>180
                  obj.plane_lon_path(i,:) = obj.plane_lon_result(i,:)-360;
               else
                 obj.plane_lon_path(i,:) = obj.plane_lon_result(i,:); 
               end
            end
            write_lat_data_2_file(obj.plane_lat_path);
            write_lon_data_2_file(obj.plane_lon_path);
            set(obj.edt_echo, 'string', '仿真结束');
        end
        
        % Callback function for button start.
        function result =button_start_callback(obj, source, eventdata)
             set(obj.edt_echo, 'string', '准备进行仿真...');
             %校验飞行时间参数
              ftime = str2double(get(obj.plane_edt_times, 'string'));
            if is_err_time(ftime)
                set(obj.edt_echo, 'string', '仿真时间必须在[0,60]秒，请重新设置！');
                return
            end
            % 用户输入的飞机一的参数
            lat1=str2double(get(obj.plane_edt_lat1, 'string'));
            lon1=str2double(get(obj.plane_edt_lon1, 'string'));
            high1=str2double(get(obj.plane_edt_alt1, 'string'));
            speed1=str2double(get(obj.plane_edt_vh1, 'string'));
            hxj1=str2double(get(obj.plane_edt_az1, 'string'));
            power1=str2double(get(obj.plane_edt_pw1, 'string'));
             % 用户输入的飞机二的参数
            lat2=str2double(get(obj.plane_edt_lat2, 'string'));
            lon2=str2double(get(obj.plane_edt_lon2, 'string'));
            high2=str2double(get(obj.plane_edt_alt2, 'string'));
            speed2=str2double(get(obj.plane_edt_vh2, 'string'));
            hxj2=str2double(get(obj.plane_edt_az2, 'string'));
            power2=str2double(get(obj.plane_edt_pw2, 'string'));
             % 用户输入的飞机三的参数
            lat3=str2double(get(obj.plane_edt_lat3, 'string'));
            lon3=str2double(get(obj.plane_edt_lon3, 'string'));
            high3=str2double(get(obj.plane_edt_alt3, 'string'));
            speed3=str2double(get(obj.plane_edt_vh3, 'string'));
            hxj3=str2double(get(obj.plane_edt_az3, 'string'));
            power3=str2double(get(obj.plane_edt_pw3, 'string'));

            % 校验飞机1参数
            if check_plane_1(obj,lon1,lat1,high1,speed1,hxj1,power1,'一')==0
                return ;
            end
            if lon1<0
                lon1=lon1+360; 
            end
            lat1=90-lat1;
            hxj1=hxj1*pi/180;
            speed1=speed1/3600;
             plane1 = createPlane(obj,lon1,lat1,high1,speed1,hxj1,power1);
             %飞机2不为空,就需要校验参数，并且把参数合并到飞机1.2中
            if ~plane2isempty(obj)
                if check_plane_1(obj,lon2,lat2,high2,speed2,hxj2,power2,'二')==0
                    return ;
                else
                    if lon2<0
                        lon2=lon2+360; 
                    end
                    lat2=90-lat2;
                    hxj2=hxj2*pi/180;
                    speed2=speed2/3600;
                    plane2 = createPlane(obj,lon2,lat2,high2,speed2,hxj2,power2);
                end
            end
            
            %飞机3不为空,就需要校验参数，并且把参数合并到飞机1.2中
            if ~plane3isempty(obj)
                 if check_plane_1(obj,lon3,lat3,high3,speed3,hxj3,power3,'三')==0
                    return ;
                 else
                    if lon3<0
                        lon3=lon3+360; 
                    end
                    lat3=90-lat3;
                    hxj3=hxj3*pi/180;
                    speed3=speed3/3600;
                    plane3 = createPlane(obj,lon3,lat3,high3,speed3,hxj3,power3);
                end
            end
            
            % 封装为矩阵
            if ~plane2isempty(obj)&&~plane3isempty(obj)
                  planes=[plane1,plane2,plane3];
            elseif ~plane2isempty(obj) && plane3isempty(obj)
                  planes=[plane1,plane2];
            elseif plane2isempty(obj) && ~plane3isempty(obj)
                  planes=[plane1,plane3];
            else
                planes=plane1;
            end
          
            
            set(obj.edt_echo, 'string', '正在运行“多架飞机ADS-B信号模拟程序”...');
            pause(0.3);
           [obj.mess_rec_all,result_lon,result_lat,result_high] =no_satellite_simple_main(planes,ftime);
             obj.plane_lon_result=result_lon;
             obj.plane_lat_result=result_lat;
             obj.plane_high_result=result_high;
             obj.plane_lat_path = 90-obj.plane_lat_result;
            for i = 1:size(obj.plane_lon_result,1)
               if obj.plane_lon_result(i,1)>180
                  obj.plane_lon_path(i,:) = obj.plane_lon_result(i,:)-360;
               else
                 obj.plane_lon_path(i,:) = obj.plane_lon_result(i,:); 
               end
            end
            write_lat_data_2_file(obj.plane_lat_path);
            write_lon_data_2_file(obj.plane_lon_path);
            set(obj.edt_echo, 'string', '“多架飞机ADS-B信号模拟程序”运行完毕！');
        end
        
        % Callback function for exit button.
        function button_exit_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '退出程序...');
            pause(0.3);
            
            close(obj.gui_p);
            clear;
            clc;
        end
        
        % 判断飞机二的参数是不是都为空
         function s= plane2isempty(obj)
             s=1;
             if ~isempty(get(obj.plane_edt_lat2, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_lon2, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_alt2, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_vh2, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_az2, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_pw2, 'string'))
                 s=0;
                 return;
             end
         end
         % 判断飞机三的参数是不是都为空
          function s= plane3isempty(obj)
             s=1;
             if ~isempty(get(obj.plane_edt_lat3, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_lon3, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_alt3, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_vh3, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_az3, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.plane_edt_pw3, 'string'))
                 s=0;
                 return;
             end
         end
        
         % 校验飞机数量和仿真时间
        function s= check_plane_num_times(obj)
            s=0;
            if isempty(get(obj.plane_num_edt, 'string'))
                set(obj.edt_echo, 'string', '尚未设置飞机数量，请先设置飞机数量！');
                return ;
            end
            
            if isempty(get(obj.plane_edt_times, 'string'))
                set(obj.edt_echo, 'string', '尚未设置飞行时间，请先设置飞行时间！');
                return ;
            end
            
            fnum = str2double(get(obj.plane_num_edt, 'string'));
            if isnan(fnum)
                set(obj.edt_echo, 'string', '设置的飞机数量中包含非法字符，应为正整数，请重新设置！');
                return ;
            elseif ~isempty(find(get(obj.plane_num_edt, 'string') == '.', 1))
                set(obj.edt_echo, 'string', '设置的飞机数量为小数，应为正整数，请重新设置！');
                return;
            elseif fnum <= 0 || fnum > 100
                set(obj.edt_echo, 'string', '设置的飞机数量超出范围，应为(0, 100]，请重新设置！');
                return ;
            end
            
            ftime = str2double(get(obj.plane_edt_times, 'string'));
            if isnan(ftime)
                set(obj.edt_echo, 'string', '设置的飞行时间中包含非法字符，应为数值，请重新设置！');
                return ;
            elseif ftime <= 0 || ftime > 60
                set(obj.edt_echo, 'string', '设置的飞行时间超出范围，应为(0, 60]，请重新设置！');
                return ;
            end
            s=1;
            return ;
        end
        
        % 校验飞机的6个参数是否正确
        function s = check_plane_1(obj,lon1,lat1,high1,speed1,hxj1,power1,num)
            s=0;
            str =strcat('设置的飞机',num);
            if is_err_lat(lat1)
                set(obj.edt_echo, 'string', strcat(str,'纬度度超出范围，应为[-90, 90]，请重新设置！'));
                return;
            end
             if is_err_lon(lon1)
                set(obj.edt_echo, 'string', strcat(str,'经度超出范围，应为[-180, 180]，请重新设置！'));
                return;
             end
             if is_err_high(high1)
                set(obj.edt_echo, 'string',  strcat(str,'高度空层超出范围，应为[1, 12]，请重新设置！'));
                return;
             end
             if is_err_speed(speed1)
                set(obj.edt_echo, 'string',  strcat(str,'速度超出范围，应为[800, 1000]，请重新设置！'));
                return;
             end
             if is_err_hxj(hxj1)
                set(obj.edt_echo, 'string',  strcat(str,'航向角超出范围，应为[0, 360]，请重新设置！'));
                return;
             end
             if is_err_gl(power1)
                set(obj.edt_echo, 'string',  strcat(str,'功率超出范围，应为[0, 100]，请重新设置！'));
                return;
             end
            s=1;
        end
        
        %创建飞机信息
        function plane = createPlane(obj,lon,lat,high,speed,hxj,power)
                plane = zeros(6,1);
 
                plane(1,1) = lon;
                plane(2,1) = lat;
                plane(3,1) = (high-1)*0.3+8.4+(rand()*2-1)*0.02;
                plane(4,1) = speed;
                plane(5,1) = hxj;
                plane(6,1) = power;%dnm

        end
        
        function callback_mapping(obj)
          
            set(obj.config_man, 'callback', @obj.button_save_config_callback);
            set(obj.config_auto, 'callback', @obj.button_auto_config_callback);
            set(obj.config_sct, 'callback', @obj.button_config_file_callback);
            set(obj.config_con, 'callback', @obj.button_config_callback);

            set(obj.btn_c1, 'callback', @obj.button_start_callback);
            set(obj.btn_c2, 'callback', @obj.button_exit_callback);
           
        end
        
    end
    
   
end