hashcompare
===========

User-Password Hash Comparison Tool v1.0
Simple utility that allows for the comparison between a file with a 'user:hash' format to a separate file with a 'hash:password' format. The comparison matches the hashes and returns an output file in the format 'user:password'

Example of 'user:hash' -> george:c21cfaebe1d69ac9e2e4e1e2dc383bac

Example of 'hash:password' -> c21cfaebe1d69ac9e2e4e1e2dc383bac:password

'user:hash' obtained from creddump suite: http://code.google.com/p/creddump/
     Note: Used custom 'dshashes.py' file: http://ptscripts.googlecode.com/svn/trunk/dshashes.py
'hash:password' obtained from ocl-Hashcat output



To use the utility, the files need to be in the specified format. I will work out a method to do format checking in the future.
If the files are not in 'user:hash" or "hash:password" format, simply use 'sed' or 'cut' in Cygwin or Linux.

Example: If the file has the format ":::user:PID:LM:NTLM:::" simply run 'cut -d: -f1,4 [inputfile]' which uses the delimeter ':' and retains the user:NTLM data.




Usage: sh hashcompare.sh -i [user:hash input] -t [hash:password input] -o [output file]
