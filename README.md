# reportmerge
I. Purpose: To combine data from two csv files into a third, to extract data from these files into a categories.

II. Method: Check for presense of needed documents, change permissions of e-hallpass document, run script to merge documents and create meaningful data from the results

A. Variables: 
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
16. STUMINUTES - Path to temporary hold for minutes file
17. STUHOURS - Path to temporary hold for hours file
18. FINAL - Path to the final document
19. STUDENTFINAL - Path to the final student data document
20. COURSEFINAL - Path to the final course data document
21. SEMJUNK - Path to an interfunction document that is created and deleted
22. SECSEMJUNK - Path to an interfunction document used in the second semester that is created and deleted
23. JUNKFILE - Path to a interfunction document that is created and deleted
24. COURSEJUNK - Path to an interfunction document that checks for duplicate data
25. STUJUNK - Path to interfuction document that removes quotes from time
26. STARTYEAR - Sets the year of the first semester (change yearly)
27. DEBUG - path to debug file if debugging
28. IFS - Determines how to use white space delimiters (set for these purposes to ignore spaces as new lines) * helpful with names and courses with multiple spaces

B. Used: Logfiles for troubleshooting, debug for troubleshooting, loops for creating temp documents and deleting them

III. Script Outline: Set Variables, Adjust Permisions, Set up logs, Check for Documents, Create documents for holding data, Create hold documents for use in functions, Set Functions, Run Functions, Create Final Documents, Perform Cleanup

IV. Takeaways: Learned to use text files to manage variables in loops, learned IFS and general tips for formatting like "" inside a greped variable can lead to problems, spaces can lead to problems etc. 

V. Questions: What is the best method to provide a public readme?

VI. Troubleshooting: 

A. All Final documents are blank
  1. Resolution: Ensure the required documents and folders are in the right place and have the right name
    a. e-hallpass.csv is in ~/Desktop/reportmerge; courseandteacher.csv is in ~/Desktop/reportmerge
    b. Final-Report folder is in ~/Desktop/reportmerge; Course-Data folder is in ~/Desktop/reportmerge; Student-Data folder is in ~/Desktop/reportmerge
  
B. Number of tickets in the e-hallpass.csv file do not match the number of tickets in the final document
  1. Check that the logfiles show the correct semester function is in use, comment out incorrect semester function and run again
    a. Go to /var/log/reportmerge.log in console or in finder and check the last known good logfile
    b. If semester is incorrect, comment out incorrect semester in the if/then statement under "Run Functions" and try again
    c. Turn on debugging to see why incorrect semester is being used and adjust accordingly
      i. if the $STARTYEAR is incorrect set the correct one under "Set Variables"
      ii. if the $YEAR has quotes remove the quotes
  2. Pull up the csv in excel and check for duplicates under the second field
    a. this will locate any students who have more than one math class a semster and may account for the difference
    
C. One or more students have blanks where their classrooms should be or don't show up at all
  1. Check the courseandteacher.csv for the student and see if they have a class in the current semester
    a. if they do not have a class they are ignored for the totalling of the student visits
    
Build in file size limiter
Add script to folder for testing
Set up folder for holding scratch data
