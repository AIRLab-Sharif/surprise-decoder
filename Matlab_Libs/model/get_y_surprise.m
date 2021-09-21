function y = get_y_surprise(out, Param)

    switch (Param.SurpriseMethod)
        case "PUZ" % KL (prior || p_hat)
            y = out.puzzlement';
        case "PUZ2" % KL (posterior || p_hat)
            y = out.puzzlement2';
        case "KL" % KL (posterior || prior)
            y = out.distUpdate';
        case "KL2" % KL (prior || posterior)
            y = out.distUpdate2';
        case "log2" % Shannon
            y = out.surprise';
        case "log" % Shannon
            y = out.surprise';
        case "LOG" % Shannon
            y = out.surprise';
    end

end
