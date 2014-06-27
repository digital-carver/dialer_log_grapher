function dur_to_graph = dialer_log_grapher(filename, nums_to_graph)
% DIALER_LOG_GRAPHER - Read the csv log export from DialerOne Android, and
% produce bar graphs of call durations
% 
% 'filename' is the path to the CSV (actually semicolon separated) file,
% nums_to_graph is the list of numbers whose call durations are to be
% graphed. Note that the numbers are not treated as distinct, as they're
% intended to be used for eg. for multiple numbers of the same person or
% entity.
% TODO: Remove "+country code" or "0" from numbers before comparing.

fid = fopen(filename);
num_duration_cell = textscan(fid, '%u64 %*s %*s %n:%n', 'CommentStyle', '#', 'Delimiter', ';', 'EmptyValue', 0, 'HeaderLines', 2);
fclose(fid);

numbers = num_duration_cell{1, 1};
durations = num_duration_cell{1, 2}*60 + num_duration_cell{1, 3};

match_indices =  arrayfun(@(x) find(numbers==x), nums_to_graph, 'UniformOutput', false);

dur_to_graph = durations(vertcat(match_indices{:}));
%dur_to_graph(dur_to_graph > 300) = 300;
hist(dur_to_graph, 50); 

% Now make easier for muggle consumption
xlabel('Duration of call (mm:ss)')
rounded_xmax = round(max(dur_to_graph)/60)*60; %bring it to a round minute
xticks = linspace(0, rounded_xmax, 10);
xticklabels = datestr((xticks/3600)/24, 'MM:SS'); %FIXME?
set(gca, 'XLim', [0 rounded_xmax], 'XTick', xticks,'XTickLabel', {xticklabels});

end
