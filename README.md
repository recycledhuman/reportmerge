# reportmerge
To combine data from two csv files into a third.

Concept - create a txt file, load variables from static document for email - course - teacher, check each line of variable document against the emails in the variable field and combine the output to a third document, write the third document to a csv file and place on the desktop of the current logged in user.

Thoughts: 
1. Need to provide checks to confirm all needed documents exist
  a. all needed documents are recent (?)
  b. move a copy of the old file to an archive
2. Set up log files
  a. document if needed documents don't exist
  b. document if files are not recent
  c. document moves to archives
3. Set up error reporting
4. List of pitfalls so far encountered
  a. spaces in names/courses create line breaks when read by grep into a variable
  b. can be fixed by awking in "+" between each potential break
    i. this looks really bad due to needing to convert twice with multiple new txt documents to hold it in place
  c. experienced issue with randomly failing to run script - unsure as to cause
  
Variables Used
1. SCRIPT - sets script name and provides (may cut...not necessary can be merged with logfile)
2. LOGFILE - sets name of the log file in use (useful for testing purposes to switch the name once the final product is in order)
3. NOW - sets the current time (used several times for logging purposes - shows the timestamps of when events occurred)
4. WHO - checks the currently logged in users (does not include local admin and takes only the first instance of the named user)
5. WEEKLY - Shows the expected path to the weekly report
6. QUARTERLY - Shows the expected path to the quarterly report may want to tuck this away elsewhere
7. HOLDING - Path to the general holding document used for appending output of functions to a resting place before transferring to the final document
8. HEADER - General header added after creating the holding document (adjust for needed fields)
9. STUDENTHOLDING - Path to the student data document used for appending output of functions to a resting place before transferring to the final document
10. STUDENTHEADER - Student header added after creating the holding document (adjust for needed fields)
11. COURSEHOLDING - Path to the course data document used for appending output of functions to a resting place before transferring to the final document
12. COURSEHEADER- Course header added after creating the holding document (adjust for needed fields)
13. YEAR - Grabs the current year from the system
14. CUTOFF - Sets the cutoff date for the start of the second semester for sorting purposes
15. DATEMDY - pulls the month day and year of the current day to add to the end of the final documents allowing to easily search through the history of documents created
16. FINAL - Path to the final document
17. STUDENTFINAL - Path to the final student data document
18. COURSEFINAL - Path to the final course data document
19. SEMJUNK - Path to an interfunction document that is created and deleted
20. SECSEMJUNK - Path to an interfunction document used in the second semester that is created and deleted
21. JUNKFILE - Path to a interfunction document that is created and deleted
22. COURSEJUNK - Path to an interfunction document that checks for duplicate data
23. STARTYEAR - Sets the year of the first semester (change yearly)
24. IFS - Determines how to use white space delimiters (set for these purposes to ignore spaces as new lines) * helpful with names and courses with multiple spaces
