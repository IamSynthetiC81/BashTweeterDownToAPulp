function createTweet(){
	echo -n "Please input your new tweet : "
	read newTweet

	tweets+=($newTweet)
	
	CurrentID=$lineCount
}
function readTweet(){
	if [[ -z "$CommandParameter" ]] ; then
		echo -e "\tParameter was not specified"
		return
	fi
	if [[ $CommandParameter =~ '^[0-9]+$' ]] ; then
		echo -e "\tinvalid parameter"
		return
	fi
	if [[ $CommandParameter -gt $lineCount ]] ; then
		echo -e "\tID greater than file line count"
		return
	fi
	if [[ $CommandParameter -lt 0 ]] ; then
		echo -e "\tID can not be negative"
		return
	fi

	echo -e "\t${tweets[$CommandParameter]}"
}

function updateTweet(){
	if [[ -z "$CommandParameter" ]] ; then
		echo -e "\tParameter was not specified"
		return
	fi
	if [[ $CommandParameter =~ '^[0-9]+$' ]] ; then
		echo -e "\tinvalid parameter"
		return
	fi
	if [[ $CommandParameter -gt $lineCount ]] ; then
		echo -e "\tID greater than file line count"
		return
	fi
	
	echo -n "Input new tweet : "
	IFS=$'\n'
	read newTweet
	
	#echo -e Original tweet is : ${tweets[$CommandParameter]} \n

	tweets[$CommandParameter]=""$newTweet""

	#echo -e New tweet is : ${tweets[$CommandParameter]}\n
}

function deleteCurrentID(){

	#echo Tweet to be deleted : ${tweets[$CurrentID]}

	unset tweets[$CurrentID]

	# Rebuilding the array to fix the indicies order
	for i in "${!tweets[@]}"; do
		new_array+=( "${tweets[i]}" )
	done
	tweets=("${new_array[@]}")
	unset new_array	

	# Decrement lineCount to match array.
	lineCount=$lineCount-1

	#echo New tweet : ${tweets[$CurrentID]}

	if [[ $CurrentID -gt $lineCount ]] ; then
		CurrentID=$lineCount
	fi
}

function SaveToFile(){
	SavePath=$CommandParameter
	if [[ -z "$CommandParameter" ]] ; then
		while true; do
			read -p "File was not specified. Would you like to overwrite the opened file ? (Y/n): " yn
			case $yn in
		        [Yy]* ) SavePath=$Path; break;;
		        [Nn]* ) echo -e "\tAborting"; return;;
			* ) echo "Invalid Input";;
		    esac
		done
	elif [[ -e $CommandParameter ]] ; then
		while true; do
			read -p "File allready exists. Would you like to overwrite it ? (Y/n): "
			case $yn in
		        [Yy]* ) SavePath=$Path; break;;
		        [Nn]* ) echo -e "\tAborting"; return;;
			* ) echo "Invalid Input";;
		    esac
		done
	fi

	printf "%s\n" "${tweets[@]}" > $SavePath 
}

function printHelp(){
	filepath="Files/.conf/help.txt"
	while read line; do echo $line; done < $filepath
}

CurrentID=0
CommandParameter=-1

Path=$1
if [[ ! -e $Path ]];
then
	echo -e "\tNo file path specified\n\tUsing default location"
	Path="Files/tweetsmall.txt"
fi

readarray -t tweets < $Path 
lineCount=$(/usr/bin/wc -l < $Path)

echo -e "Welcome to the US degeneracy pool\n\tPress -h for help"

while true
do
	IFS=$' '
	echo -n "Input command : "
	read UserCommand CommandParameter

	case $UserCommand in
	[eE]*)	createTweet ;;
	[rR]*)	readTweet ;;
	[uU]*)	updateTweet ;;
	[dD]*)	deleteCurrentID ;;
	$)	# Print last tweet
		CurrentID=$lineCount-1
		CommandParameter=$lineCount-1
		readTweet	;;
	-)	# print one tweet up from current	
		CurrentID=$CurrentID+1
		if [[ $CurrentID -gt $lineCount-1 ]] ; then
			CurrentID=$CurrentID-1
			echo -e "\tYou have reached the top"
		else
			echo ${tweets[$CurrentID]}
		fi	;;
	+)	# Print one tweet down from current
		if [[ $CurrentID -eq 0 ]] ; then
			echo -e "\tYou have reached the bottom"
		else
			CurrentID=$CurrentID-1
			echo ${tweets[$CurrentID]}
		fi	;;
	=) 	# Print current tweet
			echo ${tweets[$CurrentID]} ;;
	[qQ]*)	exit 0		;;
	[wW]*)	# Save to file
		SaveToFile	;;
	[xX]*)	# Save and exit
		SaveToFile
		exit 0		;;
	[hH]*)	printHelp	;;
	*)	echo -e '\t' Incorrect command;;
	esac
done

exit 1


