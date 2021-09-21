%% Clear memory

clc
clear
close all

%% Path setting

addpath(fullfile('Matlab_Libs', 'initialize'))
addpath(fullfile('Matlab_Libs', 'functions'))
addpath(fullfile('Matlab_Libs', 'scripts'))
addpath(fullfile('Matlab_Libs', 'model'))

filepath = mfilename('fullpath');

%% Parallel Run Setting

% Parallel_init;

%% Initialize

Initialize_lists;

for Model_Mode = Model_Mode_list

    ICA_flag = ~startsWith(Model_Mode, "Channels");

    %% Start Decoding model
    for Sub = Subjects_list

        for learn_method = Learn_methods_list

            for TaskNumber = Tasks_list

                Load_Data_and_ICA;

                for SurpriseMethod = SurpriseMethods_list

                    switch Model_Mode
                        case 'Periods'
                            Periods_list = ["all", "late", "middle", "early", "signal"];
                            Tries_list = 1:20;
                        otherwise
                            Periods_list = ["all", "late", "middle", "early", "signal"];
                            Tries_list = 1:20;
                    end

                    for Period = Periods_list

                        Log_and_Init_Models_list;

                        Param.ModelParam.Null = 1;

                        %% x interval:
                        X = get_x_period(x, Param, 1);

                        %% Load Best Param
                        decoding_model_path = fullfile(Param.get_model_dir, ...
                            sprintf('%s.mat', Param.get_save_file_name('Run_Model')));

                        if exist(decoding_model_path, 'file') == 0
                            fprintf(logfile, '\n\n\nDecoding Model File Not Found!\n');
                            fclose(logfile);
                            continue
                        end

                        decoding_model_saved = load(decoding_model_path);
                        [~, ind] = max(decoding_model_saved.data.Model_Rs.R_CV);
                        Param.w_Set = Param.w_Set(ind);

                        for tries = Tries_list

                            Try_Lasso_and_Add;

                        end

                        Save_and_Close;

                    end

                end

            end

        end

    end

end
