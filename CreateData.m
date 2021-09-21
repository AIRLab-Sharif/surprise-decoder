%% Clear memory

clc
clear
close all

%% Path setting

addpath(fullfile('Matlab_Libs', 'scripts'))
addpath(fullfile('Matlab_Libs', 'initialize'))
addpath(fullfile('Matlab_Libs', 'functions'))
addpath(fullfile('Matlab_Libs', 'rawdata'))
addpath(fullfile('Matlab_Libs', 'preprocess'))

filepath = mfilename('fullpath');

%% Parallel Run Setting

Parallel_init;

%% Create Dataset Code for Subject 1 to 18 on MEG Dataset

% "Block" (TaskNumber) refers to the experimental conditions (counter-balanced order across subjects):\
%     - Block 1 (repetition-biased):  p(A|B) = 1/3, p(B|A) = 1/3;\
%     - Block 2 (fully stochastic):   p(A|B) = 1/2, p(B|A) = 1/2;\
%     - Block 3 (alternation-biased): p(A|B) = 2/3, p(B|A) = 2/3;\
%     - Block 4 (frequency-biased):   p(A|B) = 1/3, p(B|A) = 2/3.

%% Initialize

Initialize_lists;

% Modality = 'MEG';

%% Start Decoding model
for Sub = Subjects_list

    for learn_method = Learn_methods_list

        for TaskNumber = Tasks_list
            
            Param = init_param(Modality, Sub, TaskNumber, learn_method);

            logfile = getlogfile(Param.get_log_dir, sprintf('Sub%02d_Task%d', Sub, TaskNumber));
            fprintf(logfile, 'Create Dataset started for Sub%02d_Task%d learn method = %s \n', Sub, TaskNumber, learn_method);
            fprintf(logfile, 'Create Dataset started for Sub%02d_Task%d learn method = %s', Sub, TaskNumber, learn_method);

            switch Modality
                case {'MEG', 'MMEG', 'GMEG', 'GMEG2', 'GMEG3'}
                    [X, Seq, seqidx] = readMEG(Sub, TaskNumber);
                case 'EEG2'
                    [X, Seq, seqidx] = readEEG2(Sub, TaskNumber, 1);
                case 'EEGfMRI'
                    [X, Seq, seqidx] = readEEG(Sub, TaskNumber, 1);
            end

            Param = init_param(Modality, Sub, TaskNumber, learn_method);
            Output = get_meyniel(Seq, Param, seqidx);

            data = struct();
            data.Param = Param;
            data.Output = Output;
            data.X = X;
            data.Seq = Seq;
            data.seqidx = seqidx;

            parsave(...
                fullfile('Processed_Data', sprintf('%s_surprise', Modality)), ...
                sprintf('%s_surprise_Subject%02d_Task%d_%s.mat', ...
                Modality, Sub, TaskNumber, learn_method), ...
                data)

            fprintf(logfile, '\n\n\nCompleted!\n');
            fclose(logfile);

        end

    end

end
