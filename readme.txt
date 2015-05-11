The script can be used to run AdaGram. This script automatically runs tokenize.sh, dictionary.sh, trains the model and then produces the output.

How to run the script?
	The script accepts three command line arguments. They are as follows:
	arg1 - Full path to AdaGram Installation
	arg2 - Full path to the input file (csv or txt)
	arg3 - Full path to the final output file (csv)
	
Example :
julia FullCode.jl /home/username/.julia/v0.3/AdaGram/ /home/username/input.csv /home/username/result.csv


Note:-
The code has been tested on Ubuntu 14.04 LTS. It requires a 64-bit Julia installation.
	