function [EEG, Seq, seqidx, All_data] = readEEGfMRI(SubjectNum, TaskNumber, filter)

    for RunNumber = 1:3

        if ispc
            Path = string(fullfile('D:', 'DS', sprintf('sub%03d', SubjectNum), 'EEG', ...
                sprintf('task%03d_run%03d', TaskNumber, RunNumber), 'EEG_rereferenced.mat'));
        else
            Path = fullfile('..', '..', 'EEG2', sprintf('S%02d', SubjectNum));
        end

        EEG_data = load(Path);
        EEG_data.data_reref
        EEG_data.data_reref(36, :)
        data = EEG_data.data{TaskNumber};

        Fs = 1000;
        Base = -round(0.25 * Fs);
        Duration = round(1 * Fs);

        EEG = zeros(size(data.y, 1), size(data.X, 2), Duration - Base + 1);

        temp = ones(size(data.y));

        if nargin > 2 && filter

            for i = 1:size(data.y, 1)
                EEG(i, :, :) = data.X(data.trial(i) + Base:data.trial(i) + Duration, 1:end)';

                if max(max(abs(EEG(i, :, :)))) > 200
                    temp(i) = 0;
                end

            end

        end

        if nargout >= 4
            All_data = data.X(:, 1:end - 4)';
        end

        EEG = EEG(temp == 1, 1:end - 4, :);
        Seq = data.y(temp == 1);
        % Seq(isnan(Seq)) = [];
        % seqidx = MEG_data.seqidx{TaskNumber};
        seqidx = 1:size(Seq, 1);

    end

end
