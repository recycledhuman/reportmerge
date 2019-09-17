#!/bin/bash
#CSV editor customized to add fields to the reporting provided by e-hallpass and provide data based on input 

#Set Variables
SCRIPT="reportmerge"
LOGFILE="$SCRIPT.log"
NOW="$(Date +"%m/%d/%Y %H:%M")"
WHO=$(who -s | awk '{print $1;}' | grep -v "local_mac" | head -n 1)
WEEKLY="/Users/$WHO/Desktop/reportmerge/e-hallpass.csv"
QUARTERLY="/Users/$WHO/Desktop/reportmerge/courseandteacher.csv"
HOLDING="/Users/$WHO/Desktop/reportmerge/holding.txt"
HEADER=$(sed -n 1p $WEEKLY | cut -d, -f1,2,3,4,5,9,11)
STUDENTHOLDING="/Users/$WHO/Desktop/reportmerge/Student-Data/stuholding.txt"
STUDENTHEADER="Email,Visits,Total-H:MM,Avg-H:MM,Course"
COURSEHOLDING="/Users/$WHO/Desktop/reportmerge/Course-Data/courseholding.txt"
COURSEHEADER="Course,Unique,Total"
YEAR=$(Date +"%Y")
CUTOFF="1/22/20"
DATEMDY="$(Date +"%m-%d-%Y")"
STUMINUTES="/Users/$WHO/Desktop/reportmerge/minutes.txt"
STUHOURS="/Users/$WHO/Desktop/reportmerge/hours.txt"
FINAL="/Users/$WHO/Desktop/reportmerge/Final-Report/final-$DATEMDY.csv"
STUDENTFINAL="/Users/$WHO/Desktop/reportmerge/Student-Data/studenttotals-$DATEMDY.csv"
COURSEFINAL="/Users/$WHO/Desktop/reportmerge/Course-Data/coursetotal-$DATEMDY.csv"
SEMJUNK="/Users/$WHO/Desktop/reportmerge/semjunk.txt"
SECSEMJUNK="/Users/$WHO/Desktop/reportmerge/secsemjunk.txt"
JUNKFILE="/Users/$WHO/Desktop/reportmerge/junkfile.txt"
COURSEJUNK="/Users/$WHO/Desktop/reportmerge/coursejunk.txt"
STUJUNK="/Users/$WHO/Desktop/reportmerge/stujunk.txt"
STARTYEAR=2019
DEBUG="/Users/$WHO/Desktop/reportmerge/debug-$LOGFILE"
SIZE=$(ls -l /var/log/$LOGFILE.log | awk '{print $5;}')
MAXSIZE=5000
IFS=$'\n'

#Provide appropriate permissions to weekly file
chmod 755 $WEEKLY

#Set up logs
touch /var/log/$LOGFILE
echo "Logfile size = $SIZE - Checking" >> /var/log/"$LOGFILE"
if [ "$SIZE" -ge "$MAXSIZE" ]
	then
		echo "File cleared - Proceed" >> /var/log/"$LOGFILE"
		rm -rf /var/log/"$LOGFILE"
	else
		echo "File size is sufficient - Proceed" >> /var/log/"$LOGFILE"
fi

echo "----Starting Script $SCRIPT - $NOW----" >> /var/log/$LOGFILE

#Output WHO variable for error logging
echo "User = $WHO" >> /var/log/"$LOGFILE"

#Check for documents
if [ -f "$WEEKLY" ]
	then
		echo "Weekly file present - Proceed" >> /var/log/$LOGFILE
	else
		echo "ERROR 1: Weekly file not present; Exiting" >> /var/log/$LOGFILE
		jamf displayMessage -message "Missing e-hallpass.csv file, file name must match: Exiting script"
		exit 1
fi

if [ -f "$QUARTERLY" ]
	then
		echo "Quarterly file present - Proceed" >> /var/log/$LOGFILE
	else
		echo "ERROR 2: Quarterly file not present; Exiting" >> /var/log/$LOGFILE
		jamf displayMessage -message "Missing courseandteacher.csv file, file name must match: Exiting script"
		exit 2
fi

#Create text document to hold data as it is generated and set the header
touch $HOLDING
echo "$HEADER,\"Course\",\"Teacher\"" >> $HOLDING
touch $STUDENTHOLDING
echo "$STUDENTHEADER" >> $STUDENTHOLDING
touch $COURSEHOLDING
echo "$COURSEHEADER" >> $COURSEHOLDING

#Create hold location for text used in functions
touch $JUNKFILE
touch $COURSEJUNK

#Set Functions - find course and teachers and match it with student data

getFirstSemWeeklyNames ()
{
NAMES=`(grep -v "Status /Comments" "$WEEKLY" | cut -d, -f1,2,3,4,5)`
touch $SEMJUNK
for ScannedName in $NAMES
	do
		echo "$ScannedName" >> $SEMJUNK
#		echo "DEBUG: \$ScannedName is $ScannedName" >> $DEBUG
		EMAIL=$(sed -n 1p $SEMJUNK | awk -F'\"' '{print $10;}')
#		echo "DEBUG: \$EMAIL is $EMAIL" >> $DEBUG
		DATA=$(sed -n 1p $SEMJUNK)
		REASONTIME=$(grep "$DATA" "$WEEKLY" | cut -d, -f9,11)
		rm -rf $SEMJUNK 
		FIRSTCOURSE=$(grep $EMAIL $QUARTERLY | grep -v $CUTOFF | sed -n 1p | cut -d, -f1,6)
#		echo "DEBUG: \$FIRSTCOURSE is $FIRSTCOURSE" >> $DEBUG
		SECONDCOURSE=$(grep "$EMAIL" "$QUARTERLY" | grep -v $CUTOFF | sed -n 2p | cut -d, -f1,6)
		THIRDCOURSE=$(grep "$EMAIL" "$QUARTERLY" | grep -v $CUTOFF | sed -n 3p | cut -d, -f1,6)
		FOURTHCOURSE=$(grep "$EMAIL" "$QUARTERLY" | grep -v $CUTOFF | sed -n 4p | cut -d, -f1,6)
		if [ "$FIRSTCOURSE" != "" ]
			then
				echo "$DATA,$REASONTIME,$FIRSTCOURSE\"" >> $HOLDING
					if [ "$SECONDCOURSE" != "" ]
						then
							echo "$DATA,$REASONTIME,$SECONDCOURSE\"" >> $HOLDING
								if [ "$THIRDCOURSE" != "" ]
									then
										echo "$DATA,$REASONTIME,$THIRDCOURSE\"" >> $HOLDING
											if [ "$FOURTHCOURSE" != "" ]
												then
													echo "$DATA,$REASONTIME,$FOURTHCOURSE\"" >> $HOLDING
											fi
								fi
					fi
		fi			
	done
}

getSecondSemWeeklyNames ()
{
SECONDNAMES=`(grep -v "Status /Comments" "$WEEKLY" | cut -d, -f1,2,3,4,5)`
touch $SECSEMJUNK
for SecondScannedName in $SECONDNAMES
	do
		echo "$SecondScannedName" >> "$SECSEMJUNK"
#               echo "DEBUG: \$SecondScannedName is $SecondScannedName" >> $DEBUG
                SECONDEMAIL=$(sed -n 1p "$SECSEMJUNK" | awk -F'\"' '{print $10;}')
#               echo "DEBUG: \$SECONDEMAIL is $SECONDEMAIL" >> $DEBUG
                SECONDDATA=$(sed -n 1p "$SECSEMJUNK") 
		SECONDREASONTIME=$(grep "$SECONDDATA" "$WEEKLY" | cut -d, -f9,11)
		rm -rf "$SECSEMJUNK" 
		SECONDFIRSTCOURSE=$(grep "$SECONDEMAIL" "$QUARTERLY" | grep "$CUTOFF" | sed -n 1p | cut -d, -f1,6)
#               echo "DEBUG: \$FIRSTCOURSE is $FIRSTCOURSE" >> $DEBUG
		SECONDSECONDCOURSE=$(grep "$SECONDEMAIL" "$QUARTERLY" | grep "$CUTOFF" | sed -n 2p | cut -d, -f1,6)
		SECONDTHIRDCOURSE=$(grep "$SECONDEMAIL" "$QUARTERLY" | grep "$CUTOFF" | sed -n 3p | cut -d, -f1,6)
		SECONDFOURTHCOURSE=$(grep "$SECONDEMAIL" "$QUARTERLY" | grep "$CUTOFF" | sed -n 4p | cut -d, -f1,6)
		if [ "$SECONDFIRSTCOURSE" != "" ]
		then
				echo "$SECONDDATA,$SECONDREASONTIME,$SECONDFIRSTCOURSE\"" >> $HOLDING
					if [ "$SECONDSECONDCOURSE" != "" ]
						then
							echo "$SECONDDATA,$SECONDREASONTIME,$SECONDSECONDCOURSE\"" >> $HOLDING
								if [ "$SECONDTHIRDCOURSE" != "" ]
									then
										echo "$SECONDDATA,$SECONDREASONTIME,$SECONDTHIRDCOURSE\"" >> $HOLDING
											if [ "$SECONDFOURTHCOURSE" != "" ]
												then
													echo "$SECONDDATA,$SECONDREASONTIME,$SECONDFOURTHCOURSE\"" >> $HOLDING
											fi
								fi
					fi
		fi	
	done
}

getStudentEmail ()
{
ALLEMAIL=`(grep -v "Status /Comments" "$HOLDING" | cut -d, -f5)`
for ScannedEmail in $ALLEMAIL
	do
		DUPLICATEEMAIL=$(grep "$ScannedEmail" "$JUNKFILE")
		if [ "$ScannedEmail" != "$DUPLICATEEMAIL" ]
			then
				echo "$ScannedEmail" >> $JUNKFILE
		fi
	done
}	

getStudentData ()
{
touch $STUJUNK
STUDENTEMAIL=`(grep "@oapb.org" "$JUNKFILE")`
for SoloEmail in $STUDENTEMAIL
	do
#		echo "DEBUG: \$SoloEmail is $SoloEmail" >> $DEBUG
		VISITS=$(grep -c "$SoloEmail" "$WEEKLY")
		TIMETOTAL=$(grep "$SoloEmail" "$WEEKLY" | awk -F'\"' '{print $4;}')
		echo "$TIMETOTAL" >> $STUJUNK
		HOURS=$(sed -n 1p $STUJUNK | awk -F':' '{print $1;}')
		MINUTES=$(sed -n 1p $STUJUNK | awk -F':' '{print $2;}')
#		echo "DEBUG: \$MINUTES is $MINUTES" >> $DEBUG
		SECONDS=$(sed -n 1p $STUJUNK | awk -F':' '{print $3;}')
		echo "$MINUTES" >> "$STUMINUTES"
		TOTALMINUTES=$(paste -sd+ "$STUMINUTES" | bc)
		rm -rf "$STUMINUTES"
		echo "$HOURS" >> "$STUHOURS"
		TOTALHOURS=$(paste -sd+ "$STUHOURS" | bc)
		rm -rf "$STUHOURS"
		rm -rf "$STUJUNK"
		CONVERTHOURS=$(expr "$TOTALHOURS" \* 60)
		TOTALTIME=$(expr "$CONVERTHOURS" + "$TOTALMINUTES")
		FINALHOURS=$(expr "$TOTALTIME" / 60)
		FINALMINUTES=$(expr "$TOTALTIME" % 60)
		AVERAGETIME=$(expr "$TOTALTIME" / "$VISITS")
		AVERAGEHOURS=$(expr "$AVERAGETIME" / 60)
		AVERAGEMINUTES=$(expr "$AVERAGETIME" % 60)
		MATHCLASS=$(grep $SoloEmail "$HOLDING" | head -n 1 | cut -d, -f8)
		echo "$SoloEmail,$VISITS,$FINALHOURS:$FINALMINUTES,$AVERAGEHOURS:$AVERAGEMINUTES,$MATHCLASS" >> $STUDENTHOLDING
	done
}

getSeparateCourses ()
{
COURSES=$(grep "@oapb.org" "$STUDENTHOLDING" | cut -d, -f5)
for Courses in $COURSES
	do
		DUPLICATECOURSES=$(grep "$Courses" "$COURSEJUNK")
		if [ "$Courses" != "$DUPLICATECOURSES" ]
			then
				echo "$Courses" >> "$COURSEJUNK"
		fi
	done
}

getCourseData ()
{
COURSESTWO=$(grep " " "$COURSEJUNK")
for CourseCollected in $COURSESTWO
	do
		UCOURSES=$(grep -c "$CourseCollected" "$STUDENTHOLDING")
		TCOURSES=$(grep -c "$CourseCollected" "$HOLDING")
		echo "$CourseCollected,$UCOURSES,$TCOURSES" >> $COURSEHOLDING
	done
}

#Run Functions
#echo "DEBUG: \$YEAR is $YEAR, \$STARTYEAR is $STARTYEAR" >> $DEBUG
if [ $YEAR != $STARTYEAR ]
	then
		echo "####Starting Second Semester Function####" >> /var/log/$LOGFILE
		getSecondSemWeeklyNames
	else
		echo "####Starting First Semester Function####" >> /var/log/$LOGFILE
		getFirstSemWeeklyNames
fi

echo "####Collecting Student Data####" >> /var/log/$LOGFILE

getStudentEmail

getStudentData

getSeparateCourses

echo "####Collecting Course Data####" >> /var/log/$LOGFILE

getCourseData

#Create Final Documents
echo "----Creating Final Documents----" >> /var/log/$LOGFILE
touch $FINAL
cp $HOLDING $FINAL
touch $STUDENTFINAL
cp $STUDENTHOLDING $STUDENTFINAL
touch $COURSEFINAL
cp $COURSEHOLDING $COURSEFINAL

#Delete Holding files
echo "Performing cleanup" >> /var/log/$LOGFILE
rm -rf $HOLDING
rm -rf $STUDENTHOLDING
rm -rf $JUNKFILE
rm -rf $COURSEHOLDING
rm -rf $COURSEJUNK
unset IFS

exit 0
