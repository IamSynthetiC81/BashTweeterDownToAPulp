Welcome to the Bash Tweeter Terminal.

To start, call the terminal with './Task2.sh <path/tweets.txt>. If no path is specified, then the default location of /Files/tweetsmall.txt is used.

Commands:

- (c):
    - Creates a tweet and appends it to the end of the list.
- (r <ID>) :
  - Reads the tweet with the specified ID.
- (u <ID>) : 
  - Updates the tweet with the specified ID. When called, it promts the user for a new tweet.
- (d) :
	- Deletes the tweet where the $CurrentID is pointing at. 
  - You can see tweet to be deleted with the '=' command.
- ($) :
	-	Reads the last tweet in the array. it moves the $CurrentID to that tweet.
- (-) :
	- Reads one tweet up from the CurrentID. Returns if there is no later ID, otherwise it prints and moves the $CurrentID up by 1.
- (+) :	
	- Reads one tweet down from the CurrentID. Returns if ID is 0, otherwise it prints and moves the $CurrentID  down by 1.
- (=) :	
	- Reads the tweet pointed to by $CurrentID
- (q) :
	- Quits the program without saving.
- (w) <Path> :
  - Writes the array to the file specified as the parameter. If no file is specified, or the file already exist, it promts the user to overwrite the original file and the user can select whether to proceed or not.
- (x) <Path> :
	-	Writes the array to the file specified as the parameter. If no file is specified, or the file already exist, it promts the user to overwrite the original file and the user can select whether to proceed or not. After completion it exits the program.
