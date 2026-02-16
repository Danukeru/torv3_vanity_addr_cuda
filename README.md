# Tor V3 vanity address generator

Usage:
```
./vanity_torv3_cuda [-i] [-d N] pattern1 [pattern_2] [pattern_3] ... [pattern_n]
```

`-i` will display the keygen rate every 20 seconds in million addresses per second.  
`-d` use CUDA device with index N (counting from 0). This argument can be repeated multiple times with different N.

Example:
```
./vanity_torv3_cuda -i 4?xxxxx 533333 655555 777777 p99999
```
Capture generated keys simply by output redirection into a file :  
`$ ./vanity_torv3_cuda test | tee -a keys.txt`

You can then use the `genpubs.py` scripts under `util/` to generate all the tor secret files :  
 `$ python3 genpubs.py keys.txt`
 
A folder called `generated-<timestamp>` will be generated  

## Performance

This generator can check ~2 million keys/second on a single GeForce GTX 1080Ti.  
Multiple patterns don't slow down the search.  
Max pattern prefix search length is 32 characters to allow offset searching ie. `????wink??????test???`  
Anything beyond 12 characters will probably take a few hundred years...  
Only these characters are permitted in an address:  
```
abcdefghijklmnopqrstuvwxyz234567
```

## Build instructions

### Docker - Ubuntu 24.04

Get a build tarball with `docker build -o . .`

