function checkdir(directory)

    if exist(directory, 'dir') ~= 7
        mkdir(directory)
    end

end
