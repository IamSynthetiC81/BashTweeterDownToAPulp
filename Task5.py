import os;

def createPipe()->tuple[int,int]:
    # Creates pipes and includes error handling.

    pipe = os.pipe()                    # Create a pipe for child

    # Error Handling
    if not pipe:                        # If error in pipe 
        os.close(pipe[0])               # Close read end
        os.close(pipe[1])               # Close write end
        os._exit(1)                     # Terminate programm
    
    return pipe                         # Return pipe


def sendMessages(p1:tuple[int,int],p2:tuple[int,int]):
    #   This function is called by the parent. For the program to display each message properly
    # we are alternig the messages so that each has a length of 23 bytes. This way the reader will
    # always read 23 bytes, so that messages do not overlap with eachother.
    
    messages = [b"I love PLH211          ",b"The professor is boring",b"but the subject is     ",b"intresting & useful    "]

    for message in messages:
        print("I am parent",os.getpid()," and i write \"",message.decode(),"\"")
        os.write(p1[1],message)         # Write messages to pipe 1
        os.write(p2[1],message)         # Write messages to pipe 2
        # TODO: dup(p1,p2) ???
    os.close(p1[1])                     # Close write end of pipe when done
    os.close(p2[1])                     # Close write end of pipe when done

def receiveMessages(p:tuple[int,int]):
    #   This function is called by a subprocess which does not know the contents
    # of the message. Therefore, we resort to cheap tricks to read the whole message,
    # without overlaps between each packet.
    #
    #   Each message sent contains a packet of 23 bytes, therefore while receiving, we
    # append each part of the message to a string, and loop while its length is less than 23.
    # (This is cheating, since we placed this 23 byte barrier to each message, allready knowing
    # each messages content)

    index = 0;
    message =''
    string = ''
    while index < 4:
        while len(string) < 22:
            message = os.read(p[0],23)
            string = string + message.decode()
        print("I am PID=",os.getpid()," and i read",string)
        index = index + 1
        string=''
    os.close(p[0])                      # Close pipe when read is completed

def main():
    parentPID = os.getpid()             # Get pid of parent process

    pipe = createPipe()                 # Create a pipe for child 1
    pipe1= createPipe()                 # Create a pipe for child 2

    # TODO: dup2(pipe[1],pipe1[1]) ???, merge write ends ....

    child1 = os.fork()                  # Fork first child
    if parentPID == os.getpid():
         os.fork()                      # Fork second child



    if parentPID == os.getpid():        # If parent process
        os.close(pipe[0])               # Close reader
        w = os.fdopen(pipe[1], 'w')     # Open writer
        
        sendMessages(pipe,pipe1);       # Send message

        os.wait()                       # Wait for child to terminate
    else:                               # Else, child process
        if  child1 == 0:                # If the process is the first child
                                        # Run through first pipe
            os.close(pipe[1])               # Close writer
            r = os.fdopen(pipe[0])          # Open reader
        
            receiveMessages(pipe)           # Receive message
        else:                           # Else, the process is the second child
                                        # Run through second pipe
            os.close(pipe1[1])              # Close writer
            r = os.fdopen(pipe1[0])         # Open reader
        
            receiveMessages(pipe1)          # Receive message
    print("PID Terminating : ",os.getpid()) # Keep track of what is terminating when.
    os._exit(0)

if __name__=="__main__":
    main()
