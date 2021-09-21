function data = updatacompletedata(filepath, Param)

    [~, filename, ~] = fileparts(filepath);
    checkdir(fullfile('reports', 'complete'))
    if exist(fullfile('reports', 'complete', sprintf('%s.mat', Param.get_complete_check_file_name(filename))), 'file') == 2
        data = load(fullfile('reports', 'complete', Param.get_complete_check_file_name(filename)));
        data = data.data;
    else
        data = struct();
    end

    data.(Param.get_save_file_name(filepath)) = 1;
    parsave(fullfile('reports', 'complete'), Param.get_complete_check_file_name(filename), data);

end
