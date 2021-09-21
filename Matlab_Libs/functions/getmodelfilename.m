function fname = getmodelfilename(filepath, Param)

    [~, filename, ~] = fileparts(filepath);

    fname = sprintf('%s_%s_%s_%s_Subject%02d_Task%02d_%s_%s_%s.mat', ...
        filename, Param.Modality, Param.Model_Mode, Param.Model_Mode, Param.Sub, Param.TaskNumber, ...
        Param.learn_method, Param.SurpriseMethod, Param.Period);

end
