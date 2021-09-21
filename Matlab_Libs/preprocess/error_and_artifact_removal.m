function good_list_ind = error_and_artifact_removal(Seq, EvokPot)
    %% Error and Artifact Removal
    P = struct();
    % Not Errors
    temp = (Seq(1, :) == Seq(3, :)) * 1;
    % fprintf(logfile, 'Error Rate (%%): %f\n', (1 - sum(temp) / length(temp)) * 100);
    % fprintf('Error Rate (%%): %f\n', (1 - sum(temp) / length(temp)) * 100)

    P.Error_Rate = (1 - sum(temp) / length(temp)) * 100;

    % Not two first
    temp = temp .* ((1:size(Seq, 2) ~= 1) * 1) .* (1:size(Seq, 2) ~= 2) * 1;

    % Not more than thresh
    P.Thresh = 250;

    temp2 = max(max(abs(EvokPot), [], 2), [], 3); % Finding maximum amplitude of each trial
    
    temp = temp .* (temp2' <= P.Thresh);
    good_list_ind = (temp == 1);

end
