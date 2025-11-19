# Multi Threading with Python

# Compare/contrast thread/process
A thread executes its own piece of code, independently of other threads. A thread provides a minimal context for concurrent execution of instructions. Threads play a crucial role in obtaining performance in multicore and multiprocessor environments and help in structuring clients and servers.

## Key aspects of threads:
1. **Threads vs. Processes:** Unlike processes, threads do not automatically ensure a high degree of concurrency transparency if it leads to performance degradation. A thread context often contains only the processor context and thread management information.
2. **Thread Context:** A processor context is contained in a thread context, which in turn is contained in a process context.
3. **Performance:** Multithreaded applications need not have worse performance than single-threaded ones, and can often perform better.
4. **Implementation:** Threads are often provided in the form of a thread package, with operations to create/destroy threads and manage synchronization variables. There are two approaches to implementing a thread package: a user-level thread library or kernel-aware threads.
    1. **User-Level Thread Library:** Offers cheap thread creation/destruction, and fast context switching.
    2. **Kernel-Level Threads:** An alternative to user-level threads is a hybrid form, the many-to-many threading model, using both user and kernel threads.

## Thread Benefits:
* In **a single-threaded process**, whenever a blocking system call is executed, the entire process is blocked.
    * Threads can exploit parallelism on multiprocessor or multicore systems.
    * Many applications are easier to structure as a collection of cooperating threads.

Threads are particularly attractive in distributed systems because they facilitate maintaining multiple logical connections simultaneously. They allow blocking system calls without blocking the entire process.