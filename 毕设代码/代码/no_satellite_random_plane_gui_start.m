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
        
        % Plane number.�ɻ�����
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
    
        
      
        
        % Panel handle of the plane settings panel.�ɻ�1,2,3��panel
        panel_auto_config;
        panel_plane_1;
        panel_plane_2;
        panel_plane_3;
        plane_txt_times;%����ʱ��
        plane_edt_times;
        panel_plane_start;
       
        %------�Զ���������Ĺ���
        plane_txt_auto_power;
        plane_edt_auto_power;
        
        % Text handle for plane param, Lattitude, Longtitude, and height.
        plane_txt_lat1,plane_txt_lat2,plane_txt_lat3;
        plane_edt_lat1, plane_edt_lat2, plane_edt_lat3;%ά��
        plane_txt_lon1,plane_txt_lon2,plane_txt_lon3;
        plane_edt_lon1, plane_edt_lon2, plane_edt_lon3;%����
        plane_txt_alt1,plane_txt_alt2,plane_txt_alt3;
        plane_edt_alt1,plane_edt_alt2,plane_edt_alt3;%�߶�
        % Text handle for plane velocity, and azimuth.
        plane_txt_vh1,plane_txt_vh2,plane_txt_vh3;
        plane_edt_vh1,plane_edt_vh2,plane_edt_vh3;%�ٶ�
        plane_txt_az1,plane_txt_az2,plane_txt_az3;
        plane_edt_az1,plane_edt_az2,plane_edt_az3;%�����
        plane_txt_icao1,plane_txt_icao2,plane_txt_icao3;
        plane_edt_icao1,plane_edt_icao2,plane_edt_icao3;%ICAO
        plane_txt_id1,plane_txt_id2,plane_txt_id3;
        plane_edt_id1,plane_edt_id2,plane_edt_id3;%ICAO
        plane_txt_pw1,plane_txt_pw2,plane_txt_pw3;
        plane_edt_pw1,plane_edt_pw2,plane_edt_pw3;%����
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
         % �����ǵ�����ֲ��ɻ�����ģʽ
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
            obj.panel_height = obj.gui_height/5;%panel��5�У�������panel����5�ĸ߶�.
            edit_area_width=120;%�ı���Ŀ�ȹ̶�Ϊ100
            txt_area_width_label=130;%label����Ϊ130
            
            
            % The first row info.
            % Create figure and init.
            obj.gui_p = figure('Color', [0.83, 0.82, 0.78], ...
                'Numbertitle', 'off', 'Name', '����������ֲ������������', ...
                'Position', [floor((obj.width - obj.gui_width) / 2), ...
                floor((obj.height - obj.gui_height) / 2), obj.gui_width, ...
                obj.gui_height], 'Toolbar', 'none', 'Resize', 'off');
            
            % Create plane param settings panel.
            obj.panel_auto_config = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '�Զ����ò�������', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - obj.panel_height-50 , obj.panel_width-10, ...
                obj.panel_height]);
            % Plane number settings.
            obj.plane_num_txt = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','�ɻ�����','position',[15 ...
                (obj.panel_height/3 -10) txt_area_width_label 40]);
            obj.plane_num_edt = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[1+txt_area_width_label obj.panel_height/3 ...
              edit_area_width 40]);
            set(obj.plane_num_edt, 'string', '10');
             % Init ���Ĺ���
            obj.plane_txt_auto_power = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','���Ĺ��ʣ�dbm��','position',[2+(2*txt_area_width_label+edit_area_width) ...
                (obj.panel_height/3 -10) txt_area_width_label 40]);
            obj.plane_edt_auto_power = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[3+(3*txt_area_width_label+edit_area_width) obj.panel_height/3 ...
              edit_area_width 40]);
             set(obj.plane_edt_auto_power, 'string', '57');
          
               % Init ����ʱ��
            obj.plane_txt_times = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','����ʱ��(s)','position',[6+(4*txt_area_width_label+2*edit_area_width) ...
                (obj.panel_height/3 -10) txt_area_width_label 40]);
            obj.plane_edt_times = uicontrol('parent', obj.panel_auto_config, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[7+(5*txt_area_width_label+2*edit_area_width) obj.panel_height/3 ...
              edit_area_width 40]);
            set(obj.plane_edt_times, 'string', '10');
         

          
           % ����״̬����
           obj.panel_plane_start = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '������������', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - 2*obj.panel_height-50 , obj.panel_width-10, ...
                obj.panel_height]);
            % panleλ������
      
             % Create echo info window.
            obj.txt_echo = uicontrol('parent', obj.panel_plane_start, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','����״̬��Ϣ','position',[(obj.gui_width-3*obj.gui_width/4 -120) ...
                obj.panel_height - 90 120 40]);
            obj.edt_echo = uicontrol('parent', obj.panel_plane_start, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[obj.gui_width/4 ...
              obj.panel_height - 80 obj.gui_width/2 40]);
            % Create handle for button "Start programme".
            obj.btn_c1 = uicontrol('parent', obj.panel_plane_start, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '��ʼ', ...
                'Fontsize', 15, 'position', [floor((obj.gui_width ) / 3), ...
                obj.panel_height - 130, 150, 40]);
            % Create handle for button "Stop programme"��
            obj.btn_c2 = uicontrol('parent', obj.panel_plane_start, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '�˳�', ...
                'Fontsize', 15, 'position', [floor((obj.gui_width ) / 3)+250 , ...
                obj.panel_height - 130, 150, 40]);
            
            % Mapping to the callback function.
            callback_mapping(obj);
        end
         
        % Callback function for automatic configuration button.
        function result =button_auto_config_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '����,��Ӧ�õ��õ����');
            return
        end
        
        % Callback function for button start.
        function result =button_start_callback(obj, source, eventdata)
              set(obj.edt_echo, 'string', '׼�����з���...');
           if check_plane_param(obj)==0
                return ;
           end
            ftime = str2double(get(obj.plane_edt_times, 'string'));
            fnum = str2double(get(obj.plane_num_edt, 'string'));
            plane_power = str2double(get(obj.plane_edt_auto_power, 'string'));%���Ĺ���
            % ��������Ҫ�������������������ķɻ���Ϣ����
            set(obj.edt_echo, 'string', '���ڻ�ȡ�ɻ�����...');
  
            planes= PlaneDistribute1(fnum);
            set(obj.edt_echo, 'string', '���ڽ��з���...');
            % ������������ͯ�ķ������ݲ��������з���
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
            set(obj.edt_echo, 'string', '�������');
        end
        
        % Callback function for exit button.
        function button_exit_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '�˳�����...');
            pause(0.3);
            
            close(obj.gui_p);
            clear;
            clc;
        end
        
       
        
         % У��ɻ������ͷ���ʱ��
        function s= check_plane_param(obj)
            s=0;
            if isempty(get(obj.plane_num_edt, 'string'))
                set(obj.edt_echo, 'string', '��δ���÷ɻ��������������÷ɻ�������');
                return ;
            end
            
            if isempty(get(obj.plane_edt_times, 'string'))
                set(obj.edt_echo, 'string', '��δ���÷���ʱ�䣬�������÷���ʱ�䣡');
                return ;
            end
            
            fnum = str2double(get(obj.plane_num_edt, 'string'));
            if isnan(fnum)
                set(obj.edt_echo, 'string', '���õķɻ������а����Ƿ��ַ���ӦΪ�����������������ã�');
                return ;
            elseif ~isempty(find(get(obj.plane_num_edt, 'string') == '.', 1))
                set(obj.edt_echo, 'string', '���õķɻ�����ΪС����ӦΪ�����������������ã�');
                return;
            elseif fnum <= 0 || fnum > 100
                set(obj.edt_echo, 'string', '���õķɻ�����������Χ��ӦΪ(0, 100]�����������ã�');
                return ;
            end
            
            ftime = str2double(get(obj.plane_edt_times, 'string'));
            if isnan(ftime)
                set(obj.edt_echo, 'string', '���õķ���ʱ���а����Ƿ��ַ���ӦΪ��ֵ�����������ã�');
                return ;
            elseif ftime <= 0 || ftime > 60
                set(obj.edt_echo, 'string', '���õķ���ʱ�䳬����Χ��ӦΪ(0, 60]�����������ã�');
                return ;
            end
            

             plane_power = str2double(get(obj.plane_edt_auto_power, 'string'));%���Ĺ���
             if isnan(plane_power)
                set(obj.edt_echo, 'string', '���õı��Ĺ����а����Ƿ��ַ���ӦΪ��ֵ�����������ã�');
                return ;
            elseif plane_power <= 0 || plane_power > 1000
                set(obj.edt_echo, 'string', '���õı��Ĺ��ʳ�����Χ��ӦΪ(0, 1000]�����������ã�');
                return ;
             end
            
             %ȫ��У�����˾ͱ�����ȷ����1
             s=1;
            return ;
        end
        
    
        %�����ɻ���Ϣ
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