# Pull Request Summary: Cumulative Final Exam Study Guide

## Objective
To synthesize a comprehensive, 14-week Final Exam Study Guide that explicitly aligns with the actual ECE 251 syllabus (excluding SystemVerilog/Hardware Math) and guides students through the exam topics.

## Changes Implemented
* **Final Exam Study Guide (`assignments/study_guide_cumulative_final.md`):**
    * Created an extensive, multi-tiered study guide for Chapters 1-5.
    * Mapped explicit concepts actually taught in class (e.g., IEEE 754, Pipelining, Caches, AMAT, Virtual Memory) to the textbook.
    * Stripped out un-taught material (e.g., Booth's algorithm, hardware division).
    * Integrated targeted definition callouts for foundational terms (Iron Law, Harvard Architecture, Endianness, Locality, etc.).
    * Emphasized an "in-class, closed-book" exam environment format.
* **Syllabus Integration (`ece251-notes.md`):**
    * Added dynamic HTML links to the generated study guide directly within the "Week 15" exam schedule section and at the top of the notes.

## Verification
* Verified alignment of the study guide content strictly against the 14 individual `notes_week_*.md` lecture logs.
* Formatting complies with standard Jekyll/Markdown markdown parsing.
