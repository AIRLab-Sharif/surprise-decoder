Model_Mode_list = ["Time", "Periods", "Channels"]; %, "ChannelsPeriod"]; %, "Periods", "IC", "Channels", "Time"];

Modality = 'EEGfMRI'; % 'MMEG'; %EEGfMRI EEG% MEG GMEG GMEG2 GMEG3

switch Modality
    case {'MEG', 'MMEG', 'GMEG', 'GMEG2', 'GMEG3'}
        Subjects_list = 1:18;
        Tasks_list = 1:4; %1:4;
    case 'EEG2'
        Subjects_list = 1:2;
        Tasks_list = 1:2;
    case 'EEGfMRI'
        Subjects_list = 1:17;
        Tasks_list = 1:2;
end

Learn_methods_list = ["transition", "frequency"];
SurpriseMethods_list = ["KL2", "LOG", "PUZ"]; % , "PUZ2"]
% Periods_list = ["all"];
ICA_flag = 1;
