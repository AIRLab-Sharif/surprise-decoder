function R = response_extracter(StartIndex, EEG35to37)
    R = zeros(size(StartIndex,1),1);
    
    for i = 1:size(StartIndex,1)
        if i < size(StartIndex,1)
            R(i) = (sum(EEG35to37(3, StartIndex(i,1):StartIndex(i+1,1)))>0)*1;
        else
            R(i) = (sum(EEG35to37(3, StartIndex(i,1):end))>0)*1;
        end
    end
end