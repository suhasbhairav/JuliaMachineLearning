The list of trained models:
https://www.dropbox.com/s/9hi948yhdmhkic3/HugeModel?dl=0
https://www.dropbox.com/s/dy17o6cf74g7xxv/LargeCorpusNewModel?dl=0

Anyone can download the models and use it to generate semantically similar words.


How to execute TrainModel.jl?

julia TrainModel.jl arg1 arg2 arg3

usage: TrainModel.jl [-h] [arg1] [arg2] [arg3]

positional arguments:
  arg1        Full path of AdaGram
  arg2        Full path of Input File
  arg3        Full path of the Model


How to execute GenerateSemantics.jl?

julia GenerateSemantics.jl arg1 arg2 arg3

usage: GenerateSemantics.jl [-h] [arg1] [arg2] [arg3]

positional arguments:
  arg1        Full path of Model
  arg2        Full path of Input File
  arg3        Full path of the output csv


