%% Clear memory

clc
clear
close all

%% Path setting

addpath(fullfile('Matlab_Libs', 'initialize'))
addpath(fullfile('Matlab_Libs', 'scripts'))
addpath(fullfile('Matlab_Libs', 'functions'))
addpath(fullfile('Matlab_Libs', 'rawdata'))
addpath(fullfile('Matlab_Libs', 'FastICA_25'))
addpath(fullfile('Matlab_Libs', 'preprocess'))

filepath = mfilename('fullpath');

%% Parallel Run Setting

Parallel_init;

%% ICA Code for Subject 1 to 18 on MEG Dataset

% "Block" (TaskNumber) refers to the experimental conditions (counter-balanced order across subjects):\
%     - Block 1 (repetition-biased):  p(A|B) = 1/3, p(B|A) = 1/3;\
%     - Block 2 (fully stochastic):   p(A|B) = 1/2, p(B|A) = 1/2;\
%     - Block 3 (alternation-biased): p(A|B) = 2/3, p(B|A) = 2/3;\
%     - Block 4 (frequency-biased):   p(A|B) = 1/3, p(B|A) = 2/3.

%% Initialize

Initialize_lists;

parfor Sub = Subjects_list

    for TaskNumber = Tasks_list

%         logfile = getlogfile(Param.get_log_dir, sprintf('Sub%02d_Task%d', Sub, TaskNumber));
%         fprintf(logfile, 'Create Dataset started for Sub%02d_Task%d learn method = %s \n', Sub, TaskNumber, learn_method);
%         fprintf(logfile, 'Create Dataset started for Sub%02d_Task%d learn method = %s', Sub, TaskNumber, learn_method);

        logfile = getlogfile(filepath, sprintf('Sub%02d_Task%d', Sub, TaskNumber));
        fprintf(logfile, 'ICA started for Sub%02d_Task%d', Sub, TaskNumber);

        switch Modality
            case {'MEG', 'MMEG', 'GMEG', 'GMEG2', 'GMEG3'}
                % Modality = MEG;
                [X, ~, ~] = readMEG(Sub, TaskNumber);
                X_mean = repmat(mean(X, 3), [1 1 321]);
                X = X - X_mean;
                A = reshape(permute(X, [2, 3, 1]), size(X, 2), []);
                A = A / max(max(abs(A)));
                [sphere, weights] = fastica(A);

            case 'EEG2'
                [X, ~, ~, A] = readEEG2(Sub, TaskNumber);
                A = A - mean(A, 2);
                A = A / max(max(abs(A)));
                [weights, sphere] = runica(A);
                
            case 'EEGfMRI'
                [X, ~, ~, A] = readEEG(Sub, TaskNumber);
                A = A - mean(A, 2);
                A = A / max(max(abs(A)));
                [weights, sphere] = runica(A);
                
            

        end

        % [weights, sphere] = runica(A);
        % [sphere, weights] = fastica(A);
        %weights = eye(size(A));
        %sphere = eye(size(A));

        data = struct();
        data.weights = weights;
        data.sphere = sphere;

        parsave(...
            fullfile('Processed_Data', 'ICA_Matrices', sprintf('ICA_%s', Modality)), ...
            sprintf('%s_ICA_Subject%02d_Task%d.mat', Modality, Sub, TaskNumber), ...
            data ...
            )

        fprintf(logfile, '\n\n\nCompleted!\n');
        fclose(logfile);

    end

end
