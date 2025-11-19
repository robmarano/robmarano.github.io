# README.md

Java template that demonstrates:

1. **Multi-threading:** Creating and managing multiple threads.
2. **Data Sharing:** How threads can access and modify shared data.
3. **Thread Control:** Mechanisms for threads to communicate and synchronize.
4. **Interaction with the Main Thread:** How child threads interact with the main program flow.

# Overview of the Program

We'll create a template that uses:

1. The `Thread` class or `Runnable` interface for thread creation.
2. The `synchronized` keyword or `java.util.concurrent` classes for thread safety and data sharing.
3. `wait()`, `notify()`, or `notifyAll()` for inter-thread communication.
4. A shared data structure (e.g., a list or a shared object).

# Code and Implementation Explanation
**Shared Data:**

1. `sharedData`: An `ArrayList` to hold shared integer data.
2. `dataReady`: a boolean that helps with thread communication.

**Producer Thread:**

1. Adds integers to `sharedData`.
2. Uses `synchronized` to ensure thread-safe access to `sharedData`.
3. sets `dataReady` to true, and uses notifyAll() to wake up waiting consumer threads.
4. Simulates work with Thread.sleep().

**Consumer Thread:**

1. Waits for data to be available using `sharedData.wait()` inside a `synchronized` block.
2. Removes and processes data from `sharedData`.
3. sets `dataReady` to false when the shared data list is empty.
4. Simulates processing with `Thread.sleep()`.

**Synchronization:**

1. The `synchronized` keyword ensures that only one thread can access `sharedData` at a time, preventing race conditions.
2. wait() and notifyAll() allow threads to coordinate and communicate.

This template provides a basic structure for multi-threaded Java programs. You can adapt it to your specific needs by modifying the shared data, the producer and consumer logic, and the synchronization mechanisms.