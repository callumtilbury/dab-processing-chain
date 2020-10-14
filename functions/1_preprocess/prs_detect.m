function prs_idx = prs_detect(iq_data, prs, dab_mode)
    %PRS_DETECT Summary of this function goes here
    %   Detailed explanation goes here    
    
    for ii = 1:dab_mode.Tu/2:length(iq_data)
        MF_out = conj(prs) .* fftshift(fft(iq_data(ii:ii+dab_mode.Tu-1)));   
        mf_out = abs(ifft(MF_out));
        [peak_val,peak_idx] = max(mf_out);
        
        % Check if a peak exists
        if (peak_val > 50*mean(abs(mf_out)) && peak_idx < dab_mode.Tu/2)
            prs_idx = ii + peak_idx - 1;
            break
        end

    end
        
end

