# README.md

# Implementation Instructions:

1. Work in the bin directory, then run: `make clean compile`
2. **Create Directory:** Create a directory named text_files and place some .txt files in it.
3. **Compile:** Compile the Java files: javac WordCounterMaster.java WordCounterWorker.java
4. **Run:** Execute the master process: `java WordCounterMaster`

# Explanation:

**Master Process (WordCounterMaster):**
1. It iterates through the .txt files in the text_files directory using Files.newDirectoryStream().
2. For each file, it creates a WordCounterWorker sub-process using ProcessBuilder.
3. It waits for all sub-processes to finish using p.waitFor().
4. It reads the results from the shared file word_counts.txt and prints them.

**Sub-Process (WordCounterWorker):**
1. It receives the file path and shared file path as command-line arguments.
2. It reads the file line by line using Files.lines().
3. It splits each line into words using line.split("\\s+").
4. It counts the words using count().
5. It writes the file name and word count to the shared file.

# Key Improvements:

1. **Dynamic File Handling:** The master process dynamically handles any number of text files in the specified directory.
2. **Clear Results:** The shared file stores results in a readable format (filename: word count).
3. **Error Handling:** while not fully implemented, the file io, and process creation are contained in try catch blocks.

This example demonstrates how to effectively use multi-processing for parallel file processing, a common task in many applications.