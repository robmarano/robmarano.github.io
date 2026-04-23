# Memory System Technical Architecture

This document maps out the logical and temporal architecture of the memory subsystems introduced in Week 13.

## 1. System Architecture (Block Diagram)

```mermaid
graph TD
    CPU[MIPS Pipelined CPU] <-->|Address / Data| Cache[L1 Direct-Mapped Cache]
    Cache <-->|Miss: Fetch Block| MemCtrl[Memory Controller]
    MemCtrl <-->|RAS/CAS / Refresh| DRAM[(Main Memory 1T1C)]
```

## 2. Direct-Mapped Hit/Miss Logic (Sequence Diagram)

This diagram maps the SystemVerilog `cache_controller` module's execution sequence.

```mermaid
sequenceDiagram
    participant CPU
    participant CacheCtrl as Cache Controller
    participant Arrays as Cache Arrays (Tag/Data/Valid)
    participant Mem as Main Memory

    CPU->>CacheCtrl: Request Address (Tag, Index, Offset)
    CacheCtrl->>Arrays: Read Tag and Valid bit at [Index]
    Arrays-->>CacheCtrl: Return stored_tag, is_valid
    
    alt cache_hit = 1 (Valid & Tag Match)
        CacheCtrl->>Arrays: Read Data at [Index]
        Arrays-->>CacheCtrl: Return cache_data
        CacheCtrl-->>CPU: Data Ready (No Stall)
    else cache_hit = 0 (Miss)
        CacheCtrl-->>CPU: Stall Pipeline!
        CacheCtrl->>Mem: Fetch Block at Address
        Mem-->>CacheCtrl: Return Block (Miss Penalty Latency)
        CacheCtrl->>Arrays: Write Tag, Set Valid=1, Write Data
        CacheCtrl-->>CPU: Release Stall, Data Ready
    end
```

## 3. DRAM Refresh Cycle (Flowchart)

Because of the volatile nature of the 1T1C capacitor, a hardware timer must periodically interrupt normal operations to execute a refresh.

```mermaid
flowchart TD
    Start[Timer reaches 64ms] --> Stall[Memory Controller Stalls CPU requests]
    Stall --> SetRow[Set Row Counter = 0]
    
    ReadRow[Assert RAS: Read Row into Sense Amps]
    Rewrite[Assert WE: Sense Amps Rewrite Row to Capacitors]
    IncRow[Increment Row Counter]
    Check{Row Counter < Max Rows?}
    
    SetRow --> ReadRow
    ReadRow --> Rewrite
    Rewrite --> IncRow
    IncRow --> Check
    
    Check -- Yes --> ReadRow
    Check -- No --> Done[Release CPU Stall]
```
