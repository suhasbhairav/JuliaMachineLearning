# ju is a patched julia of adagram (run.sh)
# ju generate_ddt.jl ../../HugeModel ~/work/joint/src/data/ambigous-words.csv ~/tmp/matching/agagram-hugemodel-ambigous-200.csv 200

using ArgParse
using AdaGram

function get_args()
	args = ArgParseSettings()
	@add_arg_table args begin
		"model"
			help = "Full path to a trained AdaGram model"
		"voc"
			help = "Full path to an input vocabulary file (one word per line)"
		"output"
			help = "Full path of the output csv file with the DDT"
        "sim_num"
          help = "Number of similar words for each DDT entry, e.g. 10"
	end

	return parse_args(args)
end

function main()
	# parse arguments
  args = get_args()
	model_fpath = args["model"]
	voc_fpath = args["voc"]
	output_fpath = args["output"]
  similar_words_num = args["sim_num"]

  # initialize
	arr_length = Int[]
	vector_model, dictionary = load_model("$model_fpath")
	output_file = open(output_fpath,"w")
	voc_file = open(voc_fpath)

  # save relations
	write(output_file,"src\tsrc_sense\tsrc_sense_prob\tdst\tdst_sense\tsim\n")
	arr = Any[]
  sense_apriori = Any[]

  line_num = 0
	for word in readlines(voc_file)
	  line_num += 1
    word = strip(string((word)))
		if(line_num == 1 || haskey(dictionary.word2id,word)==false)
      continue
    end
    empty!(sense_apriori)
    sense_apriori = expected_pi(vector_model,dictionary.word2id[word])
    println(word,"\t",length(word))

    for i = 1:length(sense_apriori)
      similar_words=nearest_neighbors(vector_model,dictionary,word,i,parseint(similar_words_num))
      if(length(similar_words)<=0)
        continue
      end
      for sword in similar_words
        if(sword[3]==Inf || sword[3]== -Inf || sword[3]==Inf16 || sword[3]==-Inf16 || sword[3]==Inf32 || sword[3]==-Inf32)
          continue
        end

        empty!(arr)
        temp_tuple = word,similar_words

        for e in sword
          push!(arr,string(e))
        end
        unshift!(arr,round(sense_apriori[i],3))
        unshift!(arr,i)
        unshift!(arr,word)
        write(output_file,join(arr,"\t"),"\n")
      end
    end
  end
	close(output_file)
  run(`sort -k 1,1 -k 2,2n -k 3,3rn -k 6,6rn $output_fpath`)
end

main()
