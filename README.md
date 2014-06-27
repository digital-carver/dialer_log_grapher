**Dialer Log Grapher** - Read the csv log export from Dialer One (Android), 
and produce a histogram of call durations.

`filename` is the path to the CSV (actually semicolon separated) file,
nums\_to\_graph is the list of numbers whose call durations are to be
graphed. Note that the numbers are not treated as distinct, as they're
intended to be used for eg. for multiple numbers of the same person or
entity.

TODO: Remove "+country code" or "0" from numbers before comparing.
