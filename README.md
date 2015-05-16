hashcompare
===========
A simple utility that allows for easy password recovery from oclHashcat cracking sessions.

In the instance where oclHashcat spits out successfully cracked passwords via the format `hash:password`, and the original file of hashes is in the format `user:hash`, this tool matches on the hash and produces an output file with the format of `user:password`.

## Examples

user:hash
```
george:c21cfaebe1d69ac9e2e4e1e2dc383bac
```

hash:password
```
c21cfaebe1d69ac9e2e4e1e2dc383bac:password
```

## Tools
The following tools were used in a proof of concept attack I conducted, of which led to the need to build a series of scripts (namely this one) to automate the process of password extraction and cracking from compromised Active Directory machines.
### creddump (https://github.com/moyix/creddump)
Used for dumping cached credentials.

### libesedb (https://github.com/libyal/libesedb)
Extracts the relevant portions of the NTDS tables.

### NTDSXtract (https://github.com/csababarta/ntdsxtract)
A custom file, [dshashes.py](http://ptscripts.googlecode.com/svn/trunk/dshashes.py), was used to export the password hashes into a more usable format. place the `dshashes.py` file into the root of NTDSXtract.

## Usage
Both of the input files need to be in the correct format of `user:hash` and `hash:password`, as this was built without the ability to check formatting.

```sh
sh hashcompare.sh -i [user:hash input] -t [hash:password input] -o [output file]
```

### Formatting
In order to format the data correctly, until I update this (which probably won't happen), simply use the `cut` or `sed` utilities.

Example input:
```
:::user:PID:LM:NTLM:::
```

Example command:
```
cut -d: -f1,4 [inputfile
```

Example output:
```
user:NTLM
```