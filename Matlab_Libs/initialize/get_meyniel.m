function Output = get_meyniel(Seq, Param, seqidx)
    % simply can use in
    % get_meyniel(Seq, init_param('MMEG', 1, 4, 'transition'))
    % way

    Meyniel_Path = fullfile('Matlab_Libs', 'HumanInference_Meyniel_2016', 'IdealObserversCode');
    addpath(Meyniel_Path)
    % Meyniel_Path = fullfile('HumanInference_Meyniel_2016', 'IdealObserversCode');
    % addpath(Meyniel_Path)

    %% Parameters of Model
    in = struct();
    in.learned = Param.learn_method; % 'transition'; % estimate transition
    in.jump = 0; % estimate with jumps
    in.opt.AboutFirst = 'WithoutFirst'; % discard 1st observation for analytical solutions
    n = 20; % resolution of the univariate probability grid
    in.opt.pgrid = linspace(0, 1, n); % grid to return full distributions
    in.opt.ReturnDist = 0; % Return full posterior distributions
    in.opt.ReturnPuzzlement = 1; % Return gerstner surprise
    in.opt.priorp1g2 = [1 1]; % uniform Beta prior
    in.opt.priorp2g1 = [1 1]; % uniform Beta prior
    in.verbose = 0; % to check that no default values are used.

    %% Surprise Calculation:
    Output = struct();

    % Calculation for Meyniel ---------------------------------------------
    for w_ind = 1:length(Param.w_Set)

        in.opt.MemParam = {'Decay', Param.w_Set(w_ind)}; % Omega
        Output(w_ind).surprise = zeros(1, size(Seq, 2));
        Output(w_ind).puzzlement = zeros(1, size(Seq, 2)); % KL (prior || p_hat)
        Output(w_ind).puzzlement2 = zeros(1, size(Seq, 2)); % KL (posterior || p_hat)
        Output(w_ind).distUpdate = zeros(1, size(Seq, 2)); % KL (posterior || prior)
        Output(w_ind).distUpdate2 = zeros(1, size(Seq, 2)); % KL (prior || posterior)

        if size(Seq, 1) > 1

            for runnumber = 1:3
                in.s = Seq(1, Seq(2, :) == runnumber) + 1; % Sequence of stimuli

                out = IdealObserver(in);

                Output(w_ind).surprise(Seq(2, :) == runnumber) = out.surprise';
                Output(w_ind).puzzlement(Seq(2, :) == runnumber) = out.puzzlement';
                Output(w_ind).puzzlement2(Seq(2, :) == runnumber) = out.puzzlement2';
                Output(w_ind).distUpdate(Seq(2, :) == runnumber) = out.distUpdate';
                Output(w_ind).distUpdate2(Seq(2, :) == runnumber) = out.distUpdate2';

            end

        else

            in.s = Seq; % Sequence of stimuli
            in.s(isnan(Seq)) = [];

            out = IdealObserver(in);

            Output(w_ind).surprise(~isnan(Seq)) = out.surprise';
            Output(w_ind).puzzlement(~isnan(Seq)) = out.puzzlement';
            Output(w_ind).puzzlement2(~isnan(Seq)) = out.puzzlement2';
            Output(w_ind).distUpdate(~isnan(Seq)) = out.distUpdate';
            Output(w_ind).distUpdate2(~isnan(Seq)) = out.distUpdate2';
        end

        if nargin > 2
            Output(w_ind).surprise = Output(w_ind).surprise(seqidx);
            Output(w_ind).puzzlement = Output(w_ind).puzzlement(seqidx);
            Output(w_ind).puzzlement2 = Output(w_ind).puzzlement2(seqidx);
            Output(w_ind).distUpdate = Output(w_ind).distUpdate(seqidx);
            Output(w_ind).distUpdate2 = Output(w_ind).distUpdate2(seqidx);
        end

    end

end
