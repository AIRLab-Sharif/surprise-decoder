X = get_x_period(x, Param, tries);
[Model_R, FitModel] = decoding_model(X, data.data.Output, Param, logfile);

FitModels{tries} = struct();

for fi = 1:size(FitModel, 2)

    for fn = fieldnames(FitModel)'
        FitModels{tries}(fi).(fn{1}) = FitModel.(fn{1});
    end

end

Model_Rs{tries} = Model_R;