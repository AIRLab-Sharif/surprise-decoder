function x = get_inputs(signals, Param, B_ICA)

    N_Trial = size(signals, 1); % Number of trials

    x = zeros(N_Trial, Param.N_Channel, ...
        Param.Target.Duration - Param.Target.Base + 1);

    sigs = zeros(size(signals));

    %% ICA Applying:
    if Param.ICA_flag == 1
        sigs = zeros(size(signals, 1), size(B_ICA, 1), size(signals, 3));
        x = zeros(N_Trial, size(B_ICA, 1), ...
            Param.Target.Duration - Param.Target.Base + 1);

        for i = 1:N_Trial
            sigs(i, :, :) = (B_ICA * squeeze(signals(i, :, :)));
        end

    end

    %% Down sample
    for i = 1:N_Trial

        for j = 1:size(sigs, 2)
            x(i, j, :) = Param.DownSampler(squeeze(sigs(i, j, :)));
        end

    end

end
