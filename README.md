The list of trained models:
----------
- Wacky raw: https://www.dropbox.com/s/9hi948yhdmhkic3/HugeModel?dl=0
- Wacky+ukWaC raw: https://www.dropbox.com/s/dy17o6cf74g7xxv/LargeCorpusNewModel?dl=0

How to execute TrainModel.jl?
----

```
julia TrainModel.jl arg1 arg2 arg3

usage: TrainModel.jl [-h] [arg1] [arg2] [arg3]

positional arguments:
  arg1        Full path of AdaGram
  arg2        Full path of Input File
  arg3        Full path of the Model
```

How to execute GenerateSemantics.jl?
-----

```
julia GenerateSemantics.jl arg1 arg2 arg3

usage: GenerateSemantics.jl [-h] [arg1] [arg2] [arg3]

positional arguments:
  arg1        Full path of Model
  arg2        Full path of Input File
  arg3        Full path of the output csv
```

Installation of julia from source:
--------

1) Open command line and type: git clone git://github/com/JuliaLang/julia.git
2) Now open the directory and run: git checkout release-0.3
3) Now run “make”. This will generate the julia executable. (This will take atleast an hour)
4) Now once the julia executable is created, we can execute it by specifying the path to the julia executable in the command prompt to display the julia prompt.

Installation of AdaGram:
--------

1)Now specify the following command to clone the AdaGram from github.
/home/user/julia/julia/julia -e 'Pkg.clone(“https://github.com/sbos/AdaGram.jl.git”)'
2)Now, run the command:
/home/user/julia/julia/julia -e 'Pkg.clone(“AdaGram”)'

Note:- 
1) Step 2 in “Installation of AdaGram” will not run if clang is not installed. Usually, an error will be thrown saying clang is not installed. To overcome this, open the build.sh file. Comment the if-else section  that checks for the location of clang installation and replace export CC = “clang” with export CC=”gcc” before the if-else section(The section that is checking for clang installation):

```
export CC="gcc"

#  if clang >/dev/null 2>&1 ; then
# 	 echo "clang is not installed, switching to gcc"
#       export CC="gcc"
#  fi
```

2) Run build.sh
