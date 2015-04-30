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
# get json of thresholds file
/file/load

# same thing
/thresholds

# get whether or not file is valid
/file/valid

# get file hash
/file/hash

# create a new suppression
/suppression/new?sid=123&gid=456

# filter thresholds
/thresholds/sort
/thresholds/sort/uniq
/thresholds/suppressions/sort/uniq
/thresholds/event_filters/shuffle/reverse/sort/uniq
```
