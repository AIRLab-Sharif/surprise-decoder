function Param = init_param(Modality, Sub, TaskNumber, learn_method, SurpriseMethod, Period, Model_Mode)
    %% Parameters of Data
    Param = struct();
    Param.Fs = 256;

    if nargin >= 1
        Param.Modality = Modality;

        switch (Modality)
            case 'MMEG'
                Param.N_Channel = 102;
                Param.Fs = 256;
            case 'GMEG'
                Param.N_Channel = 204;
                Param.Fs = 256;
            case 'GMEG2'
                Param.N_Channel = 102;
                Param.Fs = 256;
            case 'GMEG3'
                Param.N_Channel = 102;
                Param.Fs = 256;
            case 'MEG'
                Param.N_Channel = 306;
                Param.Fs = 256;
            case 'EEG34'
                Param.N_Channel = 34;
                Param.Fs = 1000;
            case 'EEG'
                Param.N_Channel = 34;
                Param.Fs = 1000;
            case 'EEGfMRI'
                Param.N_Channel = 34;
                Param.Fs = 1000;
            case 'EEG2'
                Param.N_Channel = 27; % 31
                Param.Fs = 512;
            otherwise
        end

    else
        Param.N_Channel = 102;
    end

    if nargin >= 2
        Param.Sub = Sub;
    end

    if nargin >= 3
        Param.TaskNumber = TaskNumber;
    end

    if nargin >= 4
        Param.learn_method = learn_method;
    end

    if nargin >= 5
        Param.SurpriseMethod = SurpriseMethod;
    end

    if nargin >= 6
        Param.Period = Period;
    end

    if nargin >= 7
        Param.Model_Mode = Model_Mode;
    else
        Param.Model_Mode = 'Periods';
    end

    if nargin >= 1
        Param.get_log_dir = fullfile('reports', sprintf('%s_%s', Param.Modality, Param.Model_Mode));
        Param.get_model_dir = fullfile('Output', sprintf('%s_%s', Param.Modality, Param.Model_Mode));
    end

    if nargin >= 4
        Param.get_save_file_name = @(filepath) sprintf('%s_%s_%s_Subject%02d_Task%d', ...
            get_filename(filepath), Param.Modality, Param.Model_Mode, Param.Sub, ...
            Param.TaskNumber);

        if nargin >= 6
            Param.get_save_file_name = @(filepath) sprintf('%s_%s_%s_Subject%02d_Task%d_%s_%s_%s', ...
                get_filename(filepath), Param.Modality, Param.Model_Mode, Param.Sub, ...
                Param.TaskNumber, Param.learn_method, Param.SurpriseMethod, Param.Period);
        end

    end

    if nargin >= 4
        Param.get_complete_check_file_name = @(filepath) sprintf('%s_%s_%s', ...
            get_filename(filepath), Param.Modality, Param.Model_Mode);
    end

    Param.w_Set = 2.^linspace(-1, 7, 17); %[0.5:0.5:3, 6:5:101];
    Param.ICA_flag = 1;
    Param.Filter_flag = 0;
    Param.Refrences = -round(0.25 * Param.Fs); % Param.Duration of refrence part before ERP
    Param.Duration = round(1 * Param.Fs); % Param.Duration of ERP

    Param.Target = struct();
    Param.Target.Fs = 100;
    Param.Target.Base = -round(0.2 * Param.Target.Fs);
    Param.Target.Duration = round(0.6 * Param.Target.Fs);

    Param.DownSamp = Param.Fs / Param.Target.Fs;
    Param.DownSampler = @(signal) interp1(...
        (Param.Refrences:Param.Duration) / Param.Fs, signal, ...
        (Param.Target.Base:Param.Target.Duration) / Param.Target.Fs, ...
        'spline' ...
        );

    Param.steps = struct();

    switch Modality
        case {'MEG', 'MMEG', 'GMEG', 'GMEG2', 'GMEG3'}
            % Param.steps.early = round(0 * Param.Target.Fs);
            % Param.steps.middle = round(0.07 * Param.Target.Fs);
            % Param.steps.late = round(0.2 * Param.Target.Fs);
            Param.steps.early = round(0 * Param.Target.Fs);
            Param.steps.middle = round(0.1 * Param.Target.Fs);
            Param.steps.late = round(0.25 * Param.Target.Fs);

            if nargin >= 5

                if SurpriseMethod == 'KL2'

                    if TaskNumber == 4
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.05 * Param.Target.Fs);
                        Param.steps.late = round(0.36 * Param.Target.Fs);
                    end

                elseif SurpriseMethod == 'LOG'

                    if TaskNumber == 4
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.06 * Param.Target.Fs);
                        Param.steps.late = round(0.35 * Param.Target.Fs);
                    end

                elseif SurpriseMethod == 'PUZ'

                    if TaskNumber == 4
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.06 * Param.Target.Fs);
                        Param.steps.late = round(0.38 * Param.Target.Fs);
                    end

                end

            end

        case {'EEGfMRI', 'EEG2'}

            Param.steps.early = round(0 * Param.Target.Fs);
            Param.steps.middle = round(0.1 * Param.Target.Fs);
            Param.steps.late = round(0.25 * Param.Target.Fs);

            if nargin >= 5

                if SurpriseMethod == 'KL2'

                    if TaskNumber == 1
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.09 * Param.Target.Fs);
                        Param.steps.late = round(0.32 * Param.Target.Fs);
                    elseif TaskNumber == 2
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.1 * Param.Target.Fs);
                        Param.steps.late = round(0.34 * Param.Target.Fs);
                    end

                elseif SurpriseMethod == 'LOG'

                    if TaskNumber == 1
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.09 * Param.Target.Fs);
                        Param.steps.late = round(0.32 * Param.Target.Fs);
                    elseif TaskNumber == 2
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.1 * Param.Target.Fs);
                        Param.steps.late = round(0.35 * Param.Target.Fs);
                    end

                elseif SurpriseMethod == 'PUZ'

                    if TaskNumber == 1
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.08 * Param.Target.Fs);
                        Param.steps.late = round(0.3 * Param.Target.Fs);
                    elseif TaskNumber == 2
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.11 * Param.Target.Fs);
                        Param.steps.late = round(0.34 * Param.Target.Fs);
                    end

                elseif SurpriseMethod == 'PUZ2'

                    if TaskNumber == 1
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.07 * Param.Target.Fs);
                        Param.steps.late = round(0.37 * Param.Target.Fs);
                    elseif TaskNumber == 2
                        Param.steps.early = round(0 * Param.Target.Fs);
                        Param.steps.middle = round(0.11 * Param.Target.Fs);
                        Param.steps.late = round(0.34 * Param.Target.Fs);
                    end

                end

            end

    end

    Param.steps.ind_all = 1 - Param.Target.Base + (Param.Target.Base:Param.Target.Duration);
    Param.steps.ind_signal = 1 - Param.Target.Base + (0:Param.Target.Duration);
    Param.steps.ind_baseline = 1 - Param.Target.Base + (Param.Target.Base:Param.steps.early);
    Param.steps.ind_early = 1 - Param.Target.Base + (Param.steps.early:Param.steps.middle);
    Param.steps.ind_middle = 1 - Param.Target.Base + (Param.steps.middle:Param.steps.late);
    Param.steps.ind_late = 1 - Param.Target.Base + (Param.steps.late:Param.Target.Duration);

    % Param.steps.get_ind_interval = @(time_point) 1 - Param.Target.Base + (Param.steps.Base:round(time_point * Param.Target.Fs));
    % Param.steps.get_ind_interval_no_baseline = @(time_point) 1 - Param.Target.Base + (0:round(time_point * Param.Target.Fs));
    % Param.steps.get_ind_sample = @(time_point) 1 - Param.Target.Base + (round(time_point * Param.Target.Fs));

    Param.steps.get_ind_interval = @(time_ind) 1:time_ind;
    Param.steps.get_ind_interval_no_baseline = @(time_ind) 1 - Param.Target.Base:time_ind;
    Param.steps.get_ind_sample = @(time_ind) time_ind;

    Param.ModelParam = struct();
    Param.ModelParam.K = 1;
    Param.ModelParam.K_CV = 5;
    Param.ModelParam.lambda_Set = logspace(0, -8, 20);
    % The following flags are not important. Let them be equal to 0
    Param.ModelParam.Test = 0;
    Param.ModelParam.Null = 0;
    Param.ModelParam.Motion = 0;
    Param.ModelParam.Dev = 0;
    Param.Null_test_tries = 20;

end

function filename = get_filename(filepath)
    [~, filename, ~] = fileparts(filepath);
end
