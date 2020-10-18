function dab_data_snapped = dqpsk_snap(dab_data_deinterleaved)
    % ---------------------------------------------------------------------    
    % DQPSK_SNAP: Snap DQPSK data to angles: 45, 135, -45, or -135
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_data_deinterleaved:   Deinterleaved DQPSK data,
    %                               [dab_mode.L x dab_mode.K]
    %
    %  Outputs
    %   < dab_data_snapped:     Snapped DQPSK symbols
    %                            [dab_mode.L x dab_mode.K]
    %
    % ---------------------------------------------------------------------
    % Apply snapper function to entire input matrix
    dab_data_snapped = arrayfun(@snapper, dab_data_deinterleaved);
end

function snapped = snapper(unsnapped)
    % ---------------------------------------------------------------------    
    % SNAPPER: Helper function for snapping a single angle
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > unsnapped:    Input angle
    %
    %  Outputs
    %   < snapped:      Snapped angle
    %
    % ---------------------------------------------------------------------
    
    %% QUADRANT 1 [0 <= angle < 90]
    if (angle(unsnapped) >= 0 && angle(unsnapped) < pi/2)
        snapped = 0.707106781186548 + 0.707106781186547i;
    
    %% QUADRANT 2 [90 <= angle < 180]
    elseif (angle(unsnapped) >= pi/2 && angle(unsnapped) < pi)
        snapped = -0.707106781186547 + 0.707106781186548i;
    
    %% QUADRANT 3 [180 <= angle < 270]
    elseif (angle(unsnapped) >= -pi && angle(unsnapped) < -pi/2)
        snapped = -0.707106781186547 - 0.707106781186548i;
    
    %% QUADRANT 4 [270 <= angle < 360]
    elseif (angle(unsnapped) >= -pi/2 && angle(unsnapped) < 0)
        snapped = 0.707106781186548 - 0.707106781186547i;
    
    end
end