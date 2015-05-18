using ArgParse
using AdaGram

function get_args()
	args = ArgParseSettings()
	@add_arg_table args begin
		"arg1"
			help = "Full path of AdaGram"
		"arg2"
			help = "Full path of Input File"
		"arg3"
			help = "Full path of the Model"
	end
		
	return parse_args(args)
end

function begin_train()	
	args = get_args()
	#Location of AdaGram installation	
	path = args["arg1"]
	
	#Location of Input File
	file = args["arg2"]	
		
	#Location of Model	
	model = args["arg3"]
	
	
	#run(`/bin/bash $path/utils/tokenize.sh $file $path/utils/code_clean_out.txt`)
	#run(`/bin/bash $path/utils/dictionary.sh $path/utils/code_clean_out.txt $path/utils/code_clean_dict.txt `)
	#run(`/bin/bash $path/train.sh $path/utils/code_clean_out.txt $path/utils/code_clean_dict.txt $model`)
end

begin_train()
