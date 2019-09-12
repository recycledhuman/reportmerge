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
FINAL="/Users/$WHO/Desktop/reportmerge/final.csv"
HEADER=$(sed -n 1p $WEEKLY | cut -d, -f1,2,3,4,5,9,11)

#Provide appropriate permissions to weekly file
chmod 755 $WEEKLY

#Create text document to hold data as it is generated and set the header
touch $HOLDING
echo "$HEADER,\"Course\",\"Teacher\"" >> $HOLDING

#Set Function - find course and teachers and match it with student data

getWeeklyNames ()
{
NAMES=`(grep -v "Status /Comments" "$WEEKLY" | awk -F'\"' '{print $10;}')`
for ScannedName in $NAMES
	do
		FIRSTVISIT=$(grep "$ScannedName" "$WEEKLY" | sed -n 1p | cut -d, -f1,2,3,4,5,9,11)
		SECONDVISIT=$(grep "$ScannedName" "$WEEKLY" | sed -n 2p | cut -d, -f1,2,3,4,5,9,11)
		THIRDVISIT=$(grep "$ScannedName" "$WEEKLY" | sed -n 3p | cut -d, -f1,2,3,4,5,9,11)
		FOURTHVISIT=$(grep "$ScannedName" "$WEEKLY" | sed -n 4p | cut -d, -f1,2,3,4,5,9,11)
		FIFTHVISIT=$(grep "$ScannedName" "$WEEKLY" | sed -n 5p | cut -d, -f1,2,3,4,5,9,11)
		SIXTHVISIT=$(grep "$ScannedName" "$WEEKLY" | sed -n 6p | cut -d, -f1,2,3,4,5,9,11)
		if [ "$FIRSTVISIT" != "" ]
			then
				FIRSTCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 1p | cut -d, -f1,6)
				SECONDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 2p | cut -d, -f1,6)
				THIRDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 3p | cut -d, -f1,6)
					if [ "$FIRSTCOURSE" != "" ]
						then
							echo "$FIRSTVISIT,$FIRSTCOURSE\"" >> $HOLDING
								if [ "$SECONDCOURSE" != "" ]
									then
										echo "$FIRSTVISIT,$SECONDCOURSE\"" >> $HOLDING
											if [ "$THIRDCOURSE" != "" ]
												then
													echo "$FIRSTVISIT,$THIRDCOURSE\"" >> $HOLDING
											fi
								fi
					fi
				if [ "$SECONDVISIT" != "" ]
					then
                                		FIRSTCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 1p | cut -d, -f1,6)
                                		SECONDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 2p | cut -d, -f1,6)
                               			THIRDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 3p | cut -d, -f1,6)
                                       			if [ "$FIRSTCOURSE" != "" ]
                                                		then
                                                        		echo "$SECONDVISIT,$FIRSTCOURSE\"" >> $HOLDING
                                                                		if [ "$SECONDCOURSE" != "" ]
                                                                        		then
                                                                                		echo "$SECONDVISIT,$SECONDCOURSE\"" >> $HOLDING
                                                                                        		if [ "$THIRDCOURSE" != "" ]
                                                                                                		then
                                                                                                        		echo "$SECONDVISIT,$THIRDCOURSE\"" >> $HOLDING
                                                                                        	fi
                                                                	fi
                                        	fi
					 if [ "$THIRDVISIT" != "" ]
                                        	then
                                        		FIRSTCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 1p | cut -d, -f1,6)
                                        		SECONDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 2p | cut -d, -f1,6)
                                        		THIRDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 3p | cut -d, -f1,6)
                                                		if [ "$FIRSTCOURSE" != "" ]
                                                        		then
                                                                		echo "$THIRDVISIT,$FIRSTCOURSE\"" >> $HOLDING
                                                                        		if [ "$SECONDCOURSE" != "" ]
                                                                                		then
                                                                                        		echo "$THIRDVISIT,$SECONDCOURSE\"" >> $HOLDING
                                                                                                		if [ "$THIRDCOURSE" != "" ]
                                                                                                        		then
                                                                                                                		echo "$THIRDVISIT,$THIRDCOURSE\"" >> $HOLDING
                                                                                                		fi
                                                                        		fi
                                                		fi
 						if [ "$FOURTHVISIT" != "" ]
                                        		then
                                        			FIRSTCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 1p | cut -d, -f1,6)
                                        			SECONDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 2p | cut -d, -f1,6)
                                        			THIRDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 3p | cut -d, -f1,6)
                                                			if [ "$FIRSTCOURSE" != "" ]
                                                        			then
                                                                			echo "$FOURTHVISIT,$FIRSTCOURSE\"" >> $HOLDING
                                                                        			if [ "$SECONDCOURSE" != "" ]
                                                                                			then
                                                                                        			echo "$FOURTHVISIT,$SECONDCOURSE\"" >> $HOLDING
                                                                                                			if [ "$THIRDCOURSE" != "" ]
                                                                                                        			then
                                                                                                                			echo "$FOURTHVISIT,$THIRDCOURSE\"" >> $HOLDING
                                                                                                			fi
                                                                        			fi
                                                			fi 
							if [ "$FIFTHVISIT" != "" ]
                                        			then
                                        				FIRSTCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 1p | cut -d, -f1,6)
                                        				SECONDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 2p | cut -d, -f1,6)
                                        				THIRDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 3p | cut -d, -f1,6)
                                                				if [ "$FIRSTCOURSE" != "" ]
                                                        				then
                                                                				echo "$FIFTHVISIT,$FIRSTCOURSE\"" >> $HOLDING
                                                                        				if [ "$SECONDCOURSE" != "" ]
                                                                                				then
                                                                                        				echo "$FIFTHVISIT,$SECONDCOURSE\"" >> $HOLDING
                                                                                                				if [ "$THIRDCOURSE" != "" ]
                                                                                                        				then
                                                                                                                				echo "$FIFTHVISIT,$THIRDCOURSE\"" >> $HOLDING
                                                                                                				fi
                                                                        				fi
                                                				fi 
								if [ "$SIXTHVISIT" != "" ]
                                        				then
                                        					FIRSTCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 1p | cut -d, -f1,6)
                                        					SECONDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 2p | cut -d, -f1,6)
                                        					THIRDCOURSE=$(grep "$ScannedName" "$QUARTERLY" | sed -n 3p | cut -d, -f1,6)
                                                					if [ "$FIRSTCOURSE" != "" ]
                                                        					then
                                                                					echo "$SIXTHVISIT,$FIRSTCOURSE\"" >> $HOLDING
                                                                        					if [ "$SECONDCOURSE" != "" ]
                                                                                					then
                                                                                        					echo "$SIXTHVISIT,$SECONDCOURSE\"" >> $HOLDING
                                                                                                					if [ "$THIRDCOURSE" != "" ]
                                                                                                        					then
                                                                                                                					echo "$SIXTHVISIT,$THIRDCOURSE\"" >> $HOLDING
                                                                                                					fi
                                                                        					fi
                                                					fi
								fi
							fi
						fi
					fi
				fi
			fi
	done
}

#Run Function
getWeeklyNames

#Create final.csv
touch $FINAL
cp $HOLDING $FINAL

exit 0
