#!/usr/bin/python
############################################
###          _                           ###
###__      _| | ___   __ _   _ __  _   _ ###
###\ \ /\ / / |/ _ \ / _` | | '_ \| | | |###
### \ V  V /| | (_) | (_| |_| |_) | |_| |###
###  \_/\_/ |_|\___/ \__, (_) .__/ \__, |###
###                  |___/  |_|    |___/ ###
############################################
# Imports
from platform import system
from os import environ, path, system as cmd, makedirs
from argparse import ArgumentParser
from datetime import datetime
from sys import argv
system = system()
if system == "Windows":
    log_dir = environ["USERPROFILE"] + "/Desktop/.dlogs" if environ["USERPROFILE"] is not None else "C:/Users/Public/Desktop/.dlogs"
    EDITOR = environ["EDITOR"] if environ["EDITOR"] is not None else "notepad"
else:
    log_dir = environ["HOME"] + "/.dlogs"
    EDITOR = environ["EDITOR"] if environ["EDITOR"] is not None else "nvim"
if len(argv) > 1:
    parser = ArgumentParser(description="A simple command line logger")
    parser.add_argument("-s", "--schedule", help="Write Schedule", required=False, action="store_true")
    parser.add_argument("-t", "--task", help="Write Task", required=False, action="store_true")
    parser.add_argument("-d", "--dream", help="Write Dream log", required=False, action="store_true")
    parser.add_argument("-p", "--personal", help="Write Personal log", required=False, action="store_true")
    args = parser.parse_args()
    is_schedule = args.schedule
    is_todo = args.task
    is_dream = args.dream
    is_personal = args.personal
    if is_schedule:
        log_dir += "/.Schedule/"
    elif is_todo:
        log_dir += "/.Todo/"
    elif is_dream:
        log_dir += "/.Dream/"
    elif is_personal:
        log_dir += "/.Personal/"
    else:
        log_dir += "/.Personal/"
else:
    log_dir += "/.Personal/"

tdate = str(round(int(datetime.now().strftime("%Y")), -1)) + "s/" + datetime.now().strftime("%Y") + "/" + datetime.now().strftime("%b") + "/" + datetime.now().strftime("%d-%m-%Y")
folder = log_dir + tdate
if system == "Windows":
    folder = folder.replace("/", "\\")
if not path.exists(folder) or not path.isdir:
    makedirs(folder)

file1 = folder + "/" + datetime.now().strftime("%d-%m-%Y") + ".md"
if system == "Windows":
    file1 = file1.replace("/", "\\")
cmd(EDITOR + " " + file1)
