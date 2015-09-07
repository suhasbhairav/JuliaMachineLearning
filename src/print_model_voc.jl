using AdaGram

vm, dict = load_model("/Users/alex/tmp/adagram/HugeModel");

println("word")
for word in dict.word2id
    if length(word) > 0
        println(word[1])
    end
end
