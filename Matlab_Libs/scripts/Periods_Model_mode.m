switch Model_Mode
    case 'Periods'
        Periods_list = ["baseline", "early", "middle", "late", "all"];% "signal"];
        Tries_list = 1:1;
    case 'Time'
        Periods_list = ["sample", "interval"];
        Tries_list = 1:(Param.Target.Duration - Param.Target.Base + 1);
    case 'Channels'
        Periods_list = "Channel";
        Tries_list = 1:Param.N_Channel;
    case 'ChannelsPeriod'
        Periods_list = ["Call", "Clate", "Cmiddle", "Cearly", "Csignal"];
        Tries_list = 1:Param.N_Channel;
    case 'ICPeriod'
        Periods_list = ["Call", "Clate", "Cmiddle", "Cearly", "Csignal"];
        Tries_list = 1:size(ica.data.weights, 1);
    case 'IC'
        Periods_list = "IC";
        Tries_list = 1:size(ica.data.weights, 1);
    otherwise
        Periods_list = ["all", "late", "middle", "early", "signal"];
        Tries_list = 1:1;
end
