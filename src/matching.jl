using ArgParse
using AdaGram

function get_args()
  args = ArgParseSettings()
  @add_arg_table args begin
    "definitions"
      help = "Input definitions of senses in the format 'word<TAB>sense_i<TAB>sense_i_cluster"
    "model"
      help = "A trained AdaGram model"
    #"output"
    #  help = "Output csv with the matched senses in the following format: 'word<TAB>sense_i<TAB>sense_j<TAB>sim<TAB>sense_i_cluster<TAB>sense_j_cluster'"
  end

  return parse_args(args)
end

function main()
	# parse arguments
  args = get_args()
	model_fpath = args["model"]
	definitions_fpath = args["definitions"]
	output_fpath = string(definitions_fpath,"-match.csv")

  # initialize
	output_file = open(output_fpath,"w")
  definitions_file = open(definitions_fpath,"r")
	vector_model, dictionary = load_model(model_fpath)

  # save relations
	write(output_file,"word\tsense_i\tsense_j\tsim\tsense_i_cluster\tsense_j_cluster\n")

  line_num = 0
	for line in readlines(definitions_file)
	  line_num += 1
    f = split(line, "\t");
    if (length(f) != 3)
        println("Bad line: ",line);
        continue;
    end

    word, sense_i, sense_i_cluster = split(line, "\t");
    sense_probs = disambiguate(vector_model, dictionary, strip(word), split(sense_i_cluster));
    max_sense_prob_index = indmax(sense_probs);
    max_sense_prob = sense_probs[max_sense_prob_index];
    similar_words = nearest_neighbors(vector_model, dictionary, word, max_sense_prob_index, 20);
    sense_j_cluster = "";
    for sword in similar_words
      sense_j_cluster = string(sense_j_cluster, " ",  sword[1]);
    end
    sense_j_cluster = strip(sense_j_cluster);

    write(output_file, word, "\t", sense_i, "\t", string(max_sense_prob), "\t", sense_i_cluster, "\t", sense_j_cluster, "\n")
    flush(output_file);
    print(". ");
  end
	close(output_file)
  close(definitions_file)
  println("Output: ", output_fpath)
end

main()
