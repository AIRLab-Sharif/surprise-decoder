function [MEG, Seq, seqidx] = readMEG(SubjectNum, TaskNumber)

    if ispc 
        Path = fullfile('D:', 'DS', 'MEG', sprintf('subject%02d.mat', SubjectNum));
    else
        Path = fullfile('..', '..', 'DS', 'MEG_DS', sprintf('subject%02d.mat', SubjectNum));
    end
    MEG_data = load(Path);
    
    A = endsWith(MEG_data.meg.label, '1');
    
    % Seq = MEG_data.seq{TaskNumber};
    Seq = MEG_data.seq{TaskNumber};
    % Seq(isnan(Seq)) = [];
    % seqidx = MEG_data.seqidx{TaskNumber};
    seqidx = MEG_data.seqidx{TaskNumber};
    % MEG = MEG_data.meg.trial;
    MEG = MEG_data.meg.trial(:, A, :);
    MEG = MEG(MEG_data.meg.trialinfo(:, 3) == TaskNumber, :, :);

    %[Seq, Dev, StaInd] = SeqDiscovery(temp(:, 36), 2);

end
