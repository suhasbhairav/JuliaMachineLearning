using ArgParse
using AdaGram

function get_args()
	args = ArgParseSettings()
	@add_arg_table args begin
		"arg1"
			help = "Full path of Model"
		"arg2"
			help = "Full path of Input File"
		"arg3"
			help = "Full path of the output csv"
	end
		
	return parse_args(args)
end

function begin_prg()	
	args = get_args()
	#Full path of model	
	model_path = args["arg1"]
	
	#Location of Input File
	file = args["arg2"]	
		
	#Location of output file	
	file_output = args["arg3"]
	
	vector_model, dictionary = load_model("$model_path")
	result_csv = open(file_output,"w")
	fopen = open(file)	
	f = readlines(fopen)
	write(result_csv,"Word, Similar_Word,Sense_id,Semantic_Similarity\n")
	#dict_keys = keys(dictionary.word2id)
	
	for x in f
		word = strip(x)
		println(word)
		for i = 1:3	
			values=nearest_neighbors(vector_model,dictionary,word,i,20) 
		
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
		
	end
	close(result_csv)
end

begin_prg()
