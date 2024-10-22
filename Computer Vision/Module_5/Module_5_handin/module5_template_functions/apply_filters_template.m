function filtered_video = apply_filters(video, filters)
% Input: filters, a d x 1 cell array, where d is the number of filters; and
% one video
%
% Output: a v x 1 cell array where each cell has a y-x-d-t matrix.
%
% Hint: You may want to preallocate the output array to minimize the time
% required for this function.
%
% Useful functions: 
%   -imfilter()
% ===============TYPE YOUR CODE HERE=====================


video_size = size(video{1});
v_height = video_size(1);
v_width = video_size(2);
v_frames = video_size(3);

f_size = size(filters{1},1);

filtered_video = cell( size( video, 1 ), 1);
for i=1:size(filtered_video,1)
    
    current = nan( max(v_height-f_size+1,0), max(v_width-f_size+1,0), size(filters,1), max(v_frames-f_size+1,0));
    
    for j=1:size(filters, 1)
        %hxwxdxt double of 1 video filtered by 1 filter
        current(:,:,j,:) =  convn( video{i}, filters{j}, 'valid');
    end    
    filtered_video{i} = current;
    i
end

