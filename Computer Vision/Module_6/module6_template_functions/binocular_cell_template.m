function response = binocular_cell(response_l, response_r, d, p)
% INPUT: response_l and response_r are filter maps from a bank of simple
% cells, d is a list of disparity values, and p is a power used in the
% energy equation 
% OUTPUT: response is the response of a binocular cell.

% For each element e in d, shift both the left and right maps so that the
% total shift is equal to e. For example, if an element in d is 8, you
% should shift the left map to the left by 4 and the right map to the right
% by 4 to get a disparity of 8. If the element in disparity is 9, shift the
% left map by 4 and the right map by 5. A simple approach is to cut away
% the d/2 leftmost columns in the left map, and then pad with d/2 empty
% columns (zeros) at the right edge of the left map. Do the same for the
% right map. Be careful when d is negative, that is, uncrossed disparity as
% you will have to cut the right side and pad the left side.
%
% Once you've done this, you should end up with 2 maps for the right
% receptive field (one with phase=0 and one with phase=pi/2) and 2 maps f
% or the left receptive field shifted d pixels. These represent "L_0"
% (left, phase = 0), "R_0" (right, phase = 0), "L_90" (left, phase = pi/2)
% and "R_90" (right, phase=pi/2). Plug these into the energy equation:
%
% Energy =abs((L_0+ R_0)).^p + abs((L_90 + R_90)).^p
%
% and return the result.
%
% Useful matlab functions:
%    -circshift() to shift the left map's pixels, you'll have to multiply d
%    by -1 to shift in the correct direction.

% removing unnecessary dimensions so that your maps are height x width x
% n_phases
response_l = permute(response_l,[1,2,5,3,4]);
response_r = permute(response_r,[1,2,5,3,4]);

% ============TYPE YOUR CODE HERE===============
response = nan( size(response_l,1), size(response_l,2), size(d,1));

for i=1:numel(d)
    e = d(i);
    
    energy = zeros( size(response_l,1), size(response_l,2) );
    for p=1:size(response_l,3)
        
        %filter at phase
        left  = response_l(:,:,p);
        right = response_r(:,:,p);
        
        %Amount to shift left/right filters
        left_shift = floor( e/2 );
        right_shift = ceil( e/2 );

        % - is left and + is right for circshift
        % So + disparity shifts left-map left, and right-map right
        left_shifted  = circshift( left, -left_shift, 2);
        right_shifted = circshift( right, right_shift, 2);

        % If e > 0, pad:
        %  right columns of left filter
        %  left columns of right filter
        if e > 0
            left_shifted(:, (end-left_shift):end ) = 0;
            right_shifted(:,1:right_shift) = 0;

        % If e < 0 pad:
        %  left columns of left filter
        %  right columns of right filter
        else
            left_shifted(:, 1:left_shift) = 0;
            right_shifted(:,(end-right_shift):end) = 0;
        end
        
        energy = energy + abs( left_shifted + right_shifted ).^ p ;
    end
    
    response(:,:,i) = energy;
end

