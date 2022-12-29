import os

def sayTheLine(processPID:int, level:int, parentPID:int, relPos:str):
    assert (relPos == "right") or (relPos == "left"), "relPos should be either left or right"
    print("I am process with PID = ",processPID," standing at Level ",level," of the zig zag path, my parent is PID=",parentPID," and I am its ",relPos," child")


def zigZag(level:int, parentPID:int, relPos:str)->int:
    assert relPos=="left" or relPos=="right", "relPos can either be left or right "
    if level == 10:
        return 0 
    # PIDS[0] = Parent PID
    # PIDS[1] = Left child
    # PIDS[2] = Right child
    PIDS = [0,0,0]
    
    if level == 0:
        if parentPID==os.getpid():  # If the parent reaches this code
            PIDS[1] = os.fork();    # Fork the left child
        if parentPID==os.getpid():
            PIDS[2] = os.fork();    # Fork the right child

        # Error Handling
        if PIDS[1]==-1:
            print ("Failed to fork")
            os._exit(1)
        if PIDS[2]==-1:
            print ("Failed to fork")
            os._exit(1)

        if PIDS[1]==0:              # If left child reaches this
            pid=os.getpid()
            sayTheLine(pid,level+1,parentPID,"left")
            PIDS[1] = zigZag(level+1,pid, "left")
            return pid 
        elif PIDS[2]==0:
            pid=os.getpid()
            sayTheLine(pid,level+1,parentPID, "right")
            PIDS[2] = zigZag(level+1,pid,"right")
            return pid
    elif level%2 == 1 :
        PIDS[0] = parentPID
        if relPos=="right":
            return 0

        if parentPID==os.getpid():    # If parent
            PIDS[1] = os.fork();
        if parentPID==os.getpid():    # If parent
            PIDS[2] = os.fork();

        # Error Handling
        if PIDS[1]==-1:
            print ("Failed to fork")
            os._exit(1)
        if PIDS[2]==-1:
            print ("Failed to fork")
            os._exit(1)

        # Code to run on each child
        if PIDS[1]==0:
            pid=os.getpid()
            sayTheLine(pid,level+1,parentPID,"left")
            PIDS[1] = zigZag(level+1,pid,"left")
            return pid 
        elif PIDS[2]==0:
            pid=os.getpid()
            sayTheLine(pid,level+1,parentPID,"right")
            PIDS[2] = zigZag(level+1,pid,"right")
            return pid
    else :
        PIDS[0] = parentPID
        if relPos=="left":
            return 0

        if parentPID==os.getpid():
            PIDS[1] = os.fork();
        if parentPID==os.getpid():
            PIDS[2] = os.fork();

        if PIDS[1]==-1:
            print ("Failed to fork")
            os._exit(1)
        if PIDS[2]==-1:
            print ("Failed to fork")
            os._exit(1)


        if PIDS[1]==0:
            pid=os.getpid()
            sayTheLine(pid,level+1,parentPID,"left")
            PIDS[1] = zigZag(level+1,pid, "left")
            return pid 
        elif PIDS[2]==0:
            pid=os.getpid()
            sayTheLine(pid,level+1,parentPID,"right")
            PIDS[2] = zigZag(level+1,pid,"right")
            return pid
    return 1

if __name__ == "__main__":
    zigZag(0,os.getpid(),"left")



