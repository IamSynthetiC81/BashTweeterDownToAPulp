import os

def sayTheLine(processPID:int, level:int, parentPID:int, relPos:str):
    assert (relPos == "right") or (relPos == "left"), "relPos should be either left or right"
    print("I am process with PID = ",processPID," standing at Level ",level," of the zig zag path, my parent is PID=",parentPID," and I am its ",relPos," child")

def spawnThread(parentPID:int) -> list[int]:
    PIDS = [parentPID,0,0]
    # PIDS[0] = Parent PID
    # PIDS[1] = Left child
    # PIDS[2] = Right child
    
    # Thread Spawn
    if parentPID==os.getpid():  # If the parent reaches this code
        PIDS[1] = os.fork();    # Fork the left child
    if parentPID==os.getpid():
        PIDS[2] = os.fork();    # Fork the right child
    
    if PIDS[1]==-1:
        print ("Failed to fork")
        os._exit(1)
    if PIDS[2]==-1:
        print ("Failed to fork")
        os._exit(1)

    return PIDS

def RunZigZag(PIDS:list[int],level:int)->int:
    # PIDS[0] = Parent PID
    # PIDS[1] = Left child
    # PIDS[2] = Right child

    # Code to run on each child
    if PIDS[1]==0:
        pid=os.getpid()
        sayTheLine(pid,level+1,PIDS[0],"left")
        PIDS[1] = zigZag(level+1,pid,"left")
        return pid 
    elif PIDS[2]==0:
        pid=os.getpid()
        sayTheLine(pid,level+1,PIDS[0],"right")
        PIDS[1] = zigZag(level+1,pid,"right")
        return pid 

    return -1   # To silence compiler

def zigZag(level:int, parentPID:int, relPos:str="center")->int:
    assert relPos=="left" or relPos=="right" or relPos=="center", "relPos can either be left, right or center"

    if level == 10:     # If level is 10, break loop
        return 0 

    # If we are not on level 0
    if level != 0:  # If we are not on level 0
        if level % 2 == 1 and relPos == "right":    # if we are on a right node and on a odd number 
            return 0                                # Skip the node
        elif level % 2 == 0 and relPos == "left":   # if we are on a left node and on an even number
            return 0                                # Skip the node

    PIDS = spawnThread(parentPID)                   # Spawn threads
    return RunZigZag(PIDS,level)                    # Run ZigZag recursively

if __name__ == "__main__":
    zigZag(0,os.getpid())
