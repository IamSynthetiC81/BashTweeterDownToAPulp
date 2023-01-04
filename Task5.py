import os;

def sendMessages(p1,p2):
    messages = [b"I love PLH211          ",b"The professor is boring",b"but the subject is     ",b"intresting & useful   "]
    for message in messages:
        print("I am parent",os.getpid()," and i write \"",message.decode(),"\"")
        os.write(p1[1],message)
        os.write(p2[1],message)
    os.close(p1[1])
    os.close(p2[1])

def receiveMessages(p):
    index = 0;
    message =''
    string = ''
    while index < 4:
        while len(string) < 22:         # Stupid trick to read the whole message
            message = os.read(p[0],23)  # This function seems to be very slow on my PC
            string = string + message.decode()
        print("I am PID=",os.getpid()," and i read",string)
        index = index + 1
        string=''

def main():
    parentPID = os.getpid()
    print("Parent process is ",parentPID)

    pipe = os.pipe()                    # Create a new pipe
    pipe1= os.pipe()

    if parentPID == os.getpid():
        child1 = os.fork()
    if parentPID == os.getpid():
        child2 = os.fork()

    if parentPID == os.getpid():
        # Parent process
        
        os.close(pipe[0])               # Close reader
        w = os.fdopen(pipe[1], 'w')     # Open writer
        
        sendMessages(pipe,pipe1);       # Send message

        os.wait()                       # Wait for child to terminate
    else:
        # Child process
        if  child1 == 0:
            #print("I am child1 with pid ",os.getpid())
            os.close(pipe[1])               # Close writer
            r = os.fdopen(pipe[0])          # Open reader
        
            receiveMessages(pipe)           # Receive message
        else:
            #print("I am child2 with pid ",os.getpid())
            os.close(pipe1[1])               # Close writer
            r = os.fdopen(pipe1[0])          # Open reader
        
            receiveMessages(pipe1)           # Receive message
    print("Terminating : ",os.getpid())
    os._exit(0)

if __name__=="__main__":
    main()
