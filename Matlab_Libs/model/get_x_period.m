function X = get_x_period(x, Param, sample_time)

    %% Get period
    switch (Param.Period)
        case 'interval'
            X = x(:, :, Param.steps.get_ind_interval(sample_time)); % Extracting -200 to sample time ms of each trial
        case 'interval_no_baseline'
            X = x(:, :, Param.steps.get_ind_interval_no_baseline(sample_time)); % Extracting 0 to sample time ms of each trial
        case 'sample'
            X = x(:, :, Param.steps.get_ind_sample(sample_time)); % Extracting sample time ms of each trial
        case 'baseline'
            X = x(:, :, Param.steps.ind_baseline); % Extracting -200 to 0ms of each trial - also considering the baseline
        case 'early'
            X = x(:, :, Param.steps.ind_early); % Extracting 0 to 100ms of each trial - also considering the baseline
        case 'middle'
            X = x(:, :, Param.steps.ind_middle); % Extracting 100 to 250ms of each trial - also considering the baseline
        case 'late'
            X = x(:, :, Param.steps.ind_late); % Extracting 250 to 600ms of each trial - also considering the baseline
        case 'signal'
            X = x(:, :, Param.steps.ind_signal); % Extracting 0 to 600ms of each trial
        case 'all'
            X = x(:, :, Param.steps.ind_all); % Extracting -200 to 600ms of each trial - also considering the baseline
        case 'Cbaseline'
            channel_number = sample_time;
            X = x(:, channel_number, Param.steps.ind_baseline); % Extracting -200 to 0ms of each trial - also considering the baseline
        case 'Cearly'
            channel_number = sample_time;
            X = x(:, channel_number, Param.steps.ind_early); % Extracting 0 to 100ms of each trial - also considering the baseline
        case 'Cmiddle'
            channel_number = sample_time;
            X = x(:, channel_number, Param.steps.ind_middle); % Extracting 100 to 250ms of each trial - also considering the baseline
        case 'Clate'
            channel_number = sample_time;
            X = x(:, channel_number, Param.steps.ind_late); % Extracting 250 to 600ms of each trial - also considering the baseline
        case 'Csignal'
            channel_number = sample_time;
            X = x(:, channel_number, Param.steps.ind_signal); % Extracting 0 to 600ms of each trial
        case 'Call'
            channel_number = sample_time;
            X = x(:, channel_number, Param.steps.ind_all); % Extracting -200 to 600ms of each trial - also considering the baseline
        case 'Channel'
            channel_number = sample_time;
            X = x(:, channel_number, Param.steps.ind_all);
        case 'IC'
            channel_number = sample_time;
            X = x(:, channel_number, Param.steps.ind_all);
        otherwise
            X = x(:, :, Param.steps.ind_all); % Extracting -200 to 600ms of each trial - also considering the baseline
    end

    X = reshape(permute(X, [1, 3, 2]), size(X, 1), []);

end
