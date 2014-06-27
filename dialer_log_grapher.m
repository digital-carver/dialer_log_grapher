function dialer_log_grapher(filename, nums_to_graph)
% DIALER_LOG_GRAPHER - Read the csv log export from DialerOne Android, and
% produce bar graphs of call durations
% 
% 'filename' is the path to the CSV (actually semicolon separated) file,
% nums_to_graph is the list of numbers whose call durations are to be
% graphed. Note that the numbers are not treated as distinct, as they're
% intended to be used for eg. for multiple numbers of the same person or
% entity.
% TODO: Remove "+country code" or "0" from numbers before comparing.

%config values 
num_xticks = 10; 

fid = fopen(filename);
num_duration_cell = textscan(fid, '%u64 %*s %*s %n:%n', 'CommentStyle', '#', ...
                                'Delimiter', ';', 'EmptyValue', 0, 'HeaderLines', 2);
fclose(fid);

numbers = num_duration_cell{1, 1};
durations = num_duration_cell{1, 2}*60 + num_duration_cell{1, 3};

match_indices =  arrayfun(@(x) find(numbers==x), nums_to_graph, 'UniformOutput', false);

dur_to_graph = durations(vertcat(match_indices{:}));
%dur_to_graph(dur_to_graph > 300) = 300;
hist(dur_to_graph, 50); 

% Now make easier for muggle consumption
xlabel('Duration of call');
ylabel('Number of occurrences');
graphtitle = ['Graph of call durations from ' sprintf('%u, ', nums_to_graph)];
graphtitle = graphtitle(1:end-2); %remove the last , and space
title(graphtitle);
max_minutes = ceil(max(dur_to_graph)/60); %bring it to a round minute
%this ensures all ticks are at minutes, the -1 is for linspace
max_minutes = ceil(max_minutes/(num_xticks-1))*(num_xticks-1); 
ceiled_xmax = max_minutes*60; %x-axis needs the same value but in seconds
xticks = linspace(0, ceiled_xmax, num_xticks); 

xticklabels = num2cell(datestr((xticks/3600)/24, 'HH:MM:SS'), 2); 
xticklabels = regexprep(xticklabels, '^00:(\d{2}:\d{2})', '$1');

set(gca, 'XLim', [0 ceiled_xmax], 'XTick', xticks,'XTickLabel', xticklabels);

end

