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