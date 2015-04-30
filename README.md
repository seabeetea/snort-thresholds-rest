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
get /thresholds

# create filters
post /thresholds/suppression/new?sid=1&gid=1&comment=comment
post /thresholds/event_filter/new?sid=2&gid=2&type=limit&track_by=src&count=10&seconds=60&comment=comment
post /thresholds/rate_filter/new?gid=3&sid=3&track_by=src&count=10&new_action=drop&seconds=60&comment=comment

# get filters
get /thresholds/suppressions
get /thresholds/suppression?sid=1&gid=1

# update filters
post /thresholds/suppression/update?sid=1&gid=1&track_by=src&ip=1.1.1.1
post /thresholds/event_filter/update?sid=2&gid=2&comment=comment

# delete filters
post /thresholds/suppression/delete?sid=1&gid=1
post /thresholds/rate_filter/delete?sid=3&gid=3

# manipulate list of filters
get /thresholds/suppressions/sort/uniq
get /thresholds/event_filters/shuffle/reverse/sort/uniq
```
