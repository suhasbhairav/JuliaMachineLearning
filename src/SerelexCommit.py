# -*- coding: iso-8859-1 -*-
# import arg
import MySQLdb
import csv
import sys
from sys import argv
import os
import codecs
from traceback import format_exc
import argparse
from time import time 

VERBOSE = False
CHUNK_SIZE = 1000000

db = MySQLdb.connect("localhost","root","root","lsse")
cursor = db.cursor()
word_id_hash = {}
overall_relations_row_list = []


def read_input_csv(input_file, model_id, lang):
    relations_added = 0
    words_each_row = []
    relations_tuple = ()
    if os.path.isfile(input_file):
        csv_input_file = codecs.open(input_file,'r','utf-8')
        err_num = 0 
        for i, line in enumerate(csv_input_file):
            if i % 10000 == 0: print i
            try:
                row = line.strip().split("\t")
                tmp_word = row[0].split("/")
                word = tmp_word[0].lower()
                tmp_relation = row[1].split("/")
                relation = tmp_relation[0].lower()
                frequency = row[2]
                check_word_exists(MySQLdb.escape_string(word), model_id, lang)
                check_word_exists(MySQLdb.escape_string(relation), model_id, lang)

                relations_tuple = (int(word_id_hash[word]), int(model_id), int(word_id_hash[relation]), float(frequency))
                overall_relations_row_list.append(relations_tuple)
                if len(overall_relations_row_list) == CHUNK_SIZE:
                    relations_added = relations_added + len(overall_relations_row_list)
                    insert_relations(str(overall_relations_row_list).strip('[]'), relations_added)
                    del overall_relations_row_list[:]
                
                else:
                    continue
            except KeyboardInterrupt:
                sys.exit()
            except:
                if VERBOSE:
                    print "Error:", line
                    print format_exc()
                err_num += 1 
        print "Error number:", err_num
        relations_added = relations_added + len(overall_relations_row_list)
        insert_relations(str(overall_relations_row_list).strip('[]'), relations_added)
        del overall_relations_row_list[:]
                 
        
    else:
        print "File does not exist"

def insert_relations(relations_val, relations_added):
    sql = "INSERT INTO relations(word, model, relation, value) VALUES "+relations_val    
    cursor.execute(sql)
    db.commit()
    print "Relations inserted successfully."
    print "The number of relations added till now:", relations_added
    



def check_word_exists(word, model_id, lang):
    row = ""
    word_exists_in_hash = False        
    sql = "SELECT * from words WHERE word='" + word + "' AND lang='" + lang + "'"
    
    cursor.execute(sql)
    
    if cursor.rowcount != 1:
        row = insert_new_word(word, lang)
    else:
        row = cursor.fetchone()
    
   
    if row[1].lower() in word_id_hash:
        word_exists_in_hash = True
       
    if word_exists_in_hash == False:
        word_id_hash[row[1].lower().decode('utf-8')] = row[0]    
        
    
        


def insert_new_word(word, lang):
    sql = "INSERT INTO words(word, lang) VALUES('" + word + "','" + lang + "')"    
    cursor.execute(sql)
    db.commit()
    
    sql = "SELECT * from words WHERE word='" + word + "' AND lang='" + lang + "'"
    cursor.execute(sql)
    if cursor.rowcount == 1:
        row = cursor.fetchone()
        
        return row            
    
            

def insert_model(model, lang):    
    print "No models with the name:", model
    sql = "INSERT INTO models(name, lang) VALUES('" + model + "','" + lang + "')"
    cursor.execute(sql)
    db.commit()
    print "Model:" + model + " added successfully."            
     


def check_model(model, lang):
    sql = "SELECT id FROM models WHERE name='" + model +"' AND lang='" + lang + "'"
    cursor.execute(sql)
    if cursor.rowcount == 1:
        row_model = cursor.fetchone()
        
        return row_model[0]
    else:
        return -1
        


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Loading relations to the database")
    parser.add_argument("csv_input", help="The full path to the input csv containing relations in the format word\\trelation\\tfrequency")
    parser.add_argument("model", help="Name of the model. If the model name contains spaces, enclose it within double quotes. The spaces will be replaced by underscore while displaying.")
    parser.add_argument("lang", help="Language of the model. Mention en, ru , fr, etc..")
    args = parser.parse_args()
    input_file = args.csv_input
    model = args.model
    model = model.replace(" ","_")
    lang = args.lang
    

    print >> sys.stderr, "CSV Input:", input_file
    print >> sys.stderr, "Model:", model
    print >> sys.stderr, "Lang:", lang 
    """if len(sys.argv) < 3:
        print ("How to run the file?")
        print ("argv[1]:Location of the input csv")
        print ("argv[2]:Model name")
        print ("argv[3]:Language of the model: en, ru or fr")
        exit(0)
    model_id = -1    
    input_file = argv[1]
    model = argv[2]
    lang = argv[3]
    """
    model_id = check_model(model, lang) 
    if model_id == -1:
        insert_model(model, lang)
        model_id = check_model(model,lang)        
    
    read_input_csv(input_file, model_id, lang)
    

