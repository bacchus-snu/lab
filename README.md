# SNUCSE Lab Environment

## Howto

### Creating New Packages

```bash
./create <PackageName> <UpstreamVersion> <License>
```

### Building Source Packages

```bash
cd <PackageName>
../build --binary
```

### Publishing to PPA

```bash
cd <PackageName>
dput ppa:bacchus-snu/lab *source.changes
```
