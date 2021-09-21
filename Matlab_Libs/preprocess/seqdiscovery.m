function [StartInd, Seq, Dev, StaInd] = seqdiscovery(x, AorV)
    %{
    Inputs:
    x:time series of task indices
    AorV:0:Auditory and 1:Visual
    Outut:
    Seq:indeces and kinds of stimuli
    Dev:indeces of deviants and the number of standards before each one
    StaInd:indeces of standards

    %}
    if AorV == 0
        Thresh1 = 90;
        Thresh2 = 120;
    elseif AorV == 1
        Thresh1 = 190;
        Thresh2 = 220;
    elseif AorV == 2
        Thresh1 = 34;
        Thresh2 = 35;
    end

    x(x == 0) = 25;
    x = diff(x);

    Ind = (1:length(x))';

    StartInd = Ind(x > Thresh1);
    Seq = x(StartInd);
    Seq(Seq > Thresh2) = 1;
    Seq(Seq > Thresh1) = 0;

    StaInd = StartInd(Seq == 0);
    Dev(:, 1) = StartInd(Seq == 1);
    N = Ind(Seq == 1);
    Dev(:, 2) = [N(1); diff(N)] - 1;

end
