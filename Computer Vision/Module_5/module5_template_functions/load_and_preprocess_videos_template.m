function [videos, labels] = load_and_preprocess_videos(path)
% Input: path is a path to the directory containing video data
% Output: videos, a v x 1 cell array where v is the number of videos in your
% datafolder and labels, a vx1 vector with labels consisting of numbers 1
% through 5. 
% 
% Some useful functions to look into: 
%   - dir() for reading the directory. Be sure to remove the first items
%   that this returns (usually '.' and '..' which are not useful to you.
%   -VideoReader() for reading the video. This returns a struct, so look at
%   the documentation for how to access its fields. 
%
% =============TYPE YOUR CODE HERE=============


video_counter = 1;
current_label = 1;


folders = dir(path);
%For each folder 
for x=1:size(folders,1)
    folder = folders(x);

    % (skip . and .. )
    if folder.name(1) == '.'
        continue
    end
    
    %Files containing videos
    video_files = dir(strcat(path,folder.name));
    
    %For each file in the folder
    for y=1:size(video_files,1)
        %(skip . and .. and .DS_store)
        if video_files(y).name(1) == '.'
            continue
        end
        filename = strcat(path,folder.name,'/',video_files(y).name);
        
        raw_video = read(VideoReader(filename));
        cropped_video = nan( size(raw_video, 1), size(raw_video, 2), 25);
        %Convert to grayscale and crop
        for f=1:25
            color_frame = raw_video(:,:,:,f);
            cropped_video(:,:,f) = rgb2gray(color_frame);
        end
        
        %Add video to lists & label
        videos{video_counter} = cropped_video;
        labels(video_counter) = current_label;
        video_counter = video_counter + 1;
    end
    
    current_label = current_label + 1;
end

videos = videos';
labels = labels';

