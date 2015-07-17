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
        "arg4"
            help = "No of similar words. Eg:10"
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
	
    #No of similar words
    no_of_similar_words = args["arg4"]

	arr_length = Int[]
	vector_model, dictionary = load_model("$model_path")
	result_csv = open(file_output,"w")
	fopen = open(file)	
	f = readlines(fopen)
	write(result_csv,"Word\tSrc-Sense_id\tSenseProb\tSimilar_Word\tDest_Sense_id\tSemantic_Similarity\n")
	#dict_keys = keys(dictionary.word2id)
	arr = Any[]
    arr_expected_pi = Any[]
	for x in f
		word = strip(string((x)))
		println(word)
		if(haskey(dictionary.word2id,word)==true)
            empty!(arr_expected_pi)
            arr_expected_pi = expected_pi(vector_model,dictionary.word2id[word])
			for i = 1:length(arr_expected_pi)				
				values=nearest_neighbors(vector_model,dictionary,word,i,parseint(no_of_similar_words)) 
				if(length(values)>0)
					for y in values
                        println(y)
                        if(y[3]!=Inf && y[3]!= -Inf && y[3]!=Inf16 && y[3]!=-Inf16 && y[3]!=Inf32 && y[3]!=-Inf32)
                            empty!(arr)
						    #push!(arr,x)
						    temp_tuple = word,values
						
                            for z in y
							    push!(arr,string(z))
						    end
                            unshift!(arr,round(arr_expected_pi[i],3))
                            unshift!(arr,i)
						    unshift!(arr,word)
						    write(result_csv,join(arr,"\t"),"\n")
				        end
                       # println(temp_tuple)
					end
				end
			end				
		end		
		
	end
	close(result_csv)
   # file_sort = string($file_output,"_sort")
     run(`sort -k 1,1 -k 2,2n -k 3,3rn -k 6,6rn $file_output`)
    #run(`sed -i -e '1iWord\tSrc-Sense_id\tSenseProb\tSimilar_Word\tDest_Sense_id\tSemantic_Similarity\n' $file_sort`)
end

begin_prg()
