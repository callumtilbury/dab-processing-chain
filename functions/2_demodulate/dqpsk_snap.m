function dab_data_snapped = dqpsk_snap(dab_data_deinterleaved)
    dab_data_snapped = arrayfun(@snapper, dab_data_deinterleaved);
end

function snapped = snapper(unsnapped)
    % Helper function
    if (angle(unsnapped) >= 0 && angle(unsnapped) < pi/2)
        snapped = 0.707106781186548 + 0.707106781186547i;
    
    elseif (angle(unsnapped) >= pi/2 && angle(unsnapped) < pi)
        snapped = -0.707106781186547 + 0.707106781186548i;
    
    elseif (angle(unsnapped) >= -pi && angle(unsnapped) < -pi/2)
        snapped = -0.707106781186547 - 0.707106781186548i;
    
    elseif (angle(unsnapped) >= -pi/2 && angle(unsnapped) < 0)
        snapped = 0.707106781186548 - 0.707106781186547i;
    
    end
end