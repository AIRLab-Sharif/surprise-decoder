function [EEG, Seq, seqidx, All_data] = readEEG(SubjectNum, TaskNumber, filter)
    %{
    Inputs:
    Subject Number
    Task Number
    Outut:
    EEG:Matrix of all runs of the task for that subject
    Seq:indeces and kinds of stimuli
    Dev:indeces of deviants and the number of standards before each one
    StaInd:indeces of standards

    %}

    if ispc
        BasePath = fullfile('D:', 'DS', sprintf('sub%03d', SubjectNum), 'EEG');
    else
        BasePath = fullfile('..', '..', 'DS', 'EEG_fMRI', sprintf('sub%03d', SubjectNum), 'EEG');
    end

    EEG = cell(1, 3);
    Seq = cell(1, 3);
    seqidx = cell(1, 3);
    EvokPot = cell(1, 3);
    good_list_ind = cell(1, 3);

    for runnumber = 1:3
        % fprintf('%d %d %d\n', SubjectNum, TaskNumber, RunNumber)
        EEG_data = load(fullfile(BasePath, sprintf('task%03d_run%03d', TaskNumber, runnumber), 'EEG_rereferenced.mat'));
        temp = EEG_data.data_reref;
        EEG{runnumber} = temp;
        [start_ind, seq_run, ~, ~] = seqdiscovery(temp(36, :), TaskNumber - 1);

        EEG35to37 = temp(35:37, :);
        R = response_extracter(start_ind, EEG35to37);
        Seq{runnumber} = [seq_run; runnumber * ones(1, size(seq_run, 2)); R'];
        seqidx{runnumber} = (1:size(seq_run, 2));

        %% Filter Design:
        if nargin > 2 && filter == 1
            % tic
            Param = struct;
            Param.Fs = 1000;
            Param.LowFreq = 0.5;
            Param.LowFreq = 0.5;
            Param.HighFreq = 38;
            Param.L = 501;
            h = BPF(Param.L, Param.LowFreq, Param.HighFreq, Param.Fs);
            EEG{runnumber} = FilterDFT(EEG{runnumber}(1:34, :)', h)';
            % toc
        end

        % splitting EEG trials
        N_Trial = size(start_ind, 1); % Number of trials

        % Extracting all of the trials:
        Param.Refrences = 250;
        Param.Duration = 1000;
        Param.N_Channel = 34;

        EvokPot{runnumber} = zeros(N_Trial, Param.N_Channel, Param.Refrences + Param.Duration + 1);

        for j = 1:N_Trial
            EvokPot{runnumber}(j, :, :) = EEG{runnumber}(1:Param.N_Channel, start_ind(j) + ((-Param.Refrences):Param.Duration));

            RefVolt = mean(EvokPot{runnumber}(j, :, 1:Param.Refrences), 3); % Reference Voltage
            EvokPot{runnumber}(j, :, :) = ...
                EvokPot{runnumber}(j, :, :) - repmat(RefVolt, 1, 1, Param.Refrences + Param.Duration + 1);
        end

        good_list_ind{runnumber} = error_and_artifact_removal(Seq{runnumber}, EvokPot{runnumber});

    end

    if nargout >= 4
        All_data = [EEG{1}(1:34, :), EEG{2}(1:34, :), EEG{3}(1:34, :)];
    end

    EEG = cat(1, EvokPot{1}(good_list_ind{1}, :, :), EvokPot{2}(good_list_ind{2}, :, :), EvokPot{3}(good_list_ind{3}, :, :));
    Seq = [Seq{1}, Seq{2}, Seq{3}];
    seqidx = [...
            seqidx{1}(good_list_ind{1}), ...
            seqidx{2}(good_list_ind{2}) + seqidx{1}(end), ...
            seqidx{3}(good_list_ind{3}) + seqidx{1}(end) + seqidx{2}(end)
        ];

end
