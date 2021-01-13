import tkinter as tk
from tkinter import *
from tkinter import ttk
import time
import numpy as np
from threading import Thread, Event
from time import sleep
import time
import sys
from threading import Timer
from PIL import ImageTk, Image
import random
import tkinter as tk 
from tkinter import ttk
import collections
from collections import OrderedDict 

LARGEFONT =("Verdana", 35)
class HomePage:
    def __init__(self, root, word_list):
        # establish grid
        root.grid_rowconfigure((0,1,2,3,4,5,6,7,8), weight = 1)
        root.grid_columnconfigure((0,1,2,3,4,5,6,7,8), weight = 1)
        # root
        self.root = root
        # title
        self.label = ttk.Label(root, text ="Inner Speech Recorder", font = LARGEFONT) 
        self.label.grid(row = 0, column = 4, padx = 10, pady = 10)
        # button to begin recording
        button_start_experiment = ttk.Button(root, text = "Start Experiment", command = self.run_experiment)#(controller))#lambda : controller.show_frame(Page1))
        button_start_experiment.grid(row = 2, column = 4)
        # table containing number of experiment instances and file name to save as
        prompt_array = ["Number of Experiment Instances", "File Name"]
        self.experiment_parameters = Table(root, prompt_array, 1, 1)
        # text displaying word to inner speak
        self.word = Entry(root, textvariable = "")
        self.word.grid(row = 3, column = 4)
    

        # instance variable for the word list
        self.word_list = word_list
    def run_experiment(self, display_time = 5000, buffer_time = 2000):
        experiment_parameters = self.experiment_parameters.Table_get_dict()
        print(experiment_parameters["Number of Experiment Instances"].get())
        num_experiment_instances = int(experiment_parameters["Number of Experiment Instances"].get())
        file_name = experiment_parameters["File Name"]
        for i in range(num_experiment_instances):
            print("test")
            word_choice = random.choice(self.word_list)
            self.root.after(display_time + i * (display_time + buffer_time), lambda: self.word.delete(0, "end"))
            self.root.after((display_time + buffer_time) + i * (display_time + buffer_time), lambda: self.word.insert(0, random.choice(self.word_list)))
        print("Done")
##            self.root.after(display_time + i * (display_time + buffer_time), print("M"))
##            self.root.after((display_time + buffer_time) + i * (display_time + buffer_time), print("N"))
     
            
##            prev_time = time.perf_counter()
##            print(prev_time)
##            word_choice = random.choice(self.word_list)
##            print(word_choice)
##            self.word.delete(0, "end")
##            a = True
##            b = True
##            while a:
##                current_time = time.perf_counter()
##                if (current_time - prev_time) > buffer_time and (current_time - prev_time) < (buffer_time + display_time) and b:
##                    print("First")
##                    #prev_time = current_time
##                    self.word.insert(0, word_choice)
##                    b = False
##                if (current_time - prev_time) > (buffer_time + display_time):
##                    print("second")
##                    a = False
                
                    
                
                
                
        
      


class Table:
    def __init__(self, root, prompt_array, x_pos, y_pos, table_name = ""):
        # create frame
        table_frame = LabelFrame(root, text = table_name, padx = 20, pady = 30, borderwidth = 0, highlightthickness = 0) # create frame
        table_frame.grid(row = x_pos, column = y_pos)
        self.table_dict = collections.OrderedDict([(prompt, Entry(table_frame, textvariable = "")) for prompt in prompt_array])
        self.table_length = len(prompt_array)
        # display prompts and entries
        for prompt, cell, pos in zip(self.table_dict, self.table_dict.values(), range(self.table_length)): # specify positions of entries
            tk.Label(table_frame, text = prompt).grid(row=pos, column = 0)
            cell.grid(row = pos, column = 1) # assume table being used within a frame
    def Table_get_dict(self):
        return self.table_dict
        
        
        


## main ##
root = tk.Tk()
WIDTH = 1000
HEIGHT = 400
word_list = ["book", "dog", "cup", "cheese"]
root.geometry(str(WIDTH) + "x" + str(HEIGHT))
homepage = HomePage(root, word_list)
root.mainloop()
        
