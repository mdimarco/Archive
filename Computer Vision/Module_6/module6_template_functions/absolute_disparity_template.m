function AD = absolute_disparity(response_l, response_r, d, p, q)
% INPUT: response_l and response_r are filter maps from a bank of simple cells, 
% d is a list of disperity values, and p is a power used to compute TE and
% q is a power used to  compute TI
% OUTPUT: response is the response of an absolute disparity cell. 

% For each element e in d, shift both the left and right maps so that the
% total shift is equal to e. For example, if an element in d is 8, you
% should shift the left map to the left by 4 and the right map to the right
% by 4 to get a disparity of 8. If the element in disparity is 9, shift the
% left map by 4 and the right map by 5. A simple approach is to cut away
% the d/2 leftmost columns in the left map, and then pad with d/2 empty
% columns (zeros) at the right edge of the left map. Do the same for the
% right map. Be careful when d is negative, that is, uncrossed disparity
% — you will have to cut the right side and pad the left side.
% 
% Once you've done this, you should end up with 2 maps for the shifted
% right receptive field (one with phase=0 and one with phase=pi/2) and 2
% maps for the shifted left receptive field. These represent "L_0" (left,
% phase = 0), "R_0" (right, phase = 0), "L_90" (left, phase = pi/2) and
% "R_90" (right, phase=pi/2). Plug these into the equation for TE:
% 
% TE = abs((L_0+ R_0))^p + abs((L_90 + R_90))^p
%
% and then plug into the equation for TI:
% 
% TI = abs((L_0- R_0))^q + abs((L_90 - R_90))^q
% 
% Finally, normalize by computing AD = (TE - TI)/(TI + TE)
% 
% Useful matlab functions: 
%    -circshift() to shift the left map's pixels, you'll have to multiply d
%    by -1 to shift in the correct direction. 
%    ***IMPORTANT:*** If you use this, make sure
%    you get rid of the part of the image that wraps around to the other
%    side by replacing it with 0s. If you used this in *binocular_cell*,
%    make sure you delete the wraparound there too!!!! It's as easy as
%    replacing the left disparity/2 columns in the right image with 0's and
%    right disparity/2 columns in the left image with 0's.

% removing unnecessary dimensions so that your maps are height x width x
% n_phases

response_l = permute(response_l,[1,2,5,3,4]);
response_r = permute(response_r,[1,2,5,3,4]);

% ============TYPE YOUR CODE HERE===============




TE = zeros( size(response_l,1), size(response_l,2) );
TI = zeros( size(response_l,1), size(response_l,2) );

% For each phase
for p = 1:size(response_l,3)
    
    %filter at phase
    left = response_l(:,:,p);
    right = response_r(:,:,p);
    
    %For each disparity
    for i=1:numel(d)
        e = d(i);
        %Amount to shift left/right filters
        left_shift = floor( e/2 );
        right_shift = ceil( e/2 );

        % - is left and + is right for circshift
        %So + disparity shifts left-map left, and right-map right
        left_shifted  = circshift( left, [0, -left_shift]);
        right_shifted = circshift( right, [0, right_shift]);

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
        
        TE = TE +  abs( left_shifted + right_shifted ).^ p ;
        TI = TI +  abs( left_shifted - right_shifted ).^ q ;
    end
    
end
        AD = TE ./ ( sqrt(2) + TI );
        %AD = (TE - TI)./(TI + TE);

end
