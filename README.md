# snort-thresholds-rest
Edit thresholds filename in `config.rb`:

```
DATAFILE = '/tmp/threshold.conf'
```

Start server:

```
rackup server.ru
```

Make requests:

```
# get thresholds
get /thresholds?api_key=12345

# create filters
post /thresholds/suppression/new?sid=1&gid=1&comment=comment&api_key=12345
post /thresholds/event_filter/new?sid=2&gid=2&type=limit&track_by=src&count=10&seconds=60&comment=comment&api_key=12345
post /thresholds/rate_filter/new?gid=3&sid=3&track_by=src&count=10&new_action=drop&seconds=60&comment=comment&api_key=12345

# get filters
get /thresholds/suppressions?api_key=12345
get /thresholds/suppression?sid=1&gid=1&api_key=12345

# update filters
post /thresholds/suppression/update?sid=1&gid=1&track_by=src&ip=1.1.1.1&api_key=12345
post /thresholds/event_filter/update?sid=2&gid=2&comment=comment&api_key=12345

# delete filters
post /thresholds/suppression/delete?sid=1&gid=1&api_key=12345
post /thresholds/rate_filter/delete?sid=3&gid=3&api_key=12345

# manipulate list of filters
get /thresholds/suppressions/sort/uniq?api_key=12345
get /thresholds/event_filters/shuffle/reverse/sort/uniq?api_key=12345
```
