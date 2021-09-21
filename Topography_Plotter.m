%% Clear memory

clc
clear
close all

%% Path setting

addpath(fullfile('Matlab_Libs',  'initialize'))
addpath(fullfile('Matlab_Libs',  'functions'))
addpath(fullfile('Matlab_Libs',  'scripts'))
addpath(fullfile('Matlab_Libs',  'model'))
addpath(fullfile('Matlab_Libs',  'fieldtrip-20200409'));

filepath = mfilename('fullpath');

%% Parallel Run Setting

Parallel_init;

%% Initialize

Initialize_lists;

for Model_Mode = Model_Mode_list

    ICA_flag = ~startsWith(Model_Mode,  "Channels");

    %% Start Decoding model
    for Sub = Subjects_list

        for learn_method = Learn_methods_list

            for TaskNumber = Tasks_list

                % Param = init_param(Modality);
                Param = init_param(Modality, Sub, TaskNumber, learn_method);

                logfile = getlogfile(Param.get_log_dir, Param.get_save_file_name(filepath));
                fprintf(logfile,  'Start Decoding model for %-60s\n', replace(Param.get_save_file_name(filepath),  '_',  ' '));

                fprintf('*** %-60s started! ***\n', replace(Param.get_save_file_name(filepath),  '_',  ' '));

                ica = load(fullfile('Processed_Data',  'ICA_Matrices', sprintf('ICA_%s', Param.Modality), ...
                    sprintf('%s_ICA_Subject%02d_Task%d.mat', Param.Modality, Param.Sub, Param.TaskNumber)));
                ica_weights = permute(ica.data.weights, [3, 2, 1]);
                ica_weights = cat(2, ica_weights, zeros(1, 2, size(ica_weights, 3)));

                cfg = [];
                % cfg.xlim = [0.3 0.5];
                % cfg.zlim = [0 6e-14];
                cfg.layout =  'neuromag306mag.lay';
                cfg.parameter =  'individual'; % the default (avg) is not present%set to average to show the average of subjects

                A = struct;
                A.fsample = 1;
                A.dimord =  'subj_chan_time';
                A.time = 0; %(0:300)/300;
                A.individual = ica_weights;
                A.avg = mean(ica_weights, 1); % find the average over subjects
                % A.var = var(ica_weights, 1);

                A.label = {
                'MEG0111',  'MEG0121',  'MEG0131',  'MEG0141',  'MEG0211',  'MEG0221',  'MEG0231',  'MEG0241',  'MEG0311', ...
                    'MEG0321',  'MEG0331',  'MEG0341',  'MEG0411',  'MEG0421',  'MEG0431',  'MEG0441',  'MEG0511',  'MEG0521', ...
                    'MEG0531',  'MEG0541',  'MEG0611',  'MEG0621',  'MEG0631',  'MEG0641',  'MEG0711',  'MEG0721',  'MEG0731', ...
                    'MEG0741',  'MEG0811',  'MEG0821',  'MEG0911',  'MEG0921',  'MEG0931',  'MEG0941',  'MEG1011',  'MEG1021', ...
                    'MEG1031',  'MEG1041',  'MEG1111',  'MEG1121',  'MEG1131',  'MEG1141',  'MEG1211',  'MEG1221',  'MEG1231', ...
                    'MEG1241',  'MEG1311',  'MEG1321',  'MEG1331',  'MEG1341',  'MEG1411',  'MEG1421',  'MEG1431',  'MEG1441', ...
                    'MEG1511',  'MEG1521',  'MEG1531',  'MEG1541',  'MEG1611',  'MEG1621',  'MEG1631',  'MEG1641',  'MEG1711', ...
                    'MEG1721',  'MEG1731',  'MEG1741',  'MEG1811',  'MEG1821',  'MEG1831',  'MEG1841',  'MEG1911',  'MEG1921', ...
                    'MEG1931',  'MEG1941',  'MEG2011',  'MEG2021',  'MEG2031',  'MEG2041',  'MEG2111',  'MEG2121',  'MEG2131', ...
                    'MEG2141',  'MEG2211',  'MEG2221',  'MEG2231',  'MEG2241',  'MEG2311',  'MEG2321',  'MEG2331',  'MEG2341', ...
                    'MEG2411',  'MEG2421',  'MEG2431',  'MEG2441',  'MEG2511',  'MEG2521',  'MEG2531',  'MEG2541',  'MEG2611', ...
                    'MEG2621',  'MEG2631',  'MEG2641',  'COMNT',  'SCALE', ...
                    };

                Tries_list = 1:size(ica_weights, 3);
                A.time = Tries_list / A.fsample;

                for tries = Tries_list

                    cfg.xlim = [tries - 0.5, tries + 0.5] / A.fsample;

                    f = figure('visible',  'off');
                    ft_topoplotER(cfg, A); colorbar
                    title(sprintf('ICA %s Subject%02d Task%d IC%02d', Param.Modality, Param.Sub, Param.TaskNumber, tries))
                    checkdir(fullfile('plots',  'ICA', Param.Modality));
                    saveas(f, fullfile('plots',  'ICA', Param.Modality, ...
                        sprintf('ICA_%s_Subject%02d_Task%d_IC%02d', Param.Modality, Param.Sub, Param.TaskNumber, tries)),  'fig')
                    saveas(f, fullfile('plots',  'ICA', Param.Modality, ...
                        sprintf('ICA_%s_Subject%02d_Task%d_IC%02d', Param.Modality, Param.Sub, Param.TaskNumber, tries)),  'png')
                    % pause()
                    close(f)

                end

                fprintf(logfile,  '\n\n\nCompleted!\n');
                fclose(logfile);

            end

        end

    end

end

%%
% cfg = [];
% % cfg.xlim = [0.3 0.5];
% % cfg.zlim = [0 6e-14];
% cfg.layout =  'neuromag306mag.lay';
% cfg.parameter =  'avg'; % the default (avg) is not present%set to average to show the average of subjects
%
% % figure; ft_topoplotER(cfg,GA_FC); colorbar
% seg =  'late'; %'early','middle',  'late'
% sur =  'PUZ'; %'LOG','KL2',  'PUZ'
% nchan = 102;
% nsub = 18;
% r2 = zeros(nsub, nchan + 2); % plus 2 is because there are 104 labels for 102 magnetometers system
%
% A = GA_FC;
% A = rmfield(A,  'cfg');
% A = rmfield(A,  'grad');
% % A = rmfield(A,'avg');
% % A = rmfield(A,'var');
% % A.time = 0; %(0:300)/300;
% % A.individual = r2;
% % A.avg = mean(r2, 1); % find the average over subjects
% % A.var = var(r2, 1);
%
% A.label = {
% 'MEG0111',  'MEG0121',  'MEG0131',  'MEG0141',  'MEG0211',  'MEG0221',  'MEG0231',  'MEG0241',  'MEG0311', ...
%     'MEG0321',  'MEG0331',  'MEG0341',  'MEG0411',  'MEG0421',  'MEG0431',  'MEG0441',  'MEG0511',  'MEG0521', ...
%     'MEG0531',  'MEG0541',  'MEG0611',  'MEG0621',  'MEG0631',  'MEG0641',  'MEG0711',  'MEG0721',  'MEG0731', ...
%     'MEG0741',  'MEG0811',  'MEG0821',  'MEG0911',  'MEG0921',  'MEG0931',  'MEG0941',  'MEG1011',  'MEG1021', ...
%     'MEG1031',  'MEG1041',  'MEG1111',  'MEG1121',  'MEG1131',  'MEG1141',  'MEG1211',  'MEG1221',  'MEG1231', ...
%     'MEG1241',  'MEG1311',  'MEG1321',  'MEG1331',  'MEG1341',  'MEG1411',  'MEG1421',  'MEG1431',  'MEG1441', ...
%     'MEG1511',  'MEG1521',  'MEG1531',  'MEG1541',  'MEG1611',  'MEG1621',  'MEG1631',  'MEG1641',  'MEG1711', ...
%     'MEG1721',  'MEG1731',  'MEG1741',  'MEG1811',  'MEG1821',  'MEG1831',  'MEG1841',  'MEG1911',  'MEG1921', ...
%     'MEG1931',  'MEG1941',  'MEG2011',  'MEG2021',  'MEG2031',  'MEG2041',  'MEG2111',  'MEG2121',  'MEG2131', ...
%     'MEG2141',  'MEG2211',  'MEG2221',  'MEG2231',  'MEG2241',  'MEG2311',  'MEG2321',  'MEG2331',  'MEG2341', ...
%     'MEG2411',  'MEG2421',  'MEG2431',  'MEG2441',  'MEG2511',  'MEG2521',  'MEG2531',  'MEG2541',  'MEG2611', ...
%     'MEG2621',  'MEG2631',  'MEG2641',  'COMNT',  'SCALE', ...
%     };
% 
% clc
% cfg = [];
% cfg.xlim = [0.3 0.5];
% cfg.zlim = [0 6e-14];
% cfg.layout =  'CTF151.lay';
% cfg.parameter =  'individual'; % the default 'avg' is not present in the data
% figure; ft_topoplotER(cfg, GA_FC); colorbar

% figure; ft_topoplotER(cfg, A); colorbar
