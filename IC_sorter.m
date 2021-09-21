%% Clear memory

clc
clear
close all

%% Path setting

% addpath(fullfile('Matlab_Libs', 'initialize'))
% addpath(fullfile('Matlab_Libs', 'functions'))
addpath(fullfile('Matlab_Libs', 'scripts'))
% addpath(fullfile('Matlab_Libs', 'model'))

%% Initialize

Initialize_lists;

IC_R2 = zeros(numel(Subjects_list), numel(Learn_methods_list), numel(Tasks_list), numel(SurpriseMethods_list), 26);

for Model_Mode = ["MMEG_IC"]

    for Sub = Subjects_list

        for learn_method = Learn_methods_list

            for TaskNumber = Tasks_list

                for SurpriseMethod = SurpriseMethods_list

                    if ispc
                        data = load(fullfile('H:\\Decoder\\MEG_Dataset\\Output\\MMEG_IC', ...
                            sprintf('Run_Model_%s_Subject%02d_Task%d_%s_%s_IC.mat', Model_Mode, Sub, TaskNumber, learn_method, SurpriseMethod)));
                    else
                        data = load(fullfile('Output/MMEG_IC', ...
                            sprintf('Run_Model_%s_Subject%02d_Task%d_%s_%s_IC.mat', Model_Mode, Sub, TaskNumber, learn_method, SurpriseMethod))); end

                        IC_R2(Sub, learn_method == Learn_methods_list, TaskNumber, SurpriseMethod == SurpriseMethods_list, :) = data.data.Model_Rs.R_CV;
                    end

                end

            end

        end

    end
