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