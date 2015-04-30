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
/thresholds

# get whether or not thresholds are valid
/thresholds/valid

# get tresholds hash
/thresholds/hash

# create suppressions, event filters, and rate filters
/thresholds/suppression/new?sid=1&gid=1&comment=comment goes here
/thresholds/event_filter/new?sid=2&gid=2&type=limit&track_by=src&count=10&seconds=60&comment=comment goes here
/thresholds/rate_filter/new?gid=3&sid=3&track_by=src&count=10&new_action=drop&seconds=60&comment=comment goes here

# filter thresholds
/thresholds/sort
/thresholds/sort/uniq
/thresholds/suppressions/sort/uniq
/thresholds/event_filters/shuffle/reverse/sort/uniq
```
