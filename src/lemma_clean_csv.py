import argparse
import codecs
import os
import sys
import subprocess

def main(f_in, f_out):
    f_read = codecs.open(f_in, encoding = 'utf-8')
    f_write = codecs.open(f_out, encoding= 'utf-8', mode='w')
    line_content = ""
    for line in f_read:
        if len(line.strip()) > 0:
           # line_content = line_content + line.rstrip()+ " "
            f_write.write(line.rstrip()+" ")
        else:
           # line_content = line_content + line
            f_write.write(line)
    #print line_content
    f_write.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(" Cleaning content in files...")
    parser.add_argument("input_file", help="Full path to the input csv file to be lemmatized")
    parser.add_argument("output_file", help="Full path to the output file")

    args = parser.parse_args()
    file_in = args.input_file
    file_out = args.output_file

    try:
        if not os.path.isfile(file_in):
            print "Input file does not exist"
            sys.exit(0)
        else:
            p1 = subprocess.Popen('cut -f 3 '+ file_in +' | head -100 > tmp'+file_in, stdout=subprocess.PIPE)
            stdout_val = p.communicate()[0]
            main("tmp"+file_in, file_out)
    except:
        e = sys.exc_info()[0]
        "Error while cleaning the file"
