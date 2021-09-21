addpath ../Output

filters_ind = zeros(18, 306);

for SubjectNum = 1:18

    if ispc
        Path = fullfile('D:', 'DS', 'MEG', sprintf('subject%02d', SubjectNum));
    else
        Path = fullfile('..', '..', '..', 'MEG_DS', sprintf('subject%02d', SubjectNum));
    end

    MEG_data = load(Path);

    A = endsWith(MEG_data.meg.label, '1');

    filters_ind(SubjectNum, :) = A;

end

parsave(fullfile('..', 'Output'), 'filter_ind', filters_ind);
