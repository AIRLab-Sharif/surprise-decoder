function [data, check] = getcompletedata(filepath, Param)

    [~, filename, ~] = fileparts(filepath);
    checkdir(fullfile('reports', 'complete'))
    if exist(fullfile('reports', 'complete', sprintf('%s.mat', Param.get_complete_check_file_name(filename))), 'file') == 2
        data = load(fullfile('reports', 'complete', Param.get_complete_check_file_name(filename)));
        data = data.data;
    else
        data = struct();
    end

    if nargout > 1
        if isfield(data, Param.get_save_file_name(filepath))
            check = data.(Param.get_save_file_name(filepath));
        else
            check = 0;
        end
    end

end
