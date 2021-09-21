function log_file_dir = getmodelfiledir(filepath)

    [~, filename, ~] = fileparts(filepath);
    checkdir(fullfile('Output', filename))
    log_file_dir = fullfile('Output', filename);

end
