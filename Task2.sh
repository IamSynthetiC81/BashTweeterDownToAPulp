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
		echo -e "\tID can be negative"
		return
	fi

	echo -e "\n${tweets[$CommandParameter]}"
}

function updateTweet(){
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
	
	echo -e Original tweet is : ${tweets[$CommandParameter]} \n

	tweets[$CommandParameter]=$newTweet

	echo -e New tweet is : ${tweets[$CommandParameter]} \n
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



CurrentID=0
CommandParameter=-1

Path=$1
if [[ ! -e $Path ]];
then
	echo -e "\tWrong path looser"
	exit 0
fi

readarray -t tweets < $Path 
lineCount=$(/usr/bin/wc -l < $Path)

while true
do
	IFS=$' '
	echo -n "Input command : "
	read UserCommand CommandParameter

	case $UserCommand in
	e)	createTweet ;;
	r)	readTweet ;;
	u)	updateTweet ;;
	d)	deleteCurrentID ;;
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
	q)	exit 0	;;
	w)	# Save to file
		SaveToFile	;;
	x)	# Save and exit
		SaveToFile
		exit 0	;;
	h)	# Help
		# TODO Read help.txt and print it
		echo Not yet implemented	;;
	*)	echo -e '\t' Incorect command;;
	esac
done

exit 1


