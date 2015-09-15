using ArgParse
using AdaGram

function get_args()
  args = ArgParseSettings()
  @add_arg_table args begin
    "definitions"
      help = "Input definitions of senses in the format 'word<TAB>sense_i<TAB>sense_i_cluster"
    "model"
      help = "A trained AdaGram model"
    "output"
      help = "Output file in the format 'word<TAB>sense_i<TAB>sense_j<TAB>sim<TAB>sense_i_cluster<TAB>sense_j_cluster'"
    "related"
      help = "Output related words for AdaGram (takes much more time)"
  end

  return parse_args(args)
end

function main()
	# parse arguments
  args = get_args()
	model_fpath = args["model"]
	definitions_fpath = args["definitions"]
	output_fpath = args["output"]
  calculate_similar_words = lowercase(args["related"]) == "true"

  # initialize
	output_file = open(output_fpath,"w")
  definitions_file = open(definitions_fpath,"r")
	vector_model, dictionary = load_model(model_fpath)

  # save relations
	# write(output_file,"word\tsense_i\tsense_j\tsim\tsense_i_cluster\tsense_j_cluster\n")
  write(output_file,"word\tgolden_id\tadagram_id\tadagram_prob\tcontext\n")

  line_num = 0
	for line in readlines(definitions_file)
	  line_num += 1
    f = split(line, "\t");
    if (length(f) != 3)
        println("Bad line: ",line);
        continue;
    end

    word, sense_i, sense_i_cluster = split(line, "\t");
    sense_i_cluster = strip(sense_i_cluster);
    sense_probs = disambiguate(vector_model, dictionary, strip(word), split(sense_i_cluster));
    max_sense_prob_index = indmax(sense_probs);
    max_sense_prob = sense_probs[max_sense_prob_index];

    if (calculate_similar_words)
      similar_words = nearest_neighbors(vector_model, dictionary, word, max_sense_prob_index, 200);
      sense_j_cluster = "";
      for sword in similar_words
        sense_j_cluster = string(sense_j_cluster, " ",  sword[1]);
      end
      sense_j_cluster = strip(sense_j_cluster);
    else
      sense_j_cluster = "";
    end
    write(output_file, word, "\t", sense_i, "\t", string(max_sense_prob_index),
          "\t", string(max_sense_prob), "\t", sense_i_cluster, "\n")
    flush(output_file);
    print(". ");
  end
	close(output_file)
  close(definitions_file)
  println("\nOutput: ", output_fpath)
end

main()
