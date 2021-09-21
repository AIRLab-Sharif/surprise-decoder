X = get_x_period(x, Param, tries);
[Model_R, FitModel] = decoding_model(X, data.data.Output, Param, logfile);

for fi = 1:size(FitModel, 2)

    for fn = fieldnames(FitModel)'
        FitModels(tries, fi).(fn{1}) = FitModel.(fn{1});
    end
    
end

for fn = fieldnames(Model_R)'
    Model_Rs(tries).(fn{1}) = Model_R.(fn{1});
end
