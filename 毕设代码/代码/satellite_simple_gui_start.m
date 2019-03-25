classdef satellite_simple_gui_start < handle
%% *********************************************************************
%
% @file         satellite_simple_gui_start.m
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
        panel_plane_1;
        panel_plane_2;
        panel_plane_3;
        plane_txt_times;%����ʱ��
        plane_edt_times;
       
        
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
        
        
        plane_txt_pw1,plane_txt_pw2,plane_txt_pw3;
        plane_edt_pw1,plane_edt_pw2,plane_edt_pw3;%����

        
        
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
        mess_rec_all1;
        mess_rec_all2;
        
        % Callback function flag.
        cb_auto_config = 0;
        cb_man_config = 0;
        
        % ����panel
        wx_panel_erea;
        wx_gaosi_erea1;
        wx_gaosi_erea2;
        wx_gaosi_erea2_sub1;
        wx_gaosi_erea2_sub2;
        
  
        
        %����panel�����ֶε�label������ı�����
         wx_lat_txt;
        wx_lon_txt;
        wx_high_txt;
        wx_tx_power_txt;%���߹���
        wx_hxj_txt;
        wx_speed_txt;
        wx_tx_num_txt;%��������
        wx_txbs_width_txt;%���߲������
        %�������ı���Ķ���
        wx_lat_edit;
        wx_lon_edit;
        wx_high_edit;
        wx_tx_power_edit;%���߹���
        wx_hxj_edit;
        wx_speed_edit;
        wx_tx_num_edit;%��������
        wx_txbs_width_edit;%���߲������
        %��˹�ֲ���γ������
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
        
    end
    
    methods
        % Create figure and init.
        function obj = satellite_simple_gui_start()
            screen_size = get(0, 'ScreenSize');
            screen_size(screen_size < 100) = [];
            obj.width  = screen_size(1);
            obj.height = screen_size(2);
            
            % Set the width and height of the GUI.
            obj.gui_width = obj.width-60;
            obj.gui_height = obj.height - 100;
            % Set the plane param settings panel widht and height.
            obj.panel_width = obj.gui_width;
            obj.panel_height = 160;
            
             % panleλ������
            edit_area_width=80;%�ı���Ŀ�ȹ̶�Ϊ100
            txt_area_width_label=120;%label����Ϊ130
            
            % The first row info.
            % Create figure and init.
            obj.gui_p = figure('Color', [0.83, 0.82, 0.78], ...
                'Numbertitle', 'off', 'Name', '�����Ǹ���ģʽ', ...
                'Position', [floor((obj.width - obj.gui_width) / 2), ...
                floor((obj.height - obj.gui_height) / 2), obj.gui_width, ...
                obj.gui_height], 'Toolbar', 'none', 'Resize', 'off');

            
               % ���ǲ�������
            obj.wx_panel_erea = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '���ǲ�����������', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - 130 , obj.panel_width-10, ...
                130]);
             % Init the Lattitude text for plane param.
            obj.wx_lat_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','��ʼγ��','position',[0 50 ...
                txt_area_width_label 40]);
            obj.wx_lat_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[txt_area_width_label+1 60 ...
              edit_area_width 40]);
             
            % Init the Longtitude text for the plane.
            obj.wx_lon_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','��ʼ����','position',[2+(txt_area_width_label+edit_area_width) 50 ...
                txt_area_width_label 40]);
            obj.wx_lon_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) 60 ...
              edit_area_width 40]);
        
 
            % Init the transmit power of the plane.
            obj.wx_tx_power_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','����(dbm)','position',[4+(2*txt_area_width_label+2*edit_area_width) 50 ...
                txt_area_width_label 40]);
            obj.wx_tx_power_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white','Fontsize',11,'position', ...
                [5+(3*txt_area_width_label+2*edit_area_width) 60 edit_area_width 40]);
            % Init the height text for the plane.
            obj.wx_high_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','���Ǹ߶�(km)','position',[6+(3*txt_area_width_label+3*edit_area_width) 50 ...
                txt_area_width_label 40]);
            obj.wx_high_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) 60 ...
              edit_area_width 40]);
          
            % Init the velocity text for the plane.
            obj.wx_speed_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','�����ٶ�(km/s)','position',[8+(4*txt_area_width_label+4*edit_area_width) 50 ...
                txt_area_width_label 40]);
            obj.wx_speed_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[9+(5*txt_area_width_label+4*edit_area_width) 60 ...
              edit_area_width 40]);
         
         
            % Init the azimuth of the plane.
            obj.wx_hxj_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','���Ǻ����(��)','position',[0 0 ...
                txt_area_width_label 40]);
            obj.wx_hxj_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[1+(txt_area_width_label) 10 ...
              edit_area_width 40]);
          
           % Init the azimuth of the plane.
            obj.wx_tx_num_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','��������','position',[2+(txt_area_width_label+edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.wx_tx_num_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) 10 ...
              edit_area_width 40]);
          
           % Init the azimuth of the plane.
            obj.wx_txbs_width_txt = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','���߲������','position',[4+(2*txt_area_width_label+2*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.wx_txbs_width_edit = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[5+(3*txt_area_width_label+2*edit_area_width) 10 ...
              edit_area_width 40]);
          
            
                % Init ����ʱ��
            obj.plane_txt_times = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','����ʱ��(s)','position',[6+(3*txt_area_width_label+3*edit_area_width) ...
                0 txt_area_width_label 40]);
            obj.plane_edt_times = uicontrol('parent', obj.wx_panel_erea, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width)  10 ...
              edit_area_width 40]);
            
            
              % ����ֲ�����
            obj.wx_gaosi_erea1 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '����ֲ�������������', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height-140-80 , obj.panel_width-10, ...
                80]);
            
            % �ɻ�����
            obj.plane_num_txt = uicontrol('parent', obj.wx_gaosi_erea1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','����ֲ��ɻ�����','position',[15 0 130 40]);
            obj.plane_num_edt = uicontrol('parent', obj.wx_gaosi_erea1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[150 10 ...
              80 40]);

              % ��˹�ֲ�����
            obj.wx_gaosi_erea2 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '��˹�ֲ�������������', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - obj.panel_height-160 , obj.panel_width-10, ...
                100]);
            
            obj.wx_gaosi_erea2_sub1 = uipanel('parent', obj.wx_gaosi_erea2, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '��˹�ֲ�������������һ', 'Fontsize', 12, 'Position', [30, ...
                0 , (obj.panel_width-10)/2 - 10, ...
                70]);
            
            obj.wx_gaosi_erea2_sub2 = uipanel('parent', obj.wx_gaosi_erea2, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '��˹�ֲ��������������', 'Fontsize', 12, 'Position', [30+ (obj.panel_width-10)/2 - 10, ...
                0, (obj.panel_width-10)/2 - 10, ...
                70]);
            %����6���Ǹ�˹�ֲ���������һ���ı���
            obj.gaosi_center_lat_txt_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','γ��','position',[0 0 80 40]);
            obj.gaosi_center_lat_edit_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[81 10 ...
              80 40]);
           obj.gaosi_center_lon_txt_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','����','position',[180 0 100 40]);
            obj.gaosi_center_lon_edit_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[281 10 ...
              80 40]);
           obj.gaosi_plane_num_txt_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','�ɻ�����','position',[370 0 100 40]);
            obj.gaosi_plane_num_edit_1 = uicontrol('parent', obj.wx_gaosi_erea2_sub1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[471 10 ...
              80 40]);
            
          %����6���Ǹ�˹�ֲ�������������ı���
            obj.gaosi_center_lat_txt_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','γ��','position',[0 0 80 40]);
            obj.gaosi_center_lat_edit_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[81 10 ...
              80 40]);
           obj.gaosi_center_lon_txt_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','����','position',[180 0 100 40]);
            obj.gaosi_center_lon_edit_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[281 10 ...
              80 40]);
           obj.gaosi_plane_num_txt_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','�ɻ�����','position',[370 0 100 40]);
            obj.gaosi_plane_num_edit_2 = uicontrol('parent', obj.wx_gaosi_erea2_sub2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[471 10 ...
              80 40]);
          
            %��ʼ���÷ɻ�����
            % Create plane param settings panel.
            obj.panel_plane_1 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '�ɻ�һ������������', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - obj.panel_height-240, obj.panel_width-10, ...
                80]);
  
            % Init the Lattitude text for plane param.
            obj.plane_txt_lat1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','��ʼγ��','position',[0 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_lat1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[txt_area_width_label+1 10 ...
              edit_area_width 40]);
          
            % Init the Longtitude text for the plane.
            obj.plane_txt_lon1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','��ʼ����','position',[2+(txt_area_width_label+edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_lon1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) 10 ...
              edit_area_width 40]);

            % Init the transmit power of the plane.
            obj.plane_txt_pw1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','����(dbm)','position',[4+(2*txt_area_width_label+2*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_pw1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white','Fontsize',11,'position', ...
                [5+(3*txt_area_width_label+2*edit_area_width) 10 edit_area_width 40]);
            % Init the height text for the plane.
            obj.plane_txt_alt1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','���и߶�(�ղ�)','position',[6+(3*txt_area_width_label+3*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_alt1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) 10 ...
              edit_area_width 40]);
       
            % Init the velocity text for the plane.
            obj.plane_txt_vh1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','�����ٶ�(km/h)','position',[8+(4*txt_area_width_label+4*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_vh1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[9+(5*txt_area_width_label+4*edit_area_width) 10 ...
              edit_area_width 40]);
         
         
            % Init the azimuth of the plane.
            obj.plane_txt_az1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','�����(��)','position',[10+(5*txt_area_width_label+5*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_az1 = uicontrol('parent', obj.panel_plane_1, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[11+(6*txt_area_width_label+5*edit_area_width) 10 ...
              edit_area_width 40]);
          
       
          
          % ��ʼ���õڶ����ɻ��Ĳ���
           % Create plane param settings panel.
           obj.panel_plane_2 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '�ɻ���������������', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - obj.panel_height-320, obj.panel_width-10, ...
                80]);
            % panleλ������
            % Init the Lattitude text for plane param.
            obj.plane_txt_lat2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','��ʼγ��','position',[0 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_lat2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[txt_area_width_label+1 10 ...
              edit_area_width 40]);
             
            % Init the Longtitude text for the plane.
            obj.plane_txt_lon2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','��ʼ����','position',[2+(txt_area_width_label+edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_lon2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) 10 ...
              edit_area_width 40]);
        
 
            % Init the transmit power of the plane.
            obj.plane_txt_pw2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','����(dbm)','position',[4+(2*txt_area_width_label+2*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_pw2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white','Fontsize',11,'position', ...
                [5+(3*txt_area_width_label+2*edit_area_width) 10 edit_area_width 40]);
            % Init the height text for the plane.
            obj.plane_txt_alt2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','���и߶�(�ղ�)','position',[6+(3*txt_area_width_label+3*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_alt2 = uicontrol('parent',obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) 10 ...
              edit_area_width 40]);
       
            % Init the velocity text for the plane.
            obj.plane_txt_vh2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','�����ٶ�(km/h)','position',[8+(4*txt_area_width_label+4*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_vh2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[9+(5*txt_area_width_label+4*edit_area_width) 10 ...
              edit_area_width 40]);
         
            % Init the azimuth of the plane.
            obj.plane_txt_az2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','�����(��)','position',[10+(5*txt_area_width_label+5*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_az2 = uicontrol('parent', obj.panel_plane_2, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[11+(6*txt_area_width_label+5*edit_area_width) 10 ...
              edit_area_width 40]);
          % �ڶ����ɻ������������
          
          % ��ʼ���õ������ɻ��Ĳ���
           % Create plane param settings panel.
           obj.panel_plane_3 = uipanel('parent', obj.gui_p, 'Units', ...
                'pixels', 'BackgroundColor', [0.83, 0.82, 0.78], 'title', ...
                '�ɻ���������������', 'Fontsize', 15, 'Position', [25, ...
                obj.gui_height - obj.panel_height - 400, obj.panel_width-10, ...
                80]);
            % panleλ������
            % Init the Lattitude text for plane param.
            obj.plane_txt_lat3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','��ʼγ��','position',[0 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_lat3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[txt_area_width_label+1 10 ...
              edit_area_width 40]);
             
            % Init the Longtitude text for the plane.
            obj.plane_txt_lon3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','��ʼ����','position',[2+(txt_area_width_label+edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_lon3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[3+(2*txt_area_width_label+edit_area_width) 10 ...
              edit_area_width 40]);
        
            % Init the transmit power of the plane.
            obj.plane_txt_pw3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','����(dbm)','position',[4+(2*txt_area_width_label+2*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_pw3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white','Fontsize',11,'position', ...
                [5+(3*txt_area_width_label+2*edit_area_width) 10 edit_area_width 40]);
            % Init the height text for the plane.
            obj.plane_txt_alt3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','���и߶�(�ղ�)','position',[6+(3*txt_area_width_label+3*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_alt3 = uicontrol('parent',obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white'...
              ,'Fontsize',11,'position',[7+(4*txt_area_width_label+3*edit_area_width) 10 ...
              edit_area_width 40]);
       
             % Init the velocity text for the plane.
            obj.plane_txt_vh3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','�����ٶ�(km/h)','position',[8+(4*txt_area_width_label+4*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_vh3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[9+(5*txt_area_width_label+4*edit_area_width) 10 ...
              edit_area_width 40]);
         
            % Init the azimuth of the plane.
            obj.plane_txt_az3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 11, ...
                'string','�����(��)','position',[10+(5*txt_area_width_label+5*edit_area_width) 0 ...
                txt_area_width_label 40]);
            obj.plane_edt_az3 = uicontrol('parent', obj.panel_plane_3, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[11+(6*txt_area_width_label+5*edit_area_width) 10 ...
              edit_area_width 40]);
          % �������ɻ������������
 
             % Automatic configure.�Զ����÷ɻ�����������
            obj.config_auto = uicontrol('parent', obj.gui_p, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '�Զ����ò�����', ...
                'Fontsize', 12, 'position', [floor((obj.gui_width - 400) /3), 10, 200, 50]);
            % Create handle for button "Start programme".
            obj.btn_c1 = uicontrol('parent', obj.gui_p, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '��ʼ', ...
                'Fontsize', 15, 'position', [floor((obj.gui_width - 400) / 3)+250, ...
                10, 150, 50]);
            % Create handle for button "Stop programme"��
            obj.btn_c2 = uicontrol('parent', obj.gui_p, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '�˳�', ...
                'Fontsize', 15, 'position', [floor((obj.gui_width - 450) / 3) + 500, ...
                10, 150, 50]);
               % Create echo info window.
            obj.txt_echo = uicontrol('parent', obj.gui_p, 'style', ...
                'text', 'BackgroundColor', [0.83 0.82 0.78], 'Fontsize', 12, ...
                'string','����״̬��Ϣ','position',[240 ...
                55 120 40]);
            obj.edt_echo = uicontrol('parent', obj.gui_p, 'style', ...
                'edit', 'BackgroundColor','white' ...
              ,'Fontsize',11,'position',[360 ...
              65 500 40]);
     
            
            % Mapping to the callback function.
            callback_mapping(obj);
        end
        
     
      
        
        % �Զ����ò����з���İ�ť����ص�
        function result =button_auto_config_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '׼�������Զ����÷�������...');
            %У�����ǵ�8������
            if check_wx_param(obj)==0
                 return;
            end
            %У��ɻ���������ͷ���ʱ�� 
            if check_plane_num_times(obj)==0
                return ;
            end
            fnum = str2double(get(obj.plane_num_edt, 'string'));%������ȷֲ��ķɻ�����
            ftime = str2double(get(obj.plane_edt_times, 'string'));%����ʱ��
            %���ǲ�����ȡ
            wx_lat = str2double(get(obj.wx_lat_edit, 'string'));
            wx_lat=90-wx_lat;%תΪ0-180
            wx_lon = str2double(get(obj.wx_lon_edit, 'string'));
            if wx_lon<0
                wx_lon=wx_lon+360;%תΪ0-360
            end
            high1 = str2double(get(obj.wx_high_edit, 'string'));
            power1 = str2double(get(obj.wx_tx_power_edit, 'string'));
            hxj1 = str2double(get(obj.wx_hxj_edit, 'string'));
            hxj1=hxj1*pi/180;% ��Ϊpi����ʽ
            speed1 = str2double(get(obj.wx_speed_edit, 'string'));
            tx_num_edit = str2double(get(obj.wx_tx_num_edit, 'string'));
            txbs_width_edit = str2double(get(obj.wx_txbs_width_edit, 'string'));
            
             %��˹�ֲ�������ȡ
             gaosi_lat1=str2double(get(obj.gaosi_center_lat_edit_1, 'string'));
             gaosi_lon1=str2double(get(obj.gaosi_center_lon_edit_1, 'string'));
             gaosi_lat2=str2double(get(obj.gaosi_center_lat_edit_2, 'string'));
             gaosi_lon2=str2double(get(obj.gaosi_center_lon_edit_2, 'string'));
         
             %У���˹�ֲ��ľ�γ��
             if is_err_lat(gaosi_lat1)
                 set(obj.edt_echo, 'string', '��˹�ֲ�����1,γ�ȱ���Ϊ[-90,90].');
                 return;
             end
              if is_err_lon(gaosi_lon1)
                 set(obj.edt_echo, 'string', '��˹�ֲ�����1,���ȶȱ���Ϊ[-180,180].');
                 return;
              end
              
             % ���ø�˹�ֲ�����
             if gaosi_center1_isempty(obj)&&gaosi_center2_isempty(obj)
                   set(obj.edt_echo, 'string', '��˹�ֲ���������Ϊ��.');
                 return ;
             elseif ~gaosi_center1_isempty(obj) && gaosi_center2_isempty(obj)
                 goss_num_arr=[str2double(get(obj.gaosi_plane_num_edit_1, 'string'))];
                 if gaosi_lon1<0
                    gaosi_lon1=gaosi_lon1+360;
                 end
                 gaosi_lat1=90-gaosi_lat1;
                 goss =[gaosi_lon1,gaosi_lat1];
             elseif  gaosi_center1_isempty(obj) && ~gaosi_center2_isempty(obj)
                  set(obj.edt_echo, 'string', '��˹�ֲ�1��������Ϊ��.');
                 return ;
             else
                 if is_err_lat(gaosi_lat2)
                     set(obj.edt_echo, 'string', '��˹�ֲ�����2,γ�ȱ���Ϊ[-90,90].');
                     return;
                 end
                  if is_err_lon(gaosi_lon2)
                     set(obj.edt_echo, 'string', '��˹�ֲ�����2,���ȶȱ���Ϊ[-180,180].');
                     return;
                  end
                  goss_num_arr = [str2double(get(obj.gaosi_plane_num_edit_1, 'string')),str2double(get(obj.gaosi_plane_num_edit_2, 'string'))];
                   if gaosi_lon1<0
                    gaosi_lon1=gaosi_lon1+360;
                   end
                   gaosi_lat1=90-gaosi_lat1;
                   goss1 =[gaosi_lon1,gaosi_lat1]; 

                   if gaosi_lon2<0
                        gaosi_lon2=gaosi_lon2+360;
                   end
                   gaosi_lat2=90-gaosi_lat2;
                   goss2 =[gaosi_lon2,gaosi_lat2];
                   goss=[goss1;goss2];
             end

            % ��������Ҫ�������������������ķɻ���Ϣ����
            set(obj.edt_echo, 'string', '���ڻ�ȡ�ɻ�����...');
  
            planes= PlaneDistribute(wx_lon,wx_lat,high1,fnum,goss_num_arr,goss);
            set(obj.edt_echo, 'string', '���ڽ��з���...');
            %����������
            [obj.mess_rec_all,obj.mess_rec_all1,obj.mess_rec_all2,obj.plane_lon_result,obj.plane_lat_result,obj.plane_high_result]=satellite_simple_gui_main(planes,ftime,wx_lon,wx_lat,high1,speed1,hxj1,tx_num_edit,power1,txbs_width_edit);
            for i = 1:size(obj.plane_lon_result,1)
               if obj.plane_lon_result(i,1)>180
                  obj.plane_lon_path(i,:) = obj.plane_lon_result(i,:)-360;
               else
                 obj.plane_lon_path(i,:) = obj.plane_lon_result(i,:); 
               end
            end
           obj.plane_lat_path = 90-obj.plane_lat_result;
            set(obj.edt_echo, 'string', '�������');
            write_lat_data_2_file(obj.plane_lat_path);
            write_lon_data_2_file(obj.plane_lon_path);
        end
        
        
        % Callback function for button start.
        function result =button_start_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '׼�����С���ܷɻ�ADS-B�ź�ģ�����...');
            if check_wx_param(obj)==0
                 return;
            end
             %У�����ʱ������
            ftime = str2double(get(obj.plane_edt_times, 'string'));
            if is_err_time(ftime)
                set(obj.edt_echo, 'string', '����ʱ��������[0,60]�룬���������ã�');
                return
            end
             %���ǲ�����ȡ
            wx_lat = str2double(get(obj.wx_lat_edit, 'string'));
            wx_lat=90-wx_lat;%תΪ0-180
            wx_lon = str2double(get(obj.wx_lon_edit, 'string'));
            if wx_lon<0
               wx_lon=wx_lon+360;%תΪ0-360
            end
            wx_high = str2double(get(obj.wx_high_edit, 'string'));
            wx_power = str2double(get(obj.wx_tx_power_edit, 'string'));
            wx_hxj = str2double(get(obj.wx_hxj_edit, 'string'));
            wx_hxj=wx_hxj*pi/180;% ��Ϊpi����ʽ
            wx_speed = str2double(get(obj.wx_speed_edit, 'string'));
            tx_num_edit = str2double(get(obj.wx_tx_num_edit, 'string'));
            txbs_width_edit = str2double(get(obj.wx_txbs_width_edit, 'string'));
            
            % �û�����ķɻ�һ�Ĳ���
            lat1=str2double(get(obj.plane_edt_lat1, 'string'));
            lon1=str2double(get(obj.plane_edt_lon1, 'string'));
            high1=str2double(get(obj.plane_edt_alt1, 'string'));
            speed1=str2double(get(obj.plane_edt_vh1, 'string'));
            hxj1=str2double(get(obj.plane_edt_az1, 'string'));
            power1=str2double(get(obj.plane_edt_pw1, 'string'));
             % �û�����ķɻ����Ĳ���
            lat2=str2double(get(obj.plane_edt_lat2, 'string'));
            lon2=str2double(get(obj.plane_edt_lon2, 'string'));
            high2=str2double(get(obj.plane_edt_alt2, 'string'));
            speed2=str2double(get(obj.plane_edt_vh2, 'string'));
            hxj2=str2double(get(obj.plane_edt_az2, 'string'));
            power2=str2double(get(obj.plane_edt_pw2, 'string'));
             % �û�����ķɻ����Ĳ���
            lat3=str2double(get(obj.plane_edt_lat3, 'string'));
            lon3=str2double(get(obj.plane_edt_lon3, 'string'));
            high3=str2double(get(obj.plane_edt_alt3, 'string'));
            speed3=str2double(get(obj.plane_edt_vh3, 'string'));
            hxj3=str2double(get(obj.plane_edt_az3, 'string'));
            power3=str2double(get(obj.plane_edt_pw3, 'string'));
            % У��ɻ�1����
            if check_plane_1(obj,lon1,lat1,high1,speed1,hxj1,power1,'һ')==0
                return ;
            end
             lat1=90-lat1;
             if lon1<0
                 lon1=360+lon1;
             end
             hxj1=hxj1*pi/180;
             speed1 = speed1/3600;
             plane1 = createPlane(obj,lon1,lat1,high1,speed1,hxj1,power1);
             %�ɻ�2��Ϊ��,����ҪУ����������ҰѲ����ϲ����ɻ�1.2��
            if ~plane2isempty(obj)
                if check_plane_1(obj,lon2,lat2,high2,speed2,hxj2,power2,'��')==0
                    return ;
                else
                    lat2=90-lat2;
                     if lon2<0
                         lon2=360+lon2;
                     end
                    hxj2=hxj2*pi/180;
                    speed2=speed2/3600;
                    plane2 = createPlane(obj,lon2,lat2,high2,speed2,hxj2,power2);
                end
            end
            
            %�ɻ�3��Ϊ��,����ҪУ����������ҰѲ����ϲ����ɻ�1.2��
            if ~plane3isempty(obj)
                 if check_plane_1(obj,lon3,lat3,high3,speed3,hxj3,power3,'��')==0
                    return ;
                 else
                     lat3=90-lat3;
                     if lon3<0
                         lon3=360+lon3;
                     end
                    hxj3=hxj3*pi/180;
                    speed3=speed3/3600;
                    plane3 = createPlane(obj,lon3,lat3,high3,speed3,hxj3,power3);
                end
            end
            
            % ��װΪ����
            if ~plane2isempty(obj)&&~plane3isempty(obj)
                  planes=[plane1,plane2,plane3];
            elseif ~plane2isempty(obj) && plane3isempty(obj)
                  planes=[plane1,plane2];
            elseif plane2isempty(obj) && ~plane3isempty(obj)
                  planes=[plane1,plane3];
            else
                planes=plane1;
            end
            set(obj.edt_echo, 'string', '�������С���ܷɻ�ADS-B�ź�ģ�����...');
            pause(0.3);
            %����������
            [obj.mess_rec_all,obj.mess_rec_all1,obj.mess_rec_all2,obj.plane_lon_result,obj.plane_lat_result,obj.plane_high_result]=satellite_simple_gui_main(planes,ftime,wx_lon,wx_lat,wx_high,wx_speed,wx_hxj,tx_num_edit,wx_power,txbs_width_edit);
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
            set(obj.edt_echo, 'string', '����ܷɻ�ADS-B�ź�ģ�����������ϣ�');
        end
        
        % Callback function for exit button.
        function button_exit_callback(obj, source, eventdata)
            set(obj.edt_echo, 'string', '�˳�����...');
            pause(0.3);
            
            close(obj.gui_p);
            clear;
            clc;
        end
        
        
        % �жϷɻ����Ĳ����ǲ��Ƕ�Ϊ��
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
         % �жϷɻ����Ĳ����ǲ��Ƕ�Ϊ��
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
        
         % У��ɻ������ͷ���ʱ��
        function s= check_plane_num_times(obj)
            s=0;
            if isempty(get(obj.plane_num_edt, 'string'))
                set(obj.edt_echo, 'string', '��δ���÷ɻ��������������÷ɻ�������');
                return ;
            end
            
            if isempty(get(obj.plane_edt_times, 'string'))
                set(obj.edt_echo, 'string', '��δ���÷���ʱ�����������÷���ʱ����');
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
                set(obj.edt_echo, 'string', '���õķ���ʱ��������Χ��ӦΪ(0, 60]�����������ã�');
                return ;
            end
            s=1;
            return ;
        end
        
        % У��ɻ���6�������Ƿ���ȷ
        function s = check_plane_1(obj,lon1,lat1,high1,speed1,hxj1,power1,num)
            s=0;
            str =strcat('���õķɻ�',num);
            if is_err_lat(lat1)
                set(obj.edt_echo, 'string', strcat(str,'γ�ȶȳ�����Χ��ӦΪ[-90, 90]�����������ã�'));
                return;
            end
             if is_err_lon(lon1)
                set(obj.edt_echo, 'string', strcat(str,'���ȳ�����Χ��ӦΪ[-180, 180]�����������ã�'));
                return;
             end
             if is_err_high(high1)
                set(obj.edt_echo, 'string',  strcat(str,'�߶ȿղ㳬����Χ��ӦΪ[1, 12]�����������ã�'));
                return;
             end
             if is_err_speed(speed1)
                set(obj.edt_echo, 'string',  strcat(str,'�ٶȳ�����Χ��ӦΪ[800, 1000]�����������ã�'));
                return;
             end
             if is_err_hxj(hxj1)
                set(obj.edt_echo, 'string',  strcat(str,'����ǳ�����Χ��ӦΪ[0, 360]�����������ã�'));
                return;
             end
             if is_err_gl(power1)
                set(obj.edt_echo, 'string',  strcat(str,'���ʳ�����Χ��ӦΪ[0, 100]�����������ã�'));
                return;
             end
            s=1;
        end
        
          % У�����ǲ����Ƿ���ȷ
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
            if is_err_lat(lat1)
                set(obj.edt_echo, 'string', '����γ�ȶȳ�����Χ��ӦΪ[-90, 90]�����������ã�');
                return;
            end
            if is_err_lon(lon1)
                set(obj.edt_echo, 'string', '���Ǿ��ȳ�����Χ��ӦΪ[-180, 180]�����������ã�');
                return;
             end
             if isnan(high1)
                set(obj.edt_echo, 'string',  '���Ǹ߶ȱ���Ϊ���֣����������ã�');
                return;
             elseif high1<10||high1>100000
                set(obj.edt_echo, 'string',  '���Ǹ߶ȱ���Ϊ���֣����������ã�');
                return;
             end
            if isnan(speed1)
                set(obj.edt_echo, 'string',  '�����ٶȱ���Ϊ���֣����������ã�');
                return;
             elseif high1<0||high1>1000
                set(obj.edt_echo, 'string',  '�����ٶȱ���Ϊ���֣�ӦΪ[0, 1000]�����������ã�');
                return;
             end
             if is_err_hxj(hxj1)
                set(obj.edt_echo, 'string',  '���Ǻ���ǳ�����Χ��ӦΪ[0, 360]�����������ã�');
                return;
             end
             if is_err_gl(power1)
                set(obj.edt_echo, 'string',  '���ǹ��ʳ�����Χ��ӦΪ[0, 100]�����������ã�');
                return;
             end
             if isnan(tx_num_edit)
                set(obj.edt_echo, 'string',  '����������������Ϊ���֣����������ã�');
                return;
             elseif tx_num_edit<0||tx_num_edit>10
                set(obj.edt_echo, 'string',  '����������������Ϊ���֣�ӦΪ[0, 10]�����������ã�');
                return;
             end
             
             if isnan(txbs_width_edit)
                set(obj.edt_echo, 'string', '�������߲��ٿ�ȱ���Ϊ���֣����������ã�');
                return;
             elseif txbs_width_edit<0
                set(obj.edt_echo, 'string', '�������߲��ٿ�ȱ���Ϊ���������������ã�');
                return;
             end
             
            s=1;
        end
        
        
          % У���˹���Ĳ����Ƿ�Ϊ��
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
        
         % У���˹����2�����Ƿ�Ϊ��
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
        
        %�����ɻ�λ��
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