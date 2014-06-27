function bin_freq = dialer_log_grapher(filename, nums_to_graph)
% DIALER_LOG_GRAPHER - Read the csv log export from DialerOne Android, and
% produce bar graphs of call durations
% 
% 'filename' is the path to the CSV (actually semicolon separated) file,
% nums_to_graph is the list of numbers whose call durations are to be
% graphed. Note that the numbers are not treated as distinct, as they're
% intended to be used for eg. for multiple numbers of the same person or
% entity.
% TODO: Remove "+country code" or "0" from numbers before comparing.

%%config values 
num_xticks = 10; 

%% Actual data processing
fid = fopen(filename);
data_cell = textscan(fid, '%u64 %s %s %n:%n', 'CommentStyle', '#', ...
                                'Delimiter', ';', 'EmptyValue', 0, 'HeaderLines', 2);
fclose(fid);

numbers = data_cell{1, 1};
names = data_cell{1, 2};
dates = data_cell{1, 3};
durations = data_cell{1, 4}*60 + data_cell{1, 5};

match_indices =  arrayfun(@(x) find(numbers==x), nums_to_graph, 'UniformOutput', false);

dur_to_graph = durations(vertcat(match_indices{:}));
xmax = max(dur_to_graph);

match_names = unique(names(vertcat(match_indices{:})));
%Get the first and last dates in the data as dd mmm
begin_date = get_human_date(dates(end));
end_date = get_human_date(dates(1));

%the .../20 part is to have 20 seconds in each bin
[bin_freq, bin_dur] = hist(dur_to_graph, round(xmax/20));
bar(bin_dur, bin_freq);



%% Now make easier for muggle consumption
xlabel('Duration of call');
ylabel('Number of calls');
graphtitle = ['Graph of call durations from ' sprintf('%s, ', match_names{:})];
graphtitle = graphtitle(1:end-2); %remove the last , and space
title(graphtitle);

%use bin_values to find empty space in the graph, put the text there (TBD)
max_calls = max(bin_freq);


text((90/100*xmax), (95/100*max_calls), ...
     sprintf('Period of call log data:\n    %s - %s     ', begin_date, end_date));

max_minutes = ceil(xmax/60); %bring it to a round minute
%this ensures all ticks are at minutes, the -1 is for linspace
max_minutes = ceil(max_minutes/(num_xticks-1))*(num_xticks-1); 
ceiled_xmax = max_minutes*60; %x-axis needs the same value but in seconds
xticks = linspace(0, ceiled_xmax, num_xticks); 

xticklabels = num2cell(datestr((xticks/3600)/24, 'HH:MM:SS'), 2); 
xticklabels = regexprep(xticklabels, '^00:(\d{2}:\d{2})', '$1');

set(gca, 'XLim', [0 ceiled_xmax], 'XTick', xticks,'XTickLabel', xticklabels);

end

function human_date = get_human_date(date_str)

[y, mon, d] = datevec(date_str, 'HH:MM AM mm/dd');
human_date = datestr([y, mon, d, 0, 0, 0], 'dd mmm');

end