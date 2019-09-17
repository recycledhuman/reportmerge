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
SCRIPT - sets script name and provides (may cut...not necessary can be merged with logfile)
LOGFILE - sets name of the log file in use (useful for testing purposes to switch the name once the final product is in order)
NOW - sets the current time (used several times for logging purposes - shows the timestamps of when events occurred)
WHO - checks the currently logged in users (does not include local admin and takes only the first instance of the named user)
WEEKLY - Shows the expected path to the weekly report
QUARTERLY - Shows the expected path to the quarterly report may want to tuck this away elsewhere
HOLDING - Path to the general holding document used for appending output of functions to a resting place before transferring to the final document
HEADER - General header added after creating the holding document (adjust for needed fields)
STUDENTHOLDING - Path to the student data document used for appending output of functions to a resting place before transferring to the final document
STUDENTHEADER - Student header added after creating the holding document (adjust for needed fields)
COURSEHOLDING - Path to the course data document used for appending output of functions to a resting place before transferring to the final document
COURSEHEADER- Course header added after creating the holding document (adjust for needed fields)
YEAR - Grabs the current year from the system
CUTOFF - Sets the cutoff date for the start of the second semester for sorting purposes
DATEMDY - pulls the month day and year of the current day to add to the end of the final documents allowing to easily search through the history of documents created
FINAL - Path to the final document
STUDENTFINAL - Path to the final student data document
COURSEFINAL - Path to the final course data document
SEMJUNK - Path to an interfunction document that is created and deleted
SECSEMJUNK - Path to an interfunction document used in the second semester that is created and deleted
JUNKFILE - Path to a interfunction document that is created and deleted
COURSEJUNK - Path to an interfunction document that checks for duplicate data
STARTYEAR - Sets the year of the first semester (change yearly)
IFS - Determines how to use white space delimiters (set for these purposes to ignore spaces as new lines) * helpful with names and courses with multiple spaces

