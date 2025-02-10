function data = computeDifferentialSig(data)

    [nRows, nCols] = size(data.SIG);
    data.SIG_SD = cell(nRows-1, nCols);
    data.SIG_DD = cell(nRows-2, nCols); 

    for c = 1:nCols
        % Single Differential (SD)
        for r = 1:nRows-1
            data.SIG_SD{r, c} = data.SIG{r, c} - data.SIG{r+1, c};
        end
        
        % Double Differential (DD)
        for r = 1:nRows-2
            data.SIG_DD{r, c} = data.SIG_SD{r, c} - data.SIG_SD{r+1, c};
        end
    end

end
