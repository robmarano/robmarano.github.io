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

