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

%Parallel_init;

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

                    Periods_Model_mode; 

                    for Period = Periods_list

                        Log_and_Init_Models_list;

                        [~, check] = getcompletedata(filepath, Param);
                        if check == 1
                            continue
                        end

                        %% Lasso:
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
