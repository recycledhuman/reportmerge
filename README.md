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
  
