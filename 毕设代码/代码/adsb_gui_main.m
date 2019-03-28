classdef adsb_gui_main < handle
%% *********************************************************************
%
% @file         adsb_gui_main.m
% @brief        Class definition file for adsb_gui_main.
% 
% ******************************************************************************
 
    properties
        % Handle for this GUI.
        gui_p;
        % Title text for the GUI.
        txt_t;
        % Button for programme "ADS-B signal generator for 1-plane".
        btn_c1;
        % Handle for child GUI 1.
        gui_child_1;
        % Button for programme "ADS-B signal generator for more planes".
        btn_c2;
        % Handle for child GUI 2.
        gui_child_2;
        % Button for programme "ADS-B receiver sensitivity test".
        btn_c3;
        % Handle for child GUI 3.
        gui_child_3;
        % Button for programme "ADS-B signal interleaving test".
        btn_c4;
        % Handle for child GUI 4.
        gui_child_4;
        % Button for "Exit the programme".
        btn_c5;
        % The width of the screen.
        width;
        % The height of the screen.
        height;
        % The width of the GUI.
        gui_width;
        % The height of the GUI.
        gui_height;
        % The height of the press button.
        button_height;
        % The height of the space between buttons.
        space_height;
    end
    
    methods
        % Create figure and init the GUI.
        function obj = adsb_gui_main()
            % Obtain the size of the screen.
            screen_size = get(0, 'ScreenSize');
            screen_size(screen_size < 100) = [];
            obj.width  = screen_size(1);
            obj.height = screen_size(2);
            % Set the width and height of the GUI.
            obj.gui_width  = obj.width-60;
            obj.gui_height = obj.height - 100;
            % Set the height of the button and the space.
            obj.button_height = 70;
            obj.space_height  = floor((obj.gui_height - 6 * ...
                obj.button_height) / 7);
            
            % Create figure and set param.
            obj.gui_p = figure('Color', [0.83, 0.82, 0.78], ...
                'Numbertitle', 'off', 'Name', 'ADS-B信号源场景仿真模拟软件', ...
                'Position', [30, 30, obj.gui_width, obj.gui_height], ...
                'Toolbar', 'none', 'Resize', 'off');
            % Init the title of the figure.
            obj.txt_t = uicontrol('parent', obj.gui_p, ...
                'style', 'text', 'BackgroundColor', [0.83, 0.82, 0.78], ...
                'Fontsize', 25, 'string', 'ADS-B信号源场景仿真测试程序', ...
                'position', [obj.gui_width / 4, obj.gui_height - ...
                obj.button_height - obj.space_height, obj.gui_width / 2, ...
                obj.button_height]);
            % Init the button handle 1.
            obj.btn_c1 = uicontrol('parent', obj.gui_p, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '无卫星场景多飞行器仿真及ADS-B信号模拟程序', ...
                'Fontsize', 18, 'position', [obj.gui_width / 4, ...
                obj.gui_height - 2 * (obj.button_height + obj.space_height), ...
                obj.gui_width / 2, obj.button_height]);
            % Init the button handle 2.
            obj.btn_c2 = uicontrol('parent', obj.gui_p, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '无卫星场景随机分布飞行器仿真及ADS-B信号模拟程序', ...
                'Fontsize', 18, 'position', [obj.gui_width / 4, ...
                obj.gui_height - 3 * (obj.button_height + obj.space_height), ...
                obj.gui_width / 2, obj.button_height]);
            % Init the button handle 3.
            obj.btn_c3 = uicontrol('parent', obj.gui_p, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '有卫星高斯分布场景仿真及ADS-B信号模拟程序', ...
                'Fontsize', 18, 'position', [obj.gui_width / 4, ...
                obj.gui_height - 4 * (obj.button_height + obj.space_height), ...
                obj.gui_width / 2, obj.button_height]);
            % Init the button handle 4.
            obj.btn_c4 = uicontrol('parent', obj.gui_p, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '有卫星场景多飞行器场景仿真及ADS-B信号模拟程序', ...
                'Fontsize', 18, 'position', [obj.gui_width / 4, ...
                obj.gui_height - 5 * (obj.button_height + obj.space_height), ...
                obj.gui_width / 2, obj.button_height]);
            % Init the button handle 5.
            obj.btn_c5 = uicontrol('parent', obj.gui_p, ...
                'style', 'pushbutton', 'BackgroundColor', ...
                [0.83, 0.82, 0.78], 'string', '退出程序', ...
                'Fontsize', 18, 'position', [obj.gui_width / 4, ...
                obj.gui_height - 6 * (obj.button_height + obj.space_height), ...
                obj.gui_width / 2, obj.button_height]);
            
            % Mapping to the callback function of the button.
            button_mapping(obj);
        end
        
        % Callback function for button handle 1.
        function button_1_callback(obj, source, eventdata)
            obj.gui_child_1 = no_satellite_mul_plane_gui_start(obj);
        end
        
        % Callback function for button handle 2.
        function button_2_callback(obj, source, eventdata)
            obj.gui_child_2 = no_satellite_random_plane_gui_start(obj);
        end
        
        % Callback function for button handle 3.
        function button_3_callback(obj, source, eventdata)
            obj.gui_child_3 = satellite_goss_gui_start(obj);
        end
        
        % Callback function for button handle 4.
        function button_4_callback(obj, source, eventdata)
            obj.gui_child_4 = satellite_mul_plane_gui_start(obj);
        end
        
        % Callback function for button handle 5.
        function button_5_callback(obj, source, eventdata)
            clear;
            clc;
            close all;
        end
        
        % Callback mapping function.
        function button_mapping(obj)
            set(obj.btn_c1, 'callback', @obj.button_1_callback);
            set(obj.btn_c2, 'callback', @obj.button_2_callback);
            set(obj.btn_c3, 'callback', @obj.button_3_callback);
            set(obj.btn_c4, 'callback', @obj.button_4_callback);
            set(obj.btn_c5, 'callback', @obj.button_5_callback);
        end
        
    end
    
end