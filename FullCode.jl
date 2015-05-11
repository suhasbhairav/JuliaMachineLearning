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
			help = "Full path of the output csv"
	end
		
	return parse_args(args)
end

function begin_prg()	
	args = get_args()
	#Location of AdaGram installation	
	path = args["arg1"]
	
	#Location of Input File
	file = args["arg2"]	
		
	#Location of output file	
	file_output = args["arg3"]
	
	
	run(`/bin/bash $path/utils/tokenize.sh $file $path/utils/code_clean_out.txt`)
	run(`/bin/bash $path/utils/dictionary.sh $path/utils/code_clean_out.txt $path/utils/code_clean_dict.txt `)
	run(`/bin/bash $path/train.sh $path/utils/code_clean_out.txt $path/utils/code_clean_dict.txt $path/new_code_model`)
	vector_model, dictionary = load_model("$path/new_code_model")
	result_csv = open(file_output,"w")
	write(result_csv,"Word, Similar_Word,Sense_id,Semantic_Similarity\n")
	dict_keys = keys(dictionary.word2id)
	for x in dict_keys
		values=nearest_neighbors(vector_model,dictionary,x,1,100) 

		for y in values
			arr = [x]
			temp_tuple = x,values
			for z in y
				push!(arr,string(z))
			end
			write(result_csv,join(arr,","),"\n")
		println(temp_tuple)
						
		end		
		
	end
	close(result_csv)
end

begin_prg()
