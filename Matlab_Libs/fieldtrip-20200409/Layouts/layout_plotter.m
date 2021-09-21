addpath(fullfile('Matlab_Libs',  'fieldtrip-20200409'));

dirlist  = dir('Matlab_Libs\\fieldtrip-20200409\\template\\layout\\EEG*');
filename = {dirlist(~[dirlist.isdir]).name}'
for i=1:length(filename)
cfg = [];
cfg.layout = filename{i};
layout = ft_prepare_layout(cfg);

figure
ft_plot_layout(layout);
h = title(filename{i});
set(h, 'Interpreter', 'none');

[p, f, x] = fileparts(filename{i});
print([lower(f) '.png'], '-dpng');
end