classdef satellite_goss_gui_start < handle
%% *********************************************************************
%
% @file         satellite_goss_gui_start.m
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
        set_wx_param_btn;
        goss_range;
        gaosi_gl_range_edt1;
        gaosi_gl_range_edt2;
      
        
        % Panel handle of the plane settings panel.飞机1,2,3的panel
        panel_plane_1;
        panel_plane_2;
        panel_plane_3;
        plane_txt_times;%飞行时间
        plane_edt_times;
        panel_plane_start;
       
        
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
        
        
        plane_txt_pw1,plane_txt_pw2,plane_txt_pw3;
        plane_edt_pw1,plane_edt_pw2,plane_edt_pw3;%功率

        
        
        % Edit text.
        txt_echo;
        edt_echo;
        
        % Button handle 1.
        btn_c1;
        % Button handle 2.
        btn_c2;
        
        btn_export_icao;
        edt_export_icao;
        
     
        % Plane info cell.
        plane_info;
        
        plane_lon_result;
        plane_lat_result;
        plane_high_result;
        
        plane_lon_path;
        plane_lat_path;
        mess_rec_all;
        mess_rec_all1;
        mess_rec_all2;
        time_asix_mess;
         mess_112_hex;
        
        % Callback function flag.
        cb_auto_config = 0;
        cb_man_config = 0;
        
        % 卫星panel
        wx_panel_erea;
        wx_gaosi_erea1;
        wx_gaosi_erea2;
        wx_gaosi_erea2_sub1;
        wx_gaosi_erea2_sub2;
        planes_id_result;
        
        %卫星panel各个字段的label定义和文本框定义
         wx_lat_txt;
        wx_lon_txt;
        wx_high_txt;
        wx_tx_power_txt;%天线功率
        wx_hxj_txt;
        wx_speed_txt;
        wx_tx_num_txt;%天线数量
        wx_txbs_width_txt;%天线波束宽度
        %下面是文本框的定义
        wx_lat_edit;
        wx_lon_edit;
        wx_high_edit;
        wx_tx_power_edit;%天线功率
        wx_hxj_edit;
        wx_speed_edit;
        wx_tx_num_edit;%天线数量
        wx_txbs_width_edit;%天线波束宽度
        %高斯分布经纬度设置
        gaosi_center_lat_txt_1;
        gaosi_center_lat_edit_1;
        gaosi_center_lon_txt_1;
        gaosi_center_lon_edit_1;
        gaosi_plane_num_txt_1
        gaosi_plane_num_edit_1;
        
        gaosi_center_lat_txt_2;
        gaosi_center_lat_edit_2;
        gaosi_center_lon_txt_2;
        gaosi_center_lon_edit_2;
        gaosi_plane_num_txt_2;
        gaosi_plane_num_edit_2;
        goss_range_tooltip1;
        goss_range_tooltip2;
        get_goss_lat_range_btn1;
        get_goss_lat_range_btn2;
        
        minimal_rec_power;
    end
    
    methods
        % 有卫星并且使用高斯分布的场景
        function obj = satellite_goss_gui_start(gui_m)
            
            %高斯分布范围分别是开始经度，结束经度，开始纬度1，结束纬度1,开始纬度2，结束纬度2
            obj.goss_range=[-1000,-1000,-1000,-1000,-1000,-1000];
            
            obj.gui_m=gui_m;
            screen_size = get(0, 'ScreenSize');
            screen_size(screen_size < 100) = [];
            obj.width  = screen_size(1);
            obj.height = screen_size(2);
            
            % Set the width and height of the GUI.
            obj.gui_width = obj.width-60;
            obj.gui_height = obj.height - 100;
            % Set the plane param settings panel widht and height.
            obj.panel_width = obj.gui_width;
            obj.panel_height = obj.gui_height/5;%panel是5行，所以是panel除以5的高度.

             % panle位置设置
            edit_area_width=80;%文本框的宽度固定为100
            txt_area_width_label=120;%label设置为130
            
            % The first row info.
            % Create figure and init.
            obj.gui_p = figure('Color', [0.83, 0.82, 0.78], ...
                'Numbertitle', 'off', 'Name', '有卫星使用高斯分布场景仿真程序', ...
                'Position', [floor((obj.width - obj.gui_width) / 2), ...
                floor((obj.height - obj.gui_height) / 2), obj.gui_width, ...
                obj.gui_height], 'Toolbar', 'none', 'Resize', 'off');
            
               % 卫星参数设置
            obj.wx_panel_erea = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '卫星参数设置区域', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - 130 , obj.panel_width-10, ...
                130]);
           
            % Init the Longtitude text for the plane.
            obj.wx_lon_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','起始经度','position',[0 50 ...
                txt_area_width_label 40]);
            obj.wx_lon_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[(txt_area_width_label+1) 60 ...
              edit_area_width 40]);
            set(obj.wx_lon_edit, 'string', '115');
            obj.wx_lat_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','起始纬度','position',[2+(txt_area_width_label+edit_area_width) 50 ...
                txt_area_width_label 40]);
            obj.wx_lat_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) 60 ...
              edit_area_width 40]);
             set(obj.wx_lat_edit, 'string', '29');
            % Init the transmit power of the plane.
            obj.wx_tx_power_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','最大天线增益(dbm)','position',[4+(2*txt_area_width_label+2*edit_area_width) 50 ...
                txt_area_width_label 40]);
            obj.wx_tx_power_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white','Fontsize',11,'position', ...
                [5+(3*txt_area_width_label+2*edit_area_width) 60 edit_area_width 40]);
            set(obj.wx_tx_power_edit, 'string', '10');
            % Init the height text for the plane.
            obj.wx_high_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','卫星高度(km)','position',[6+(3*txt_area_width_label+3*edit_area_width) 50 ...
                txt_area_width_label 40]);
            obj.wx_high_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) 60 ...
              edit_area_width 40]);
           set(obj.wx_high_edit, 'string', '700');
            % Init the velocity text for the plane.
            obj.wx_speed_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','卫星速度(km/s)','position',[8+(4*txt_area_width_label+4*edit_area_width) 50 ...
                txt_area_width_label 40]);
            obj.wx_speed_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[9+(5*txt_area_width_label+4*edit_area_width) 60 ...
              edit_area_width 40]);
             set(obj.wx_speed_edit, 'string', '7.9');
            % Init the azimuth of the plane.
            obj.wx_hxj_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','卫星航向角(度)','position',[0 0 ...
                txt_area_width_label 40]);
            obj.wx_hxj_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[1+(txt_area_width_label) 10 ...
              edit_area_width 40]);
          set(obj.wx_hxj_edit, 'string', '60');
           % Init the azimuth of the plane.
            obj.wx_tx_num_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','天线数量','position',[2+(txt_area_width_label+edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.wx_tx_num_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) 10 ...
              edit_area_width 40]);
           set(obj.wx_tx_num_edit, 'string', '2');
           % Init the azimuth of the plane.
            obj.wx_txbs_width_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','天线波束宽度','position',[4+(2*txt_area_width_label+2*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.wx_txbs_width_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[5+(3*txt_area_width_label+2*edit_area_width) 10 ...
              edit_area_width 40]);
            set(obj.wx_txbs_width_edit, 'string', '10');
                % Init 仿真时长
            obj.plane_txt_times = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','仿真时长(s)','position',[6+(3*txt_area_width_label+3*edit_area_width) ...
                0 txt_area_width_label 40]);
            obj.plane_edt_times = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width)  10 ...
              edit_area_width 40]);
            set(obj.plane_edt_times, 'string', '10');
             uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','最小接收功率','position',[8+(4*txt_area_width_label+4*edit_area_width) ...
                0 txt_area_width_label 40]);
            obj.minimal_rec_power = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[9+(5*txt_area_width_label+4*edit_area_width)  10 ...
              edit_area_width 40]);
            set(obj.minimal_rec_power, 'string', '-115');
            
                 % 设置卫星参数button 
            obj.set_wx_param_btn = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'pushbutton', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','设置卫星参数','position',[10+(5*txt_area_width_label+5*edit_area_width)+txt_area_width_label/2 ...
                10 txt_area_width_label 40]);
                 
          
              % 随机分布区域
            obj.wx_gaosi_erea1 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '随机分布参数设置区域', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height-2*obj.panel_height+30 , obj.panel_width-10, ...
                obj.panel_height-10]);
            
            % 飞机数量
            obj.plane_num_txt = uicontrol('parent', obj.wx_gaosi_erea1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','随机分布飞机数量','position',[15 (obj.panel_height/3) 130 40]);
            obj.plane_num_edt = uicontrol('parent', obj.wx_gaosi_erea1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[150 (obj.panel_height/3+10) 80 40]);
             set(obj.plane_num_edt, 'string', '10');%默认设置10个随机分布的飞机
              % 高斯分布区域
            obj.wx_gaosi_erea2 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '高斯分布参数设置区域', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - 4*obj.panel_height , obj.panel_width-10, ...
                2*obj.panel_height+20]);
            
            obj.wx_gaosi_erea2_sub1 = uipanel('parent', obj.wx_gaosi_erea2, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '高斯分布参数设置区域一', 'Fontsize', 12, 'Position', [25, ...
                obj.panel_height , obj.panel_width-30, ...
                obj.panel_height-10]);
            
            obj.wx_gaosi_erea2_sub2 = uipanel('parent', obj.wx_gaosi_erea2, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '高斯分布参数设置区域二', 'Fontsize', 12, 'Position', [25, ...
                0, obj.panel_width-30, ...
                obj.panel_height-10]);
            %以下6个是高斯分布参数区域一的文本框
              obj.gaosi_center_lon_txt_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','经度','position',[0 0 100 40]);
            obj.gaosi_center_lon_edit_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[81 (10) ...
              80 40]);
            set(obj.gaosi_center_lon_edit_1,'Enable','off');
            
             % 获取纬度范围button1
            obj.get_goss_lat_range_btn1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'pushbutton', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','获取纬度范围','position',[181 ...
                (10) txt_area_width_label+40 40]);
            
            obj.gaosi_center_lat_txt_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','纬度','position',[280+80 (0) 80 40]);
            obj.gaosi_center_lat_edit_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[381+80 (10) ...
              80 40]);
           set(obj.gaosi_center_lat_edit_1,'Enable','off');
           obj.gaosi_plane_num_txt_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','飞机数量','position',[470+80 (0) 100 40]);
            obj.gaosi_plane_num_edit_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[571+80 (10) ...
              80 40]);
            uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','高斯覆盖半径(km)','position',[660+80 (0) 180 40]);
            obj.gaosi_gl_range_edt1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[660+161+80 (10) ...
              80 40]);
            
          %以下6个是高斯分布参数区域二的文本框
            obj.gaosi_center_lon_txt_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','经度','position',[0 (0) 100 40]);
            obj.gaosi_center_lon_edit_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[81 (10) ...
              80 40]);
            set(obj.gaosi_center_lon_edit_2,'Enable','off');
             % 获取纬度范围button1
            obj.get_goss_lat_range_btn2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'pushbutton', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','获取纬度范围','position',[181 ...
                (10) txt_area_width_label+40 40]);
            obj.gaosi_center_lat_txt_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','纬度','position',[280+80 (0) 80 40]);
            obj.gaosi_center_lat_edit_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[381+80 (10) ...
              80 40]);
           set(obj.gaosi_center_lat_edit_2,'Enable','off');
           
           obj.gaosi_plane_num_txt_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','飞机数量','position',[470+80 (0) 100 40]);
            obj.gaosi_plane_num_edit_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[571+80 (10) ...
              80 40]);
            uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','高斯覆盖半径(km)','position',[660+80 (0) 180 40]);
            obj.gaosi_gl_range_edt2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[660+161+80 (10) ...
              80 40]);
          
        
 
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
          
           %导出ICAO
            obj.edt_export_icao = uicontrol('parent', obj.panel_plane_start, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[floor((obj.gui_width ) / 4) 0 ...
              edit_area_width 40]);
            
            obj.btn_export_icao = uicontrol('parent', obj.panel_plane_start, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '获取ICAO数据', ...
                'Fontsize', 11, 'position', [floor((obj.gui_width ) / 4)+edit_area_width, ...
                0, 150, 40]);
            % Create handle for button "Start programme".
            obj.btn_c1 = uicontrol('parent', obj.panel_plane_start, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '开始', ...
                'Fontsize', 15, 'position', [floor((obj.gui_width ) / 4)+edit_area_width+150, ...
                0, 150, 40]);
            % Create handle for button "Stop programme"。
            obj.btn_c2 = uicontrol('parent', obj.panel_plane_start, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '退出', ...
                'Fontsize', 15, 'position', [floor((obj.gui_width ) / 4)+edit_area_width+350 , ...
                0, 150, 40]);
          uicontrol('parent', obj.panel_plane_start, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '下载', ...
                'Fontsize', 15, 'position', [floor((obj.gui_width ) / 4)+edit_area_width+530 , ...
                0, 150, 40]);
            % Mapping to the callback function.
            callback_mapping(obj);
        end
        
     
      
        
        % 设置卫星参数的回调函数
        function set_wx_param_btn_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '准备计算...');
            %校验卫星的8个参数
            if check_wx_param(obj)==0
                 return;
            end
            %校验仿真时长 
            ftime = str2double(get(obj.plane_edt_times, 'string'));
            if isnan(ftime)
                set(obj.edt_echo, 'string', '设置的仿真时长中包含非法字符，应为数值，请重新设置！');
                return ;
            elseif ftime <= 0 || ftime > 60
                set(obj.edt_echo, 'string', '设置的仿真时长超出范围，应为(0, 60]，请重新设置！');
                return ;
            end

            %卫星参数获取
            wx_lat = str2double(get(obj.wx_lat_edit, 'string'));
            wx_lat=90-wx_lat;%转为0-180
            wx_lon = str2double(get(obj.wx_lon_edit, 'string'));
            if wx_lon<0
                wx_lon=wx_lon+360;%转为0-360
            end
            high = str2double(get(obj.wx_high_edit, 'string'));

            % 接下来需要调用随机方法生成随机的飞机信息矩阵
            set(obj.edt_echo, 'string', '正在获取高斯分布经纬度范围...');
            [lon_down,lon_up]= goss_lon_range(wx_lon,wx_lat,high); %这一步要调用紫童的方法来生成
            set(obj.edt_echo, 'string', '获取经纬度范围结束');
            %高斯分布经度范围获取成功，才允许输入经度框
            set(obj.gaosi_center_lon_edit_1,'Enable','on');
            set(obj.gaosi_center_lon_edit_2,'Enable','on');
            setwx_param_inactive(obj);%设置卫星参数不可编辑
            set_goss_lon_range_tooltip(obj,lon_down,lon_up);%设置经度范围提示
            obj.goss_range(1,1)=lon_down;
            obj.goss_range(1,2)=lon_up;
            set(obj.edt_echo, 'string', '已经获取到高斯分布经度范围。');
        end
        
         % 设置高斯经度范围按钮1的回调函数
        function set_goss_lon_btn1_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '准备计算纬度范围...');
            %校验卫星的8个参数
            if check_wx_param(obj)==0
                 return;
            end
            %卫星参数获取
            wx_lat = str2double(get(obj.wx_lat_edit, 'string'));
            wx_lat=90-wx_lat;%转为0-180
            wx_lon = str2double(get(obj.wx_lon_edit, 'string'));
            if wx_lon<0
                wx_lon=wx_lon+360;%转为0-360
            end
            high = str2double(get(obj.wx_high_edit, 'string'));

            % 接下来需要调用随机方法生成随机的飞机信息矩阵
            set(obj.edt_echo, 'string', '正在获取高斯分布纬度范围...');
            lon = str2double(get(obj.gaosi_center_lon_edit_1, 'string'));%用户输入的经度
            if isnan(lon)
                set(obj.edt_echo, 'string', '请输入数字！');
                return;
            end
            if obj.goss_range(1,1)<obj.goss_range(1,2)%开始经度小于结束经度
                if lon>obj.goss_range(1,2)||lon<obj.goss_range(1,1)%大于大的小于小的就是错误的经度
                    set(obj.edt_echo, 'string', '你输入的经度不在范围内,请重新输入！');
                    return;
                end
            else
                if (lon>obj.goss_range(1,1)&&lon<=180)||(lon<obj.goss_range(1,2)&&lon>=-180)
                    % 正确的经度
                else
                    % 错误的经度
                    set(obj.edt_echo, 'string', '你输入的经度不在范围内,请重新输入！');
                    return;
                end
            end

            [lat_down,lat_up]=  goss_lat_range(wx_lon,wx_lat,high,obj.goss_range(1,1),obj.goss_range(1,2),lon); %这一步要调用紫童的方法来生成
            set(obj.edt_echo, 'string', '获取纬度范围成功');
            %高斯分布经度范围获取成功，才允许输入经度框
            set_goss_lat_range_tooltip(obj,obj.goss_range_tooltip1,obj.gaosi_center_lat_edit_1,lat_down,lat_up);
            set(obj.gaosi_center_lon_edit_1,'Enable','off');
            obj.goss_range(1,3)=lat_down;
            obj.goss_range(1,4)=lat_up;
            set(obj.edt_echo, 'string', '已经获取到高斯分布1纬度度范围。');
        end
        
        function set_goss_lon_btn2_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '准备计算纬度范围...');
            %校验卫星的8个参数
            if check_wx_param(obj)==0
                 return;
            end
            %卫星参数获取
            wx_lat = str2double(get(obj.wx_lat_edit, 'string'));
            wx_lat=90-wx_lat;%转为0-180
            wx_lon = str2double(get(obj.wx_lon_edit, 'string'));
            if wx_lon<0
                wx_lon=wx_lon+360;%转为0-360
            end
            high = str2double(get(obj.wx_high_edit, 'string'));

            % 接下来需要调用随机方法生成随机的飞机信息矩阵
            set(obj.edt_echo, 'string', '正在获取高斯分布纬度范围...');
            lon = str2double(get(obj.gaosi_center_lon_edit_2, 'string'));%用户输入的经度
            if isnan(lon)
                set(obj.edt_echo, 'string', '请输入数字！');
                return;
            end
            if obj.goss_range(1,1)<obj.goss_range(1,2)%开始经度小于结束经度
                if lon>obj.goss_range(1,2)||lon<obj.goss_range(1,1)%大于大的小于小的就是错误的经度
                    set(obj.edt_echo, 'string', '你输入的经度不在范围内,请重新输入！');
                    return;
                end
            else
                if (lon>obj.goss_range(1,1)&&lon<=180)||(lon<obj.goss_range(1,2)&&lon>=-180)
                    % 正确的经度
                else
                    % 错误的经度
                    set(obj.edt_echo, 'string', '你输入的经度不在范围内,请重新输入！');
                    return;
                end
            end

            [lat_down,lat_up]=  goss_lat_range(wx_lon,wx_lat,high,obj.goss_range(1,1),obj.goss_range(1,2),lon); %这一步要调用紫童的方法来生成
            set(obj.edt_echo, 'string', '获取纬度范围成功');
            %高斯分布经度范围获取成功，才允许输入经度框
            set_goss_lat_range_tooltip(obj,obj.goss_range_tooltip2,obj.gaosi_center_lat_edit_2,lat_down,lat_up);
            set(obj.gaosi_center_lon_edit_2,'Enable','off');
            obj.goss_range(1,5)=lat_down;
            obj.goss_range(1,6)=lat_up;
            set(obj.edt_echo, 'string', '已经获取到高斯分布2纬度度范围。');
        end
        
        function setwx_param_inactive(obj)
            set(obj.wx_lat_edit,'Enable','off');
            set(obj.wx_lon_edit,'Enable','off');
            set(obj.wx_high_edit,'Enable','off');
            set(obj.wx_tx_power_edit,'Enable','off');
            set(obj.wx_hxj_edit,'Enable','off');
            set(obj.wx_speed_edit,'Enable','off');
            set(obj.wx_tx_num_edit,'Enable','off');
            set(obj.wx_txbs_width_edit,'Enable','off');
            set(obj.plane_edt_times,'Enable','off');
        end
        
        function set_goss_lon_range_tooltip(obj,lon_down,lon_up)
            obj.goss_range_tooltip1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[0 ...
              (10 +40) obj.gui_width/2 40]);
          temp = strcat('高斯分布经度范围，应为[',num2str(lon_down),',');
          temp =strcat(temp,num2str(lon_up));
          temp = strcat(temp,']。');
          set(obj.goss_range_tooltip1,'string',temp);
            set(obj.goss_range_tooltip1,'Enable','off');
            obj.goss_range_tooltip2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[0 ...
              (10+40) obj.gui_width/2 40]);
            set(obj.goss_range_tooltip2,'string',temp);
            set(obj.goss_range_tooltip2,'Enable','off');
        end
        
         function set_goss_lat_range_tooltip(obj,latecho,lat_input,lat_down,lat_up)
            temp = strcat('高斯分布纬度度范围，应为[',num2str(lat_down),',',num2str(lat_up),'].');
            set(latecho,'string',temp);
            set(lat_input,'Enable','on');
        end
        
        % Callback function for button start.
        function button_start_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '正在校验参数...');
            pause(0.2);
            if (obj.goss_range(1,1)==-1000||obj.goss_range(1,2)==-1000||obj.goss_range(1,3)==-1000||obj.goss_range(1,4)==-1000)
                set(obj.edt_echo, 'string', '请先设置卫星参数获取高斯分布范围！');
                return;
            end
            %校验飞机随机数量和仿真时长 
            if check_plane_num_times(obj)==0
                return ;
            end
            
            fnum = str2double(get(obj.plane_num_edt, 'string'));%随机均匀分布的飞机个数
            ftime = str2double(get(obj.plane_edt_times, 'string'));%仿真时长
            %卫星参数获取
            wx_lat = str2double(get(obj.wx_lat_edit, 'string'));
            wx_lat=90-wx_lat;%转为0-180
            wx_lon = str2double(get(obj.wx_lon_edit, 'string'));
            if wx_lon<0
                wx_lon=wx_lon+360;%转为0-360
            end
            high1 = str2double(get(obj.wx_high_edit, 'string'));
            power1 = str2double(get(obj.wx_tx_power_edit, 'string'));
            hxj1 = str2double(get(obj.wx_hxj_edit, 'string'));
            hxj1=hxj1*pi/180;% 改为pi的形式
            speed1 = str2double(get(obj.wx_speed_edit, 'string'));
            tx_num_edit = str2double(get(obj.wx_tx_num_edit, 'string'));
            txbs_width_edit = str2double(get(obj.wx_txbs_width_edit, 'string'));
            
             %高斯分布参数获取
             gaosi_lat1=str2double(get(obj.gaosi_center_lat_edit_1, 'string'));
             gaosi_lon1=str2double(get(obj.gaosi_center_lon_edit_1, 'string'));
             gaosi_lat2=str2double(get(obj.gaosi_center_lat_edit_2, 'string'));
             gaosi_lon2=str2double(get(obj.gaosi_center_lon_edit_2, 'string'));
         
             %校验高斯分布的经纬度
             if is_err_lat(gaosi_lat1)
                 set(obj.edt_echo, 'string', '高斯分布参数1,纬度必须为[-90,90].');
                 return;
             end
             
             % 设置高斯分布参数
             if gaosi_center1_isempty(obj)&&gaosi_center2_isempty(obj)
                 set(obj.edt_echo, 'string', '高斯分布参数不能为空.');
                 return ;
             elseif ~gaosi_center1_isempty(obj) && gaosi_center2_isempty(obj)
                 goss_plane_num =str2double(get(obj.gaosi_plane_num_edit_1, 'string'));
                 if isnan(goss_plane_num)
                     set(obj.edt_echo, 'string', '高斯分布1飞机数量必须为数字.');
                     return ;
                 elseif goss_plane_num<0 || goss_plane_num>10000
                     set(obj.edt_echo, 'string', '高斯分布1飞机数量超出范围，应为[0,10000],请重新设置.');
                     return ;
                 end
                 if is_gaosi_lat_range_err(obj,gaosi_lat1,obj.goss_range(1,3),obj.goss_range(1,4))
                     set(obj.edt_echo, 'string', '高斯分布1纬度不在范围内！.');
                     return;
                 end
                 gaosi_range_edt1 = str2double(get(obj.gaosi_gl_range_edt1, 'string'));
                 if isnan(gaosi_range_edt1)
                     set(obj.edt_echo, 'string', '高斯分布1高斯范围参数必须为数字.');
                     return ;
                 elseif gaosi_range_edt1<0
                     set(obj.edt_echo, 'string', '高斯分布1高斯范围参数必须大于0.');
                     return ;
                 end
                 goss_num_arr=[goss_plane_num];
                 if gaosi_lon1<0
                    gaosi_lon1=gaosi_lon1+360;
                 end
                 gaosi_lat1=90-gaosi_lat1;
                 goss =[gaosi_lon1,gaosi_lat1];
                 range1=goss_parameter(gaosi_lat1,gaosi_range_edt1);
                  range=zeros(2,1);
                  range(1,1)=range1(1,1);
                  range(2,1)=range1(1,2);
             elseif  gaosi_center1_isempty(obj) && ~gaosi_center2_isempty(obj)
                  set(obj.edt_echo, 'string', '高斯分布1参数不能为空.');
                 return ;
             else               
                   goss_plane_num =str2double(get(obj.gaosi_plane_num_edit_1, 'string'));
                  if isnan(goss_plane_num)
                     set(obj.edt_echo, 'string', '高斯分布1飞机数量必须为数字.');
                      return ;
                  elseif goss_plane_num<0 || goss_plane_num>10000
                     set(obj.edt_echo, 'string', '高斯分布1飞机数量超出范围，应为[0,10000],请重新设置.');
                     return ;
                  end
               
                  gaosi_range_edt1 = str2double(get(obj.gaosi_gl_range_edt1, 'string'));
                 if isnan(gaosi_range_edt1)
                     set(obj.edt_echo, 'string', '高斯分布1高斯范围参数必须为数字.');
                     return ;
                 elseif gaosi_range_edt1<0
                     set(obj.edt_echo, 'string', '高斯分布1高斯范围参数必须大于0.');
                     return ;
                 end
                  goss_plane_num2 =str2double(get(obj.gaosi_plane_num_edit_2, 'string'));
                  if isnan(goss_plane_num2)
                         set(obj.edt_echo, 'string', '高斯分布2飞机数量必须为数字.');
                            return ;
                  elseif goss_plane_num2<0 || goss_plane_num2>10000
                         set(obj.edt_echo, 'string', '高斯分布2飞机数量超出范围，应为[0,10000],请重新设置.');
                         return ;
                  end
                  gaosi_range_edt2 = str2double(get(obj.gaosi_gl_range_edt2, 'string'));
                 if isnan(gaosi_range_edt2)
                     set(obj.edt_echo, 'string', '高斯分布2高斯范围参数必须为数字.');
                     return ;
                 elseif gaosi_range_edt2<0
                     set(obj.edt_echo, 'string', '高斯分布2高斯范围参数必须大于0.');
                     return ;
                 end
                  goss_num_arr = [goss_plane_num,goss_plane_num2];
                      %校验高斯纬度分布范围
                  if is_gaosi_lat_range_err(obj,gaosi_lat1,obj.goss_range(1,3),obj.goss_range(1,4))
                     set(obj.edt_echo, 'string', '高斯分布1纬度不在范围内！.');
                     return;
                  end
                  if is_gaosi_lat_range_err(obj,gaosi_lat2,obj.goss_range(1,5),obj.goss_range(1,6))
                     set(obj.edt_echo, 'string', '高斯分布2纬度不在范围内！.');
                     return;
                  end
                  if gaosi_lon1<0
                     gaosi_lon1=gaosi_lon1+360;
                  end
                  gaosi_lat1=90-gaosi_lat1;
                  goss1 =[gaosi_lon1,gaosi_lat1]; 
                  range1=goss_parameter(gaosi_lat1,gaosi_range_edt1);
                  if gaosi_lon2<0
                        gaosi_lon2=gaosi_lon2+360;
                  end
                  gaosi_lat2=90-gaosi_lat2;
                  goss2 =[gaosi_lon2,gaosi_lat2];
                  goss=[goss1;goss2];
                  range2=goss_parameter(gaosi_lat2,gaosi_range_edt2);
                  range=zero(2,2);
                  range(1,1)=range1(1,1);
                  range(2,1)=range1(1,2);
                  range(1,2)=range2(1,1);
                  range(2,2)=range2(1,2);
             end

            % 接下来需要调用随机方法生成随机的飞机信息矩阵
            set(obj.edt_echo, 'string', '正在获取飞机参数...');
            pause(0.2);
            planes= PlaneDistribute(wx_lon,wx_lat,high1,fnum,goss_num_arr,goss,range);
            planes_id = ID_creat(size(planes,2));%根据飞机个数生成ID。
            set(obj.edt_echo, 'string', '正在进行仿真...');
            pause(0.2);
            %调用主函数
             minimal_rec_power_edt = str2double(get(obj.minimal_rec_power, 'string'));
            [ obj.mess_112_hex,obj.time_asix_mess,obj.mess_rec_all,obj.mess_rec_all1,obj.mess_rec_all2,obj.plane_lon_result,obj.plane_lat_result,obj.plane_high_result,obj.planes_id_result]=satellite_simple_gui_main(planes,ftime,wx_lon,wx_lat,high1,speed1,hxj1,tx_num_edit,power1,txbs_width_edit,planes_id,minimal_rec_power_edt);
            for i = 1:size(obj.plane_lon_result,1)
               if obj.plane_lon_result(i,1)>180
                  obj.plane_lon_path(i,:) = obj.plane_lon_result(i,:)-360;
               else
                 obj.plane_lon_path(i,:) = obj.plane_lon_result(i,:); 
               end
            end
           obj.plane_lat_path = 90-obj.plane_lat_result;
            set(obj.edt_echo, 'string', '正在写入结果文件...');
            pause(0.2);
            write_lat_data_2_file(obj.plane_lat_path);
            write_lon_data_2_file(obj.plane_lon_path);
            write_excel_file2(obj.time_asix_mess,obj.planes_id_result, obj.mess_112_hex);
            if wx_lon>180
                temp_lon =wx_lon-360;
            else 
                temp_lon =wx_lon;
            end
            write_satellite_location(temp_lon,90-wx_lat,high1);%写入卫星位置文件
            plane_lon_first_col = obj.plane_lon_path(:,1);
            plane_lat_first_col = obj.plane_lat_path(:,1);
            write_plane_param_2_file(obj.time_asix_mess,obj.planes_id_result,plane_lon_first_col,plane_lat_first_col);%写入pointinfo.txt
            planes_in_the_world_map_with_satellite(obj.plane_lon_path,obj.plane_lat_path,temp_lon,90-wx_lat,high1);%有卫星的轨迹图，直接matlab展示
            set(obj.edt_echo, 'string', '写入结果文件完成.程序结束！');
        end
        
        % Callback function for exit button.
        function button_exit_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '退出程序...');
            pause(0.3);
            
            close(obj.gui_p);
            clear;
            clc;
        end
        
        
    
         % 校验飞机数量和仿真时间
        function s= check_plane_num_times(obj)
            s=0;
            if isempty(get(obj.plane_num_edt, 'string'))
                set(obj.edt_echo, 'string', '尚未设置飞机数量，请先设置飞机数量！');
                return ;
            end
            
            if isempty(get(obj.plane_edt_times, 'string'))
                set(obj.edt_echo, 'string', '尚未设置仿真时长，请先设置仿真时长！');
                return ;
            end
            
            fnum = str2double(get(obj.plane_num_edt, 'string'));
            if isnan(fnum)
                set(obj.edt_echo, 'string', '设置的飞机数量中包含非法字符，应为正整数，请重新设置！');
                return ;
            elseif ~isempty(find(get(obj.plane_num_edt, 'string') == '.', 1))
                set(obj.edt_echo, 'string', '设置的飞机数量为小数，应为正整数，请重新设置！');
                return;
            elseif fnum <= 0 || fnum > 10000
                set(obj.edt_echo, 'string', '设置的飞机数量超出范围，应为(0, 10000]，请重新设置！');
                return ;
            end
            
            ftime = str2double(get(obj.plane_edt_times, 'string'));
            if isnan(ftime)
                set(obj.edt_echo, 'string', '设置的仿真时长中包含非法字符，应为数值，请重新设置！');
                return ;
            elseif ftime <= 0 || ftime > 60
                set(obj.edt_echo, 'string', '设置的仿真时长超出范围，应为(0, 60]，请重新设置！');
                return ;
            end
            s=1;
            return ;
        end
        
      
          % 校验卫星参数是否正确
        function s = check_wx_param(obj)
            s=0;
        
            lat1 = str2double(get(obj.wx_lat_edit, 'string'));
            lon1 = str2double(get(obj.wx_lon_edit, 'string'));
            high1 = str2double(get(obj.wx_high_edit, 'string'));
            power1 = str2double(get(obj.wx_tx_power_edit, 'string'));
            hxj1 = str2double(get(obj.wx_hxj_edit, 'string'));
            speed1 = str2double(get(obj.wx_speed_edit, 'string'));
            tx_num_edit = str2double(get(obj.wx_tx_num_edit, 'string'));
            txbs_width_edit = str2double(get(obj.wx_txbs_width_edit, 'string'));
            minimal_rec_power_edt = str2double(get(obj.minimal_rec_power, 'string'));
            
            if is_err_lat(lat1)
                set(obj.edt_echo, 'string', '卫星纬度度超出范围，应为[-90, 90]，请重新设置！');
                return;
            end
            if is_err_lon(lon1)
                set(obj.edt_echo, 'string', '卫星经度超出范围，应为[-180, 180]，请重新设置！');
                return;
             end
             if isnan(high1)
                set(obj.edt_echo, 'string',  '卫星高度必须为数字，请重新设置！');
                return;
             elseif high1<0||high1>100000
                set(obj.edt_echo, 'string',  '卫星高度超出范围，应为[10, 100000]，请重新设置！');
                return;
             end
            if isnan(speed1)
                set(obj.edt_echo, 'string',  '卫星速度必须为数字，请重新设置！');
                return;
             elseif speed1<0||speed1>1000
                set(obj.edt_echo, 'string',  '卫星速度必须为数字，应为[0, 1000]，请重新设置！');
                return;
             end
             if is_err_hxj(hxj1)
                set(obj.edt_echo, 'string',  '卫星航向角超出范围，应为[0, 360]，请重新设置！');
                return;
             end
             if is_err_gl(power1)
                set(obj.edt_echo, 'string',  '卫星功率必须是数字，请重新设置！');
                return;
             end
             if isnan(tx_num_edit)
                set(obj.edt_echo, 'string',  '卫星天线数量必须为数字，请重新设置！');
                return;
             elseif tx_num_edit<0||tx_num_edit>10
                set(obj.edt_echo, 'string',  '卫星天线数量必须为数字，应为[0, 10]，请重新设置！');
                return;
             end
             
             if isnan(txbs_width_edit)
                set(obj.edt_echo, 'string', '卫星天线波速宽度必须为数字，请重新设置！');
                return;
             elseif txbs_width_edit<0
                set(obj.edt_echo, 'string', '卫星天线波速宽度必须为正数，请重新设置！');
                return;
             end
             
             if isnan(minimal_rec_power_edt)
                set(obj.edt_echo, 'string', '最小接收功率必须为数字，请重新设置！');
                return;
             end
             
            s=1;
        end
        
        
          % 校验高斯中心参数是否为空
        function s = gaosi_center1_isempty(obj)      
             s=1;
             if ~isempty(get(obj.gaosi_center_lat_edit_1, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.gaosi_center_lon_edit_1, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.gaosi_plane_num_edit_1, 'string'))
                 s=0;
                 return;
             end
        end
        
         % 校验高斯中心2参数是否为空
        function s = gaosi_center2_isempty(obj)      
             s=1;
             if ~isempty(get(obj.gaosi_center_lat_edit_2, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.gaosi_center_lon_edit_2, 'string'))
                 s=0;
                 return;
             end
             if ~isempty(get(obj.gaosi_plane_num_edit_2, 'string'))
                 s=0;
                 return;
             end
        end
        
         % 校验高斯分布经纬度范围
        function s = is_gaosi_lat_range_err(obj,goss_lat,lat_down,lat_up)      
             s=1;
             if  goss_lat>90||goss_lat<-90
                 set(obj.edt_echo, 'string', '你输入的纬度不在范围内,请重新输入！');
                 return;
             end
             if goss_lat>=lat_up&&goss_lat<=lat_down
                  % 正确的纬度
             else
                  % 错误的纬度
                  set(obj.edt_echo, 'string', '你输入的纬度不在范围内,请重新输入！');
                  return;
             end        
             s=0;
        end
        
        %获取单独的飞机数据
        function btn_export_icao_callback(obj, source, eventdata)
           
            icao = get(obj.edt_export_icao, 'string');
            set(obj.edt_echo, 'string', strcat('正在获取ICAO=',icao));
            write_excel_file_filter_plane_satellite(obj.time_asix_mess,obj.planes_id_result, obj.mess_112_hex,icao);
            set(obj.edt_echo, 'string', strcat('获取ICAO=',icao,'数据完毕!'));
            return
        end
        
        function callback_mapping(obj)
          
            set(obj.set_wx_param_btn, 'callback', @obj.set_wx_param_btn_callback);
            set(obj.get_goss_lat_range_btn1, 'callback', @obj.set_goss_lon_btn1_callback);
            set(obj.get_goss_lat_range_btn2, 'callback', @obj.set_goss_lon_btn2_callback);
            set(obj.btn_c1, 'callback', @obj.button_start_callback);
            set(obj.btn_c2, 'callback', @obj.button_exit_callback);
            set(obj.btn_export_icao, 'callback', @obj.btn_export_icao_callback);
        end
        
    
    end
    
   
end