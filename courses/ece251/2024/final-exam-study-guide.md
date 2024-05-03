# Final Exam Study Guide ECE251 Sp 2024

Final exam is scheduled for Wednesday, May 8th 6:15-7:20pm ET. Please arrive on-time at 6:00pm ET. We will have lecture after the final on several remaining topics.

The final exam will cover the processor (single-cycle and pipelining; textbook chapter 4, sections 4.1-4.9) and memory hierarchies (textbook chapter 5, sections 5.1-5.5, 5.7, and 5.8).

Topic guide for our final exam:
## The Processor
```Constraints```: For our course we consider the following subset of the core MIP32 instruction set:
1. Memory reference instructions
    - ```lw```, ```sw```
2. Arithmetic-logical instructions
    - ```add```, ```sub```, ```and```, ```or```, ```slt```
3. Branching instructions
    - ```beq```, ```j```

Basic components of the processor:
1. Program Counter (```PC```) and its associated full adders for calculating the next instruction memory address.
2. Memory, laid out as ```instruction memory``` and ```data memory```
3. Register file, for reading from and writing to general purpose registers (GPRs) accessible to the programmer via instructions
4. Arithmetic Logic Unit (```ALU```)
5. Control Unit with its associated multiplexors

### Processor Design &mdash; Implementation Topics
1. What are the elements of the MIPS32 datapath?
    - A datapath element is a digital logic unit used to operate on or hold data within the processor. In the MIPS32 implementation, the elements consist of the memory laid out as two separate areas, the register file, the ALU, and a set of other combinational logic circuits, e.g., full adders, sign extenders, shift registers, and control signals.
2. Simple Implementation Scheme
    - ALU Control Unit
    - Main Control Unit
    - Datapath operation for each instruction type: R-, I-, and J-type. Note the instructions above for this specific implementation, i.e., ```add```, ```sub```, ```and```, ```or```, ```slt```, ```lw```, ```sw```, ```beq```, and ```j```.


##  Memory Hierarchy
- The principle of locality
  - temporal locality vs spatial locality
- Memory Technologies
  - SRAM (static RAM):
    - integrated circuits implementing memory arrays with (usually) a single access port that can provide either a ```read``` or a ```write```
    - have a fixed access time to any datum, through actual times for a read and for a write may differ
    - do not need to refresh, so access time is close to the cycle time (time between memory accesses)
    - redundancy of transistors per bit to prevent value from drifting
    - require minimum power to retain charge in standby mode
    - as long as power is applied, the value kept indefinitely
  - DRAM: (dynamic RAM)
    - datum value kep in a memory cell is stored as a charge in a capacitor
    - a single transistor is used to access the stored charge, either to read or to write
    - as a result, DRAM as compared to SRAM are much denser and cheaper per bit
    - due to capacitive charge, the bits need to be refreshed periodically
    - the charged is stored only for several milliseconds
    - to refresh a cell, the value is read then written back
    - if every bit had to be read out then written back individually, we would constantly be refreshing the DRAM, leaving no time for access it
    - therefore, DRAMs use a two-level decoding structure, which allows refreshing an entire ```row``` with a read cycle followed immediately by a write cycle
    - a ```row``` shares a **word** line
  - Flash Memory
    - a type of EEPROM (electrically erasable programmable read-only memory)
    - unlike DRAM and disks, EEPROM writes wear out flash memory bit structures
    - to cope with wear, most flash memories include a controller to spread the writes by remapping blocks that have been written many times to less used blocks &mdash; this is called ```wear leveling```
    - wear leveling can also improve yield of flash memories after manufacturing by mapping out memory cells that were manufactured incorrectly.
  - Disk Memory
    - different implementations of disk memories, also called ```disk drives```
      - magnetic disk drives
      - SSD drives 
- Basics of a Cache Memory
  - `cache` = "a safe place to store things that we need to examine"
  - A Simple Cache
    - CPU requests one word
    - blocks of memory in cache consist of a single word
    - before the request, the cache contains a collection of recent references X1, X2, ..., Xn-1
    - the CPU requests Xn, which is not in the cache &mdash; called a `miss`; if it is in the cache, it is called a `hit`
    - the cache controller fetches from main memory the word Xn and store in the cache
    - this poses two questions
      - how do we know if a datum is in the cache?
      - if it is, how do we find it?
    - each word can go only in one place in the cache, which means it's straightforward to fine
    - Simple scheme would be to assign the cache location based on the **address** of the word in memory &mdash; this is called `direct-mapped cache`
    - almost all direct-mapped caches use the following mapping formula
      - (block address) modulo (number of blocks in the cache)
      - if the number of cache entries is a power of 2, then modulo computed by using the **low-order** log base 2 (of cache size in blocks) bits of the memory address
        - 8-block cache &rarr; log base 2 (8 = 2^3) = 3; use the 3 lowest bits of the memory address to use as the block address in the direct-mapped cache
    - Each cache location can contain the values of a number of different memory locations, so how do you know whether the data in the cache corresponds to the request word address?
    - Add a set of `tags` to the cache
      - A `tag` is a field in the a table used for memory hierarchy that contains the address info required to identify whether the associated block in the hierarchy corresponds to a requested word
      - the `tag` needs only to contain the upper portion of the address, corresponding to the bits that are NOT used as an index into the cache
    - We also need to know if the data found in the cache is valid or not
      - when the CPU starts up, the cache has no good data and the tag fields are meaningless.
      - the common method is to add a `valid bit` to the cache address derived from the memory address word requeted
        - this bit indicates whether the cache entry contains a valid memory address
        - if the bit is not set, there cannot be a match for this block.
    - the columns of the cache table for a direct-mapped cache are:
      1. index
      2. valid bit
      3. tag field
      4. data value of the memory location requested
    - remember, `temporal locality` means recently referenced words replace the less recently referenced words
    - see page 406-407 for an example of a direct-mapped cache
  - Handling Cache Misses
  - Handling Cache Writes
- Measuring and Improving Cache Performance
  - CPU time divided into
    - clock cycles (CCs) CPU spends executing program instructions
    - CCs CPU spends waiting for the memory system (hierarchy)
    - assuming costs of cache hits are part of the normal CPU execution cycles
      - CPU = (CPU exec clock cycles + Memory-stall clock cycles) x Clock Cycle Time
  - memory-stall CCs come primarily from cache misses
    - memory-stall CCs = (read-stall CCs + write-stall CCs)
    - read-stall CCs = (Reads/program) * read miss rate * read miss penalty in CCs
    - write-stall CCs = (writes/program * write miss rate * write miss penalty in CCs) + write buffer stalls
      - writes are more complicated; for a write-through cache scheme, there are 2 sources of stalls: write misses and write buffer stalls
        - write misses are when we fetch the block before continuing the write
        - write buffer stalls occur when the write buffer is full when a write occurs
  - see the calculating cache performance example on page 418
  - reducing cache misses by a more flexible placement of blocks, in addition to direct-mapped caches
    - at one scheme extreme is direct-mapped, which places blocks in exactly one location
    - at the other extreme, is fully associative, which places a block in any location in the cache &mdash; a block in memory may be associated with any entry in the cache
    - to find a given block in a fully associative cache, all entries must be searched because a block can be placed in any entry.
      - for efficiency, searches are done in parallel using a comparator associated with each cache entry
      - using comparators increases hardware costs, so fully associative caches become practical only for caches with a small number of blocks
    - the middle of the two extremes between direct-mapped and fully associated caches is `set associative`
      - such a cache with `n` locations for a block is called an `n-way set-associative cache`
      - this consists of a number of sets, each having `n` blocks
      - each block maps to a unique set in the cache given by the index field
      - a block can be placed in any element of that set
      - this means it combines direct-mapped placement and fully associative placement
        - a block is directly mapped into a set, then all all the blocks in the set are searched for a match
    - remembering the position of a memory block in a direct-mapped cache
      - (block number) modulo (# of **blocks** in cache)
    - in set-associative cache, the set containing the memory block would be
      - (block number) modulo (# of **sets** in cache)
    - Since the block may be placed in any element of the cache, **all the tags of all the elements of the set** must be searched.
      - In a fully associative cache, the block can go anywhere, and **all tags of all the blocks in the cache** must be searched.
  - see the example on page 423