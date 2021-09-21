function logfile = getlogfile(filepath, fname)

    [~, filename, ~] = fileparts(filepath);
    checkdir(fullfile('reports', filename))
    log_file_path = fullfile('reports', filename, fname);
    logfile = fopen(log_file_path, 'w+');

end
