function parsave(directory, fname, data)

    checkdir(directory)

    save(fullfile(directory, fname), 'data')

end

% function parsave(fname, Output, Param, X, ...
%         w_Set, Dev_ERP, Dev_ERP_Err, Stn_ERP, Stn_ERP_Err)

%     if nargin == 2
%         save(fname, 'Output')
%     elseif nargin == 3
%         save(fname, 'Output', 'Param')
%     elseif nargin == 4
%         save(fname, 'Output', 'Param', 'X')
%     elseif nargin == 5
%         save(fname, 'Output', 'Param', 'X', 'w_Set')
%     else
%         save(fname, 'Output', 'Param', 'X', ...
%             'w_Set', 'Dev_ERP', 'Dev_ERP_Err', 'Stn_ERP', 'Stn_ERP_Err')
%     end

% end
