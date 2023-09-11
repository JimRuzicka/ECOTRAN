function ThorntonLessem_parameters = f_TLparameterization_05182023(temp_ref, temp_ref_std, ...
                                                                   looky_grpType1, looky_grpType2, looky_grpType3)
% Written by Caren Barceló

% Variables needed for physiology~temperature relationship with TL.
% The definitions of the eight Thornton-Lessem parameters:
%     (1)	te1     Temperature for xk1 (in �C),	= 1 for herring
%     (2)	te2     Temperature for xk2 (in �C),	= 13 for herring
%     (3)	te3     Temperature for xk3 (in �C),	= 15 for herring
%     (4)	te4     Temperature for xk4 (in �C),	= 23 for herring
%     (5)	xk1     Proportion of CMAX at te1,      = 0.01 for herring
%     (6)	xk2     Proportion of CMAX at te2,      = 0.98 for herring
%     (7)	xk3     Proportion of CMAX at te3,      = 0.98 for herring
%     (8)	xk4     Proportion of CMAX at te4,      = 0.01 for herring
%
% To add:
% 1) give group type definitions as a single vector of types
%   get a list of unique types
%   find each type internally to this code











% calls:
%   none
%
% takes:
%   ECOTRANphysics
%         temperature_timeseries	(2D matrix: num_t X num_boxes)
%         temperature_reference     (horizontal vector: 1 X num_boxes)
%         temperature_dates         (vertical vector: num_t X 1)
%         num_t
%         num_boxes
%
% returns:
%   TLparameters                      (3D matrix: num_t X num_grps X num_boxes)
%
% revision date: 5/18/2023 
%   
%% *************************************************************************
% STEP 1: 
% T-L set up based on reference temperatures during first part of time
% series (1980-2005)

% Mean depth specific domain wide temperature and STD
temp_ref        = mean(temp_ref, 3, 'omitnan');     % mean across domains; (horizontal vector: 1 X num_grps)   
temp_ref_std	= mean(temp_ref_std, 3, 'omitnan');	% mean across domains; (horizontal vector: 1 X num_grps)

% Calculate range of SD +/- around mean temperature
for ii = 1:1:10
    temp_ref_std_test       = temp_ref_std * ii;
    temp_ref_plus(ii, :)	= temp_ref + temp_ref_std_test;
    temp_ref_minus(ii, :)	= temp_ref - temp_ref_std_test;
end
% *************************************************************************



%% *************************************************************************
% STEP 2:
% Set up T-L parameter set based on above specified conditions
% First: Define targeted T-L set up for each group occupying each depth

% % % % randomization of ThLe SD - start with broadest (10 std at base for each)
% % % TLsizeBase_Type1    = 10;
% % % TLsizeTop_Type1     = 1;
% % % 
% % % TLsizeBase_Type2    = 10;
% % % TLsizeTop_Type2     = 1;
% % % 
% % % TLsizeBase_Type3    = 10;
% % % TLsizeTop_Type3     = 1;

% % % % Set up used in Barcelo et al. submitted to RPTS
% % % TLsizeBase_Type1 = 4;
% % % TLsizeTop_Type1 = 1;
% % % 
% % % TLsizeBase_Type2 = 4;
% % % TLsizeTop_Type2 = 1;
% % % 
% % % TLsizeBase_Type3 = 6;
% % % TLsizeTop_Type3 = 3;

% % 1sd less at base means
% TLsizeBase_Type1 = 3;
% TLsizeTop_Type1 = 1;
% 
% TLsizeBase_Type2 = 3;
% TLsizeTop_Type2 = 1;
% 
% TLsizeBase_Type3 = 5;
% TLsizeTop_Type3 = 3;


% 2sd less at base means
TLsizeBase_Type1 = 2;
TLsizeTop_Type1 = 1;

TLsizeBase_Type2 = 2;
TLsizeTop_Type2 = 1;

TLsizeBase_Type3 = 4;
TLsizeTop_Type3 = 3;


% % 3sd less at base means
% TLsizeBase_Type1 = 1;
% TLsizeTop_Type1 = 1;
% 
% TLsizeBase_Type2 = 1;
% TLsizeTop_Type2 = 1;
% 
% TLsizeBase_Type3 = 3;
% TLsizeTop_Type3 = 3;



% % 1std more at base means
% TLsizeBase_Type1 = 5;
% TLsizeTop_Type1 = 1;
% 
% TLsizeBase_Type2 = 5;
% TLsizeTop_Type2 = 1;
% 
% TLsizeBase_Type3 = 7;
% TLsizeTop_Type3 = 3;

% % 2sd more at base means
% TLsizeBase_Type1 = 6;
% TLsizeTop_Type1 = 1;
% 
% TLsizeBase_Type2 = 6;
% TLsizeTop_Type2 = 1;
% 
% TLsizeBase_Type3 = 8;
% TLsizeTop_Type3 = 3;

% % 3sd more at base means
% TLsizeBase_Type1 = 7;
% TLsizeTop_Type1 = 1;
% 
% TLsizeBase_Type2 = 7;
% TLsizeTop_Type2 = 1;
% 
% TLsizeBase_Type3 = 9;
% TLsizeTop_Type3 = 3;
% *************************************************************************



%% *************************************************************************
% Step 3: 
% Set all groups to 1SD at top and 4SD at bottom
ThorntonLessem_parameters                       = cat(1, ...
                                                        temp_ref_minus(TLsizeBase_Type1, :), ...
                                                        temp_ref_minus(TLsizeTop_Type1, :), ...
                                                        temp_ref_plus(TLsizeTop_Type1, :), ...
                                                        temp_ref_plus(TLsizeBase_Type1, :), ...
                                                        repelem(0.01, 106), ...
                                                        repelem(0.98,106), ...
                                                        repelem(0.98, 106), ...
                                                        repelem(0.01, 106));

% **If needed** assign group specific T-L curves, specify with these calls:
% SURFACE GROUPS: Broaden size of T-L curve to XXSD at top and XXSD at bottom for benthic groups (indexed by looky_grpType3)
ThorntonLessem_parameters(:, looky_grpType1)    = cat(1, ...
                                                        temp_ref_minus(TLsizeBase_Type1, looky_grpType1), ...
                                                        temp_ref_minus(TLsizeTop_Type1, looky_grpType1), ...
                                                        temp_ref_plus(TLsizeTop_Type1, looky_grpType1), ...
                                                        temp_ref_plus(TLsizeBase_Type1, looky_grpType1), ...
                                                        repelem(0.01, size(looky_grpType1, 2)), ...
                                                        repelem(0.98, size(looky_grpType1, 2)), ...
                                                        repelem(0.98, size(looky_grpType1, 2)), ...
                                                        repelem(0.01, size(looky_grpType1, 2)));

% MIDWATER GROUPS: Broaden size of T-L curve to XXSD at top and XXSD at bottom for benthic groups (indexed by looky_grpType3)
ThorntonLessem_parameters(:, looky_grpType2)    = cat(1, temp_ref_minus(TLsizeBase_Type2, looky_grpType2), ...
                                                        temp_ref_minus(TLsizeTop_Type2, looky_grpType2), ...
                                                        temp_ref_plus(TLsizeTop_Type2, looky_grpType2), ...
                                                        temp_ref_plus(TLsizeBase_Type2, looky_grpType2), ...
                                                        repelem(0.01, size(looky_grpType2, 2)), ...
                                                        repelem(0.98, size(looky_grpType2, 2)), ...
                                                        repelem(0.98, size(looky_grpType2, 2)), ...
                                                        repelem(0.01, size(looky_grpType2, 2)));

% BENTHIC GROUPS: Broaden size of T-L curve to XxSD at top and XXSD at bottom for benthic groups (indexed by looky_grpType3)
ThorntonLessem_parameters(:, looky_grpType3)    = cat(1, temp_ref_minus(TLsizeBase_Type3, looky_grpType3), ...
                                                        temp_ref_minus(TLsizeTop_Type3, looky_grpType3), ...
                                                        temp_ref_plus(TLsizeTop_Type3, looky_grpType3), ...
                                                        temp_ref_plus(TLsizeBase_Type3, looky_grpType3), ...
                                                        repelem(0.01, size(looky_grpType3, 2)), ...
                                                        repelem(0.98, size(looky_grpType3, 2)), ...
                                                        repelem(0.98, size(looky_grpType3, 2)), ...
                                                        repelem(0.01, size(looky_grpType3, 2)));

% ThLe *JUST* FOR FISH
ThorntonLessem_parameters(:, [1:20, 59:106])    = 1; % set non-fish groups to 1




%% Pacific herring TL parameters

% HERRING_ThorntonLessem_parameters(1)        = 1;    % te1; Temperature for xk1 (in ºC) 
% HERRING_ThorntonLessem_parameters(2)       = 13;   % te2; Temperature for xk2 (in ºC)
% HERRING_ThorntonLessem_parameters(3)       = 15;   % te3; Temperature for xk3 (in ºC) 
% HERRING_ThorntonLessem_parameters(4)       = 23;   % te4; Temperature for xk4 (in ºC)
% HERRING_ThorntonLessem_parameters(5)       = 0.01; % xk1; Proportion of CMAX at te1      
% HERRING_ThorntonLessem_parameters(6)       = 0.98; % xk2; Proportion of CMAX at te2      
% HERRING_ThorntonLessem_parameters(7)       = 0.98; % xk3; Proportion of CMAX at te3      
% HERRING_ThorntonLessem_parameters(8)        = 0.01; % xk4; Proportion of CMAX at te4   
% 
% CHUM_ThorntonLessem_parameters(1)        = 3;    % te1; Temperature for xk1 (in ºC) C
% CHUM_ThorntonLessem_parameters(2)       = 5;   % te2; Temperature for xk2 (in ºC)
% CHUM_ThorntonLessem_parameters(3)       = 10;   % te3; Temperature for xk3 (in ºC) 
% CHUM_ThorntonLessem_parameters(4)       = 12;   % te4; Temperature for xk4 (in ºC)
% CHUM_ThorntonLessem_parameters(5)       = 0.5; % xk1; Proportion of CMAX at te1      
% CHUM_ThorntonLessem_parameters(6)       = 0.98; % xk2; Proportion of CMAX at te2      
% CHUM_ThorntonLessem_parameters(7)       = 0.98; % xk3; Proportion of CMAX at te3      
% CHUM_ThorntonLessem_parameters(8)        = 0.5; % xk4; Proportion of CMAX at te4   

%% *************************************************************************

% figure;
% 
% subplot(3,1,1)
% histogram(temperature_timeseries(9126:25933,24,1:15),'Facecolor','red','Edgecolor','none'); % surface domain
% hold on
% histogram(temperature_timeseries(1:9125,24,1:15),'Facecolor','blue','Edgecolor','none'); % surface domain
% xline(mean(mean(temperature_timeseries(1:9125,24,1:15))),'blue','Linewidth',1); % bottom domain
% xline(mean(mean(temperature_timeseries(9126:25933,24,1:15))),'red','Linewidth',1); % bottom domain
% 
% % yyaxis right
% % plot(ThorntonLessem_parameters(1:4,24),ThorntonLessem_parameters(5:8,24),'k','Linewidth',1)
% 
% % yyaxis right
% % plot(HERRING_ThorntonLessem_parameters(1:4),HERRING_ThorntonLessem_parameters(5:8),'k-','Linewidth',2)
% % hold on
% % yyaxis right
% % plot(CHUM_ThorntonLessem_parameters(1:4),CHUM_ThorntonLessem_parameters(5:8),'k-','Linewidth',2)
% xlim([0 25])
% 
% title('Surface temperature (0-30m)')
% %title('Surface (TL set up: Top = 1SD, base = 4SD)')
% % yyaxis right
% % ylabel('Proportion of Cmax')
% yyaxis left
% ylabel('Frequency')
% xlabel('Temperature (°C)')
% ax = gca;
% ax.YAxis(1).Color = 'k';
% ax.YAxis(2).Color = 'k';
% 
% legend('Projection (2006-2050)','Historical (1980-2005)')
% 
% subplot(3,1,2)
% histogram(temperature_timeseries(9126:end,44,16:45),'FaceColor','red','EdgeColor','none'); % mid domain
% hold on
% histogram(temperature_timeseries(1:9125,44,16:45),'FaceColor','blue','EdgeColor','none'); % mid domain
% xline(mean(mean(temperature_timeseries(1:9125,44,16:45))),'blue','Linewidth',1); % bottom domain
% xline(mean(mean(temperature_timeseries(9126:end,44,16:45))),'red','Linewidth',1); % bottom domain
% 
% % yyaxis right
% % plot(ThorntonLessem_parameters(1:4,44),ThorntonLessem_parameters(5:8,44),'k','Linewidth',1)
% % hold on
% % yyaxis right
% % plot(ThorntonLessem_parameters(1:4,44),ThorntonLessem_parameters(5:8,44),'k--','Linewidth',1)
% xlim([0 25])
% title('Midwater temperature (>30-200m)')
% %title('Midwater (TL set up: Top = 2SD, base = 4SD)')
% % yyaxis right
% % ylabel('Proportion of Cmax')
% yyaxis left
% ylabel('Frequency')
% xlabel('Temperature (°C)')
% ax = gca;
% ax.YAxis(1).Color = 'k';
% ax.YAxis(2).Color = 'k';
% 
% subplot(3,1,3)
% histogram(temperature_timeseries(9126:end,53,46:60),'FaceColor','red','EdgeColor','none'); % mid domain
% hold on
% histogram(temperature_timeseries(1:9125,53,46:60),'FaceColor','blue','EdgeColor','none'); % bottom domain
% xline(mean(mean(temperature_timeseries(1:9125,53,46:60))),'blue','Linewidth',1); % bottom domain
% xline(mean(mean(temperature_timeseries(9126:end,53,46:60))),'red','Linewidth',1); % bottom domain
% 
% % yyaxis right
% % plot(ThorntonLessem_parameters(1:4,53),ThorntonLessem_parameters(5:8,53),'k','Linewidth',1)
% % hold on
% % yyaxis right
% % plot(ThorntonLessem_parameters(1:4,53),ThorntonLessem_parameters(5:8,53),'k--','Linewidth',1)
% xlim([0 25])
% %title('Bottom temperature (>200m)')
% title('Bottom (TL set up: Top = 3SD, base = 6SD)')
% % yyaxis right
% % ylabel('Proportion of Cmax')
% yyaxis left
% ylabel('Frequency')
% xlabel('Temperature (°C)')
% ax = gca;
% ax.YAxis(1).Color = 'k';
% ax.YAxis(2).Color = 'k';

%% 
% For bottom boxes - to explain bimodal patterning
% significant inshore offshore gradient in temperatures
% figure;
% histogram(temperature_timeseries(1:9125,53,[46,49,52,55,58]),'FaceColor','blue','EdgeColor','none'); % inshore domain
% hold on
% histogram(temperature_timeseries(1:9125,53,[47,50,53,56,59]),'FaceColor','green','EdgeColor','none'); % midshelf domain
% hold on
% histogram(temperature_timeseries(1:9125,53,[48,51,54,57,60]),'FaceColor','red','EdgeColor','none'); % offshore domain
% title('Bottom Temperature')
% ylabel('Frequency')
% xlabel('Temperature (°C)')
% ax = gca;
% ax.YAxis(1).Color = 'k';
% 
% legend('Inshore','Midshelf','Offshore')

end