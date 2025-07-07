#! /usr/bin/env python3
# Script_name     : clipit_preload.py
# Author          : RCSD
# Description     : Several tools for python
# Version         : v1.0
#                   v1.1 (added clipit offline mode)
#                   v1.2 (remove sleep, clipit 1.4.5 minor issues with Ubuntu 20.04)

import sys
import re
import subprocess as sp             # Shell execution
import argparse                     # Parse args
# PYTHON_ARGCOMPLETE_OK
import argcomplete
import time                         # Delay

def run(args):
    # Parse args
    textfile = args.textfile        # these match the "dest": dest="input"
    with open(textfile) as f:
        textlist = f.read().splitlines();   # Convert string buffer to list of lines
        n = 0
        print ("Starting clipit...")
        command = "clipit"
        sp.Popen (command, shell=True)      # Run in background
        print ("Feeding clipit...")
        for line in textlist:
            command = "clipit "+line
            n = n + 1
            #print ("  " + str(n) + ". " + command)
            sp.run (command, check=True, shell=True)
            #time.sleep(0.2) # Bug in clipit: it does not store all values if delay is less
        print ("Submitted " + str(n) + " comments")
        # Simulate send hotkeys Control+Alt+o for offline mode
        command = "xdotool key Control_L+Alt_L+o" #Use xev for finding out the keys combination
        sp.run (command, check=True, shell=True)
        print ("Clipit offline mode enabled after first use")
        print ("Remove previous history for better results")
    return 0

def main():
    parser=argparse.ArgumentParser(description="Preload clipit multi clipboard with text from file",
                                   epilog="Prerequisites: Text file with a comment per line")
    parser.add_argument("-f",help="file.txt" ,dest="textfile", type=str, required=True)
    parser.set_defaults(func=run)
    argcomplete.autocomplete(parser)
    args=parser.parse_args()
    args.func(args)

if __name__ == '__main__':
    sys.exit(main())
