# User can input a directory where a the files are present.
# the files must be named "tweetsmall.txt", "positive.txt" 
# and "negative.txt". This functionality is used for testing.
#
# Alternatively the user can input a path to the files directly. 
# If a path is not specified, a default path is used.
if [[ -d $1 ]] ; then
	# Parameter is dir. All other parameters are ignored
	# and all files are fetched from this dir.
	DirPath=$1
	
	TwPath=$DirPath"tweetsmall.txt"
	PosPath=$DirPath"positive.txt"
	NegPath=$DirPath"negative.txt"
elif [ ! -z "$1" ] && [ -f $1 ] ; then		# If 1st param specified a path
	TwPath=$1				# Set tweetpath to the one specified
	if [ ! -z "$2" ] && [ -f $2 ] ; then	# If 2nd param specified a path
		PosPath=$2			# Set positive keywords path to the one 
						# specified
	else
		PosPath=$DirPath"positive.txt"	# Param was unspecified or invalid
						# Set to default
						# TODO: Throw error on invalid param
	fi

	if [ ! -z "$3" ] && [ -f $3 ] ; then
		NegPath=$3			# If 3rd param specified a path
						# Set negative keywords path to the one
						# specified
	else
		NegPath=$DirPath"negative.txt"	# Param saw unspecified or invalid
						# Set to default
						# TODO: Throw error on invalid param
	fi
elif [ -z "$DirPath" ]; then			# If no param was given
	echo -e "No file path specified\nUsing default location"
	DirPath="Files/"			# Use default path
	
	# Set default paths
	TwPath=$DirPath"tweetsmall.txt"
	PosPath=$DirPath"positive.txt"
	NegPath=$DirPath"negative.txt"
fi

# Reading all text files
readarray -t tweets < $TwPath 
readarray -t positive < $PosPath
readarray -t negative < $NegPath

index=1			# Index for each tweet
for tweet in "${tweets[@]}"; do
	posCounter=0	# Counter for positive sentimented words within tweet
	negCounter=0	# Counter for negative sentimenter words within tweet
	for word in $tweet ; do
		for pword in "${positive[@]}"; do	# For each word in the positive array
			if [[ "$word" = "$pword" ]] ; then	# If that word is contained within the tweet
				posCounter=$((posCounter+1))	# Increment the $posCounter
			fi
		done
		for nword in "${negative[@]}"; do	# For each word in the negative array
			if [[ "$word" = *"$nword"* ]] ; then	# If that word is contained within the tweet
				negCounter=$((negCounter+1))	# Increment the $negCounter
			fi
		done
	done

	# Print message
	if [[ $posCounter -gt $negCounter ]]; then
		echo -e "\tTweet at line #$index has a positive sentiment"
	elif [[ $posCounter -lt $negCounter ]]; then
		echo -e "\tTweet at line #$index has a negative sentiment"
	else
		echo -e "\tTweet at line #$index has a neutral sentiment"
	fi

	index=$((index+1))	# Increment index
done 
