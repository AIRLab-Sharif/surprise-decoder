Param = init_param(Modality, Sub, TaskNumber, learn_method, SurpriseMethod, Period, Model_Mode);

logfile = getlogfile(Param.get_log_dir, Param.get_save_file_name(filepath));
fprintf(logfile, 'Start Decoding model for %-60s\n', replace(Param.get_save_file_name(filepath), '_', ' '));

fprintf('*** %-60s started! ***\n', replace(Param.get_save_file_name(filepath), '_', ' '));

Model_Rs = cell(size(Tries_list));
FitModels = cell(size(Tries_list));
