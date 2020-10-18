function interleave_map = build_interleave_map()  % Todo: Add other modes
    % ---------------------------------------------------------------------    
    % BUILD_INTERLEAVE_MAP: Return interleave map (currently for Mode 1 only)
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %               n/a
    %
    %  Outputs
    %   > prs:      De/interleave map (for Mode 1)
    %
    % ---------------------------------------------------------------------
    % Preallocate
    intermediate = zeros(1,2048);

    % Calculated according to frequency interleaving algorithm
    % For more info, see DAB Standard document
    for ii = 2:2048
        intermediate(ii) = mod(intermediate(ii-1)*13+511,2048);
    end

    % Find where there are 1's in column one and 3's in column two for each row
    interleave_map = intermediate(intermediate(1,:) >= 256 & ...
        intermediate(1,:) <= 1792 & intermediate(1,:) ~= 1024) + 1;

end