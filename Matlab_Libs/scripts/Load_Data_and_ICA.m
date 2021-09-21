Param = init_param(Modality);

data = load(fullfile('Processed_Data', sprintf('%s_surprise', Modality), ...
    sprintf('%s_surprise_Subject%02d_Task%d_%s.mat', ...
    Modality, Sub, TaskNumber, learn_method)));

if ICA_flag

    ica = load(fullfile('Processed_Data', 'ICA_Matrices', sprintf('ICA_%s', Modality), ...
        sprintf('%s_ICA_Subject%02d_Task%d.mat', Modality, Sub, TaskNumber)));
    ica_weights = ica.data.weights; % ica.data.weights * ica.data.sphere;
else
    ica_weights = eye(Param.N_Channel);
end

switch Modality
case {'MEG', 'MMEG', 'GMEG', 'GMEG2', 'GMEG3'}
    filters_ind = load(fullfile('Output', 'filter_ind.mat'));
otherwise
    filters_ind = struct();
    filters_ind.data = ones(max(Subjects_list), Param.N_Channel);
end

x = get_inputs(data.data.X(:, filters_ind.data(Sub, :) > 0, :), ...
    Param, ...
    ica_weights);
