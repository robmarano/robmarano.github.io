# Pull Request Summary: Global Broken Image Link Fix

## Objective
To resolve broken image links in the live GitHub Pages site across multiple weeks of ECE 251 notes.

## Changes Implemented
* Identified that images were previously referenced via relative links to the `Image Bank` directory.
* Discovered that `Image Bank` is explicitly ignored via the global `.gitignore` due to its massive 1.2 GB size, causing 404 Not Found errors on the live web server.
* Wrote an automated Python script to crawl all `notes_week_*.md` and `ece251_week_*_slides.tex` files.
* Dynamically copied all 24 referenced, unique textbook images from the untracked `Image Bank` into a new tracked directory: `courses/ece251/images/textbook/`.
* Updated all Markdown `<img>` and LaTeX `\includegraphics{}` paths to point to the tracked images directory.

## Verification
* A total of 4.41 MB of necessary images were migrated and committed.
* Local compilation of LaTeX works correctly.
* GitHub Pages will now successfully serve the tracked images on all live syllabus pages.
