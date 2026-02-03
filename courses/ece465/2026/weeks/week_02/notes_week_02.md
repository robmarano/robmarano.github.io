# Notes for Week 2
[ &larr; back to syllabus](/courses/ece465/2025/ece465-ind-study-syllabus-spring-2025.html) [ &larr; back to notes](/courses/ece465/2025/ece465-notes.html)

# Topics
* Programming mechanisms of distributed systems
* Single process program
* Multi-process program
* Multi-threaded program
* Multi threading with Python

# Topics Deep Dive

## Comparison and Contrast of Programming Distributed Systems

Comparing and contrasting **multi-processing**, **multi-threading**, and **network programming** for distributed algorithms involves understanding their core mechanisms, strengths, and weaknesses.

### Overview

We'll break this down by:

1. **Defining each method:** Briefly explaining multi-processing, multi-threading, and network programming.
2. **Comparing their characteristics:** Focusing on aspects like resource usage, communication overhead, and fault tolerance.
3. **Contrasting their suitability:** Discussing which methods are best for different types of distributed algorithms.

### Definitions
**Multi-processing:**
* Involves running multiple independent processes, each with its own memory space (stack).
* Processes communicate through **inter-process communication** (IPC) mechanisms like **pipes**, **sockets**, or **message queues**.
* This approach leverages multiple CPU cores effectively.

**Multi-threading:**
* Involves running multiple threads within a single process, sharing the same memory space.
* Threads communicate by accessing shared variables.
* This approach is efficient for tasks that are **I/O-bound** or require **concurrent execution** within a single process.

**Network programming:**
* Involves communication between processes running on the same machine or on different machines over a network connection.
* Processes communicate using network protocols like TCP/IP, UDP/IP, or other networking protocols available on each compute node.
* This approach is essential for building distributed systems that span multiple machines.

### Comparison Chart

| Feature | Multi-processing | Multi-threading | Network programming |
| :--- | :--- | :--- | :--- |
| Memory | Separate memory spaces | Shared memory space | Separate memory spaces across machines |
| Communication | IPC mechanisms (pipes, queues, sockets) | Shared variables | Network protocols (TCP/IP, UDP) |
| Resource usage | Higher (each process has its own memory) | Lower (threads share memory) | Highest, due to network overhead |
| Concurrency | High (parallel execution on multiple cores) | High (concurrent execution within a process) | High, across many machines |
| Fault tolerance | High (process isolation) | Lower (a crash in one thread can affect the entire process) | High, when designed correctly, allows for redundancy |
| Complexity | Moderate | Moderate | High |
| Scalability | High, on a single machine | Medium, limited by single machine resources | Very high, across many machines |

### Suitable Usages

**Multi-processing:**
* Ideal for CPU-bound tasks that require parallelism.
* Suitable for applications that need strong isolation between components.
* Good for tasks that can be broken into independant parts.

**Multi-threading:**
* Ideal for I/O-bound tasks where threads can wait for I/O operations without blocking other threads.
* Suitable for applications that require efficient sharing of data within a process, but know the coordination is not trivial.
* Good for tasks that require high levels of concurrency within a single application running on the same computer.

**Network programming:**
* Essential for building distributed systems that span multiple machines.
* Suitable for applications that require communication between processes running on different machines.
* Good for tasks that require high levels of scalability, and geographically distributed systems.

Note, you could use the combination of all three mechanisms for your distributed systems application, but design carefully with consideration of performance needed vs complexity in software implementation effort.

### Examples

A scientific simulation that requires heavy computation can benefit from **multi-processing**; take note of the processing algorithms and how you would implement the parts that execute in each sub-process.

A web server that handles multiple client requests concurrently can use **multi-threading**.

A distributed database that stores data across multiple servers requires **network programming**.

# Multi-processing in Python

<details>
<summary><code>my_multi_proc.py</code></summary>

{% highlight python %}

import multiprocessing
import time
import os

def worker_function(data):
    """
    This is the function that each process will execute.

    Args:
        data: The data that will be processed by this worker.  This can be
              anything that can be pickled (basic data types, lists,
              dictionaries, custom objects, etc.).  For large datasets,
              consider using shared memory or memory mapping for efficiency.

    Returns:
        The result of the processing. This also needs to be picklable.  If
        you don't need to return anything, you can return None.
    """

    process_id = os.getpid()  # Get the current process ID
    print(f"Process {process_id}: Starting work on {data}")

    # Simulate some work (replace with your actual processing logic)
    time.sleep(2)  # Simulate a 2-second task
    result = data * 2  # Example: double the input data

    print(f"Process {process_id}: Finished work. Result: {result}")
    return result


def main():
    """
    Main function to set up and manage the multiprocessing pool.
    """

    num_processes = multiprocessing.cpu_count()  # Use all available CPU cores (good default)
    # num_processes = 4 # Or specify a fixed number if needed

    data_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] # Example data

    print(f"Using {num_processes} processes.")

    # Create a pool of worker processes.
    with multiprocessing.Pool(processes=num_processes) as pool:

        # Option 1: Apply the function to each element of the data list (blocking)
        # results = pool.map(worker_function, data_list)

        # Option 2: Apply the function asynchronously (non-blocking).  This is
        # useful if you want to do other things while the processes are running
        # or if the tasks have varying lengths and you want results as they come in.

        results = []
        for data_item in data_list:
            result_future = pool.apply_async(worker_function, (data_item,)) # Tuple for single argument
            results.append(result_future)

        # Retrieve the results (this will block until all processes are finished if you used apply_async)
        final_results = [result.get() for result in results]



    print("All processes finished.")
    print(f"Final Results: {final_results}")

if __name__ == "__main__":
    main()

{% endhighlight %}
</details>

# Multi-threading in Python

<details>
<summary><code>my_multi_thread.py</code></summary>
{% highlight python %}

import threading
import time

def worker_function(data):
    """
    This is the function that each thread will execute.

    Args:
        data: The data that will be processed by this thread.

    Returns:
        The result of the processing.
    """
    thread_id = threading.get_ident()  # Get the current thread ID
    print(f"Thread {thread_id}: Starting work on {data}")

    # Simulate some work (replace with your actual processing logic)
    time.sleep(2)  # Simulate a 2-second task
    result = data * 2  # Example: double the input data

    print(f"Thread {thread_id}: Finished work. Result: {result}")
    return result


def main():
    """
    Main function to set up and manage the threads.
    """

    num_threads = 4  # You can adjust the number of threads
    data_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]  # Example data

    print(f"Using {num_threads} threads.")

    threads = []
    results = []

    for data_item in data_list:
        thread = threading.Thread(target=worker_function, args=(data_item,))
        threads.append(thread)
        thread.start() # Start the thread

    # Wait for all threads to complete
    for thread in threads:
        thread.join()  # This will block until the thread finishes

    # Retrieving results is more complex with basic threads. You need a way
    # to communicate results back from the threads.  Here's an example
    # using a simple list (but this requires careful synchronization if
    # the results are modified).

    # One approach is to use a queue:
    import queue
    results_queue = queue.Queue()

    def worker_function_with_queue(data, q):
        result = data * 2
        q.put(result) # Add to the queue

    threads_with_queue = []
    for data_item in data_list:
        thread = threading.Thread(target=worker_function_with_queue, args=(data_item, results_queue))
        threads_with_queue.append(thread)
        thread.start()

    for thread in threads_with_queue:
        thread.join()

    final_results = []
    while not results_queue.empty():
        final_results.append(results_queue.get())


    print("All threads finished.")
    print(f"Final Results: {final_results}")


if __name__ == "__main__":
    main()

{% endhighlight %}
</details>



<details>
<summary><code>XXX.py</code></summary>
{% highlight python %}
{% endhighlight %}
</details>

--
# Additional Notes

### Class 02 Notes: Multi-processing & Network Programming — Part 1

**Course:** ECE 465 - Cloud Computing
**Instructor:** Prof. Rob Marano

#### I. The Linux Process Model
**Definition and Context**
To understand distributed systems, we must first understand the fundamental unit of execution: the process. From an operating system perspective, a process is defined simply as a "program in execution".

**Process Context**
When an operating system (like Linux) executes a program, it creates a "virtual processor" for it. To manage this, the OS maintains a **process context**, which is stored in a process table. This context includes:
*   **CPU Register Values:** Including the program counter and stack pointer.
*   **Memory Maps:** The definition of the address space allocated to the process.
*   **Open Files:** Pointers to resources the process is currently using.
*   **Accounting Information & Privileges:** User IDs and usage stats.

**OS Protection and Concurrency**
The OS ensures **concurrency transparency**, meaning multiple processes share the same CPU and hardware resources without corrupting each other. This isolation comes at a performance price: creating a process requires initializing a completely independent address space (copying program text, zeroing data segments, setting up a stack). Switching between processes requires saving registers, modifying Memory Management Unit (MMU) registers, and invalidating address translation caches like the Translation Lookaside Buffer (TLB).

---

#### II. Multi-Processing and IPC (Inter-Process Communication)
Distributed applications are often constructed as collections of cooperating programs, each executing as a separate process. On a single Linux machine, we can start multiple processes that run concurrently. Since they have separate address spaces, they require specific mechanisms to exchange data, known as **Inter-Process Communication (IPC)**.

**Options for IPC**
1.  **Files with Locks:** Processes read/write to a shared file. To maintain consistency, they must use locking mechanisms (e.g., `flock`) to prevent concurrent access corruption.
2.  **Pipes:** A unidirectional data channel that connects the standard output of one process to the standard input of another.
3.  **Message Queues:** A linked list of messages stored within the kernel.
4.  **Shared Memory:** A segment of memory accessible by multiple processes (requires synchronization).

**Context Switching Overhead**
IPC often requires extensive context switching. For example, sending data via IPC might require switching from user mode to kernel mode, switching the process context within the kernel, and switching back to user mode for the receiver.

##### **Python Example: Multi-processing with Pipes**
Python’s `multiprocessing` library allows the creation of processes that bypass the Global Interpreter Lock (GIL) by using subprocesses.

```python
from multiprocessing import Process, Pipe
import os

def sender(conn):
    msg = "Hello from Process " + str(os.getpid())
    conn.send(msg)
    conn.close()

def receiver(conn):
    msg = conn.recv()
    print(f"Process {os.getpid()} received: {msg}")
    conn.close()

if __name__ == '__main__':
    # Create a pipe for communication
    parent_conn, child_conn = Pipe()
    
    # Create two separate processes
    p1 = Process(target=sender, args=(child_conn,))
    p2 = Process(target=receiver, args=(parent_conn,))
    
    # Start processes (OS creates independent address spaces)
    p1.start()
    p2.start()
    
    # Wait for completion
    p1.join()
    p2.join()
```
*(Ref: Based on logic described in regarding `multiprocessing.Process`)*

##### **Java Example: Processes with File Communication**
In Java, `ProcessBuilder` starts operating system processes. Here, two JVMs communicate via a shared file with locking.

```java
import java.io.*;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;

public class FileIPC {
    public static void main(String[] args) {
        File file = new File("shared.txt");
        
        // Simulating Process 1: Writer
        try (RandomAccessFile raf = new RandomAccessFile(file, "rw");
             FileChannel channel = raf.getChannel()) {
            
            // Acquire an exclusive lock on the file
            FileLock lock = channel.lock();
            raf.writeBytes("Data from Process 1");
            lock.release(); // Release lock for other processes
            
        } catch (IOException e) { e.printStackTrace(); }

        // Simulating Process 2: Reader (conceptually a separate process)
        try (RandomAccessFile raf = new RandomAccessFile(file, "r");
             FileChannel channel = raf.getChannel()) {
            
            // In a real scenario, this would wait for the lock
            String line = raf.readLine();
            System.out.println("Process 2 read: " + line);
            
        } catch (IOException e) { e.printStackTrace(); }
    }
}
```

---

#### III. Collapsing to Multi-Threading
While processes provide strong isolation, the granularity is often too coarse for high performance. We can "collapse" the logic of multiple communicating processes into a single process containing multiple **threads**.

**The Thread Model**
*   **Definition:** A thread behaves like a process (executes its own code independently) but operates within the *same* address space as other threads in that process.
*   **Thread Context:** Contains the minimal information needed for execution (CPU registers, stack pointer) but ignores memory maps and open files, which are shared with the parent process.
*   **Performance:** Switching threads is cheaper than switching processes because the MMU map does not need to change, and the TLB does not need flushing.
*   **Risks:** Because threads share data segments, the OS does not protect them from each other. The developer must manage synchronization (e.g., Mutexes).

**Why switch to Threads?**
1.  **Blocking Calls:** In a single-threaded process, a blocking I/O call stops the entire process. In a multi-threaded process, one thread can block (wait for I/O) while others continue execution.
2.  **Shared Data:** Threads can communicate via shared variables in memory without the overhead of kernel-mediated IPC (pipes/sockets).

##### **Python Example: Multi-threading with Shared Memory**
Unlike the `multiprocessing` example, these threads share the global variable `shared_x`.

```python
from threading import Thread
import time

# Variable shared by all threads in this process
shared_x = 0

def worker(name):
    global shared_x
    local_copy = shared_x
    time.sleep(0.1) # Simulate work
    shared_x = local_copy + 1
    print(f"{name} updated x to {shared_x}")

if __name__ == "__main__":
    thread_list = []
    # Create threads
    for i in range(3):
        t = Thread(target=worker, args=(f"Thread-{i}",))
        thread_list.append(t)
        t.start()

    # Wait for threads to finish
    for t in thread_list:
        t.join()
        
    print(f"Final value of shared_x: {shared_x}")
```
*(Ref: Adapted from showing threading vs. multiprocessing semantics)*

##### **Java Example: Multi-threading**
Java natively supports threading. This example demonstrates multiple threads running within one JVM process. For network-based threading (sockets), refer to the course GitHub repository.

```java
public class ThreadedExample {
    // Shared resource
    private static int sharedCounter = 0;

    public static void main(String[] args) throws InterruptedException {
        Runnable task = () -> {
            String name = Thread.currentThread().getName();
            // Critical section (should be synchronized in production)
            int temp = sharedCounter;
            try { Thread.sleep(100); } catch (InterruptedException e) {}
            sharedCounter = temp + 1;
            System.out.println(name + " updated counter.");
        };

        Thread t1 = new Thread(task, "Thread-1");
        Thread t2 = new Thread(task, "Thread-2");

        t1.start();
        t2.start();

        t1.join();
        t2.join();
        
        System.out.println("Final Counter: " + sharedCounter);
    }
}
```