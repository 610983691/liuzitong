classdef no_satellite_random_plane_gui_start < handle
%% *********************************************************************
%
% @file         no_satellite_random_plane_gui_start.m
% @brief        Class definition for button 2 GUI.
%
% ******************************************************************************
    properties
        % Handle for this GUI.
        gui_p; 
        % GUI handle for the parent GUI.
        gui_parent;
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
        plane_edt_auto_power;
        
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
        time_asix_mess;
        planes_id_out;
        mess_112_hex;
        mess_test;
        
        % Callback function flag.
        cb_auto_config = 0;
        cb_man_config = 0;
        
        % Plane parameter check flag.
        ppc = 0;
        % Receiver parameter check flag.
        rpc = 0;
        plane_ICAO_double;
        plane_ID_double;
    end
    
    methods
         % 无卫星的随机分布飞机参数模式
        function obj = no_satellite_random_plane_gui_start(gui_parent)
            obj.gui_parent=gui_parent;
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
                'Numbertitle', 'off', 'Name', '无卫星随机分布场景仿真程序', ...
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
            set(obj.plane_num_edt, 'string', '10');
             % Init 报文功率
            obj.plane_txt_auto_power = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','报文功率（dbm）','position',[2+(2*txt_area_width_label+edit_area_width) ...
                (obj.panel_height/3 -10) txt_area_width_label 40]);
            obj.plane_edt_auto_power = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[3+(3*txt_area_width_label+edit_area_width) obj.panel_height/3 ...
              edit_area_width 40]);
             set(obj.plane_edt_auto_power, 'string', '-90');
          
               % Init 仿真时长
            obj.plane_txt_times = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','仿真时长(s)','position',[6+(4*txt_area_width_label+2*edit_area_width) ...
                (obj.panel_height/3 -10) txt_area_width_label 40]);
            obj.plane_edt_times = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[7+(5*txt_area_width_label+2*edit_area_width) obj.panel_height/3 ...
              edit_area_width 40]);
            set(obj.plane_edt_times, 'string', '10');
         

          
           % 程序状态区域
           obj.panel_plane_start = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '程序运行区域', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - 2*obj.panel_height-50 , obj.panel_width-10, ...
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
         
        % Callback function for automatic configuration button.
        function btn_export_icao_callback(obj, source, eventdata)
           
            icao = get(obj.edt_export_icao, 'string');
             set(obj.edt_echo, 'string', strcat('正在获取ICAO=',icao));
            write_excel_file_filter_plane_nosatellite(obj.time_asix_mess,obj.planes_id_out,obj.mess_112_hex,icao);
             set(obj.edt_echo, 'string', strcat('获取ICAO=',icao,'数据完毕!'));
            return
        end
        
        % Callback function for button start.
        function button_start_callback(obj, source, eventdata)
           set(obj.edt_echo, 'string', '准备进行仿真...');
            pause(0.2);
           if check_plane_param(obj)==0
                return ;
           end
            ftime = str2double(get(obj.plane_edt_times, 'string'));
            fnum = str2double(get(obj.plane_num_edt, 'string'));
            plane_power = str2double(get(obj.plane_edt_auto_power, 'string'));%报文功率
            % 接下来需要调用随机方法生成随机的飞机信息矩阵
            set(obj.edt_echo, 'string', '正在获取飞机参数...');
            pause(0.2);
            planes= PlaneDistribute1(fnum);
            planes_id = ID_creat(fnum);
            set(obj.edt_echo, 'string', '正在进行仿真...');
            pause(0.2);
            % 接下来调用紫童的方法传递参数，进行仿真
            [obj.mess_test,obj.mess_112_hex,obj.time_asix_mess,obj.mess_rec_all,result_lon,result_lat,result_high,obj.planes_id_out]  =no_satellite_mul_plane_main(planes,ftime,planes_id);
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
            set(obj.edt_echo, 'string', '仿真完成，正在写入结果文件...');
            pause(0.2);
            write_lat_data_2_file(obj.plane_lat_path);
            write_lon_data_2_file(obj.plane_lon_path);
            write_excel_file1(obj.time_asix_mess,obj.planes_id_out,obj.mess_112_hex);%写入excel文件
            plane_lon_first_col = obj.plane_lon_path(:,1);
            plane_lat_first_col = obj.plane_lat_path(:,1);
            write_plane_param_2_file(obj.time_asix_mess,obj.planes_id_out,plane_lon_first_col,plane_lat_first_col);%写入pointINfo.TXT文件
            planes_in_the_world_map(obj.plane_lon_path,obj.plane_lat_path);%无卫星的轨迹图，直接matlab展示
            set(obj.edt_echo, 'string', '结果写入完毕，程序结束！');
            return;
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
        function s= check_plane_param(obj)
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
            elseif fnum <= 0 || fnum > 10000
                set(obj.edt_echo, 'string', '设置的飞机数量超出范围，应为(0, 10000]，请重新设置！');
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
            

             plane_power = str2double(get(obj.plane_edt_auto_power, 'string'));%报文功率
             if isnan(plane_power)
                set(obj.edt_echo, 'string', '设置的报文功率中包含非法字符，应为数值，请重新设置！');
                return ;
             end
            
             %全部校验完了就表明正确返回1
             s=1;
            return ;
        end
        
        
        function callback_mapping(obj)
          
            
            set(obj.btn_export_icao, 'callback', @obj.btn_export_icao_callback);
            set(obj.btn_c1, 'callback', @obj.button_start_callback);
            set(obj.btn_c2, 'callback', @obj.button_exit_callback);
           
        end
        
    end
    
   
end