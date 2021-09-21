function [Model_R, FitModel] = decoding_model(x, Output, Param, logfile)

    tic

    %% w tuning
    Model_R = struct();

    Model_R.R = zeros(length(Param.w_Set), 1); % Ordinary R2
    Model_R.dR = zeros(length(Param.w_Set), 1);
    Model_R.Rmax = zeros(length(Param.w_Set), 1);

    Model_R.R_MyCV = zeros(length(Param.w_Set), 1); % 5-fold CV R2 but with selected features
    Model_R.dR_MyCV = zeros(length(Param.w_Set), 1);
    Model_R.Rmax_MyCV = zeros(length(Param.w_Set), 1);

    Model_R.R_CV = zeros(length(Param.w_Set), 1); % Real 5-fold CV R2
    Model_R.dR_CV = zeros(length(Param.w_Set), 1);
    Model_R.Rmax_CV = zeros(length(Param.w_Set), 1);

    FitModel = struct();

    %% Computation For Meyniel
    rng('default')
    
    for w_ind = 1:length(Param.w_Set)
        w = Param.w_Set(w_ind);
        fprintf(logfile, '\n------------------------------------------------------------------------\n');
        fprintf(logfile, 'Meyniel, w=%3d, Sub=%2d, Task=%d, Surprise=%s, learn=%s, Period=%s\n', ...
            w, Param.Sub, Param.TaskNumber, Param.SurpriseMethod, Param.learn_method, Param.Period);

        % fprintf('w=%d ', w);
        % fprintf('\n------------------------------------------------------------------------\n')
        % fprintf('Meyniel, w=%3d, Sub=%2d, Task=%d, time=%2d, Surprise=%s, learn=%s, Period=%s\n', ...
        %     w, Sub, TaskNumber, 600, SurpriseMethod, learn_method, Period);

        %% surprise method
        Y = get_y_surprise(Output(w_ind), Param)';

        if Param.ModelParam.Test == 0

            y = Y';
            x_prime = x;

        else
            y = zeros(1, size(data.data.Seq, 1));
            y(~isnan(data.data.Seq)) = data.data.Seq(~isnan(data.data.Seq));
            y = y(data.data.seqidx);

            x_prime = x;
        end

        if Param.ModelParam.Null == 1
            ind_temp = randperm(length(y));
            y = y(ind_temp);
        end

        RCV_temp = zeros(1, Param.ModelParam.K);
        dRCV_temp = zeros(1, Param.ModelParam.K);

        RMyCV_temp = zeros(1, Param.ModelParam.K);
        dRMyCV_temp = zeros(1, Param.ModelParam.K);

        R_temp = zeros(1, Param.ModelParam.K);
        % dR_temp = zeros(1, Param.ModelParam.K);

        % If your seed is not fixed, it is better to repeat the cross
        % validation procedure for several times. However, since I have
        % fixed the seed, I consider K to be equal to 1
        for k = 1:Param.ModelParam.K

            % Applying Lasso for Feature Selection
            [Beta, FitInfo] = lasso(x_prime, y, 'CV', Param.ModelParam.K_CV, 'Lambda', Param.ModelParam.lambda_Set);

            RCV_temp(k) = (1 - FitInfo.MSE(FitInfo.Index1SE) / var(y)); % 5-fold CV R2
            dRCV_temp(k) = (FitInfo.SE(FitInfo.Index1SE) / var(y));

            BetaInd1 = 1:size(x_prime, 2);
            BetaInd1 = BetaInd1(Beta(:, FitInfo.Index1SE) ~= 0); % Feature Selection

            x_prime = x_prime(:, BetaInd1);
            LinRegModel = fitlm(x_prime, y);
            R_temp(k) = LinRegModel.Rsquared.Ordinary; % Ordinary R2

            % Applying Lasso for Computing My R_CV
            CV_Indices = crossvalind('Kfold', length(y), Param.ModelParam.K_CV);

            temp = zeros(1, Param.ModelParam.K_CV);

            for i = 1:Param.ModelParam.K_CV
                mdl = fitlm(x_prime(CV_Indices ~= i, :), y(CV_Indices ~= i, :));

                if length(mdl.Coefficients.Estimate) > 1
                    y_hat = mdl.Coefficients.Estimate(1) + ...
                        x_prime(CV_Indices == i, :) * mdl.Coefficients.Estimate(2:end);
                else
                    y_hat = mdl.Coefficients.Estimate(1);
                end

                temp(i) = 1 - mean((y(CV_Indices == i) - y_hat).^2) / var(y(CV_Indices == i));
            end

            RMyCV_temp(k) = mean(temp); % MyCV R2
            dRMyCV_temp(k) = std(temp);

        end

        FitModel(w_ind).Lasso.Info = FitInfo;
        FitModel(w_ind).Lasso.Beta = Beta;
        FitModel(w_ind).Ord = LinRegModel;

        Model_R.R_CV(w_ind) = mean(RCV_temp);   % 5-fold CV R2 of Lasso
        Model_R.dR_CV(w_ind) = mean(dRCV_temp);
        Model_R.Rmax_CV(w_ind) = max(RCV_temp);

        Model_R.R_MyCV(w_ind) = mean(RMyCV_temp);      % MyCV R2 (R2 for ordinary on only lasso selected features)
        Model_R.dR_MyCV(w_ind) = mean(dRMyCV_temp);
        Model_R.Rmax_MyCV(w_ind) = max(RMyCV_temp);

        Model_R.R(w_ind) = mean(R_temp);    % Ordinary R2
        Model_R.dR(w_ind) = std(R_temp);
        Model_R.Rmax(w_ind) = max(R_temp);

        fprintf(logfile, 'Ord: %.5f, %.5f, %.5f\n', Model_R.R(w_ind), Model_R.dR(w_ind), Model_R.Rmax(w_ind));
        fprintf(logfile, '5CV: %.5f, %.5f, %.5f\n', Model_R.R_CV(w_ind), Model_R.dR_CV(w_ind), Model_R.Rmax_CV(w_ind));
        fprintf(logfile, 'MCV: %.5f, %.5f, %.5f\n', Model_R.R_MyCV(w_ind), Model_R.dR_MyCV(w_ind), Model_R.Rmax_MyCV(w_ind));
        
        time = toc;
        fprintf(logfile, '\n------------------------------------------------------------------------\n');
        fprintf(logfile, 'It takes %.2f sec \n', time);

        % fprintf('Ord: %.5f, %.5f, %.5f\n', Meyniel_R.R(w_ind), Meyniel_R.dR(w_ind), Meyniel_R.Rmax(w_ind))
        % fprintf('5CV: %.5f, %.5f, %.5f\n', Meyniel_R.R_CV(w_ind), Meyniel_R.dR_CV(w_ind), Meyniel_R.Rmax_CV(w_ind))
        % fprintf('MCV: %.5f, %.5f, %.5f\n', Meyniel_R.R_MyCV(w_ind), Meyniel_R.dR_MyCV(w_ind), Meyniel_R.Rmax_MyCV(w_ind))
    end

end
