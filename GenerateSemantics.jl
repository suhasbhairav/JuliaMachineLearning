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
	
	arr_length = Int[]
	vector_model, dictionary = load_model("$model_path")
	result_csv = open(file_output,"w")
	fopen = open(file)	
	f = readlines(fopen)
	write(result_csv,"Word\tSimilar_Word\tSense_id\tSemantic_Similarity\n")
	#dict_keys = keys(dictionary.word2id)
	arr = Any[]
	for x in f
		word = strip(string((x)))
		println(word)
		if(haskey(dictionary.word2id,word)==true)
			for i = 1:3				
				values=nearest_neighbors(vector_model,dictionary,word,i,50) 
				if(length(values)>0)
					for y in values
						empty!(arr)
						#push!(arr,x)
						temp_tuple = word,values
						for z in y
							push!(arr,string(z))
						end
						unshift!(arr,word)
						write(result_csv,join(arr,"\t"),"\n")
					println(temp_tuple)
					end
				end
			end				
		end		
		
	end
	close(result_csv)
end

begin_prg()
