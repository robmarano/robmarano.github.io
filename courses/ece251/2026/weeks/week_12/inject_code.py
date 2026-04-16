import os
import re

def get_language(filename):
    if filename.endswith('.sv') or filename.endswith('.v'):
        return 'systemverilog'
    elif filename.endswith('.py'):
        return 'python'
    elif filename.endswith('.asm'):
        return 'assembly'
    elif filename.endswith('.md'):
        return 'markdown'
    else:
        return 'text'

def generate_markdown(directory):
    files = []
    for f in os.listdir(directory):
        if f.endswith('.sv') or f.endswith('.v') or f.endswith('.py') or f.endswith('.asm'):
            files.append(f)
    files.sort()
    
    md_chunks = []
    for f in files:
        filepath = os.path.join(directory, f)
        with open(filepath, 'r') as fp:
            content = fp.read()
        lang = get_language(f)
        md_chunks.append(f"<details><summary><code>{f}</code></summary>\n\n```{lang}\n{content}\n```\n</details>\n<br>")
    
    return "\n".join(md_chunks)

# 1. Update notes_week_12.md
week12_dir = '/Users/rob/dev/robmarano.github.io/courses/ece251/2026/weeks/week_12/pipelined_cpu_exceptions'
notes_12_path = '/Users/rob/dev/robmarano.github.io/courses/ece251/2026/weeks/week_12/notes_week_12.md'

with open(notes_12_path, 'r') as f:
    notes_12 = f.read()

markdown_12 = generate_markdown(week12_dir)

# Find bounds using regex
pattern_12 = re.compile(r'(<details><summary><code>_timescale\.sv</code></summary>)(.*?)(To practically evaluate the pipelined structural bounds)', re.DOTALL)

def repl_12(match):
    return markdown_12 + "\n" + match.group(3)

new_notes_12 = pattern_12.sub(repl_12, notes_12)
with open(notes_12_path, 'w') as f:
    f.write(new_notes_12)

# 2. Update week_11/pipelined_cpu/README.md
week11_dir = '/Users/rob/dev/robmarano.github.io/courses/ece251/2026/weeks/week_11/pipelined_cpu'
readme_11_path = '/Users/rob/dev/robmarano.github.io/courses/ece251/2026/weeks/week_11/pipelined_cpu/README.md'

with open(readme_11_path, 'r') as f:
    readme_11 = f.read()

markdown_11 = generate_markdown(week11_dir)

# Check if `## Component Logic Source Code` exists
if '## Component Logic Source Code' in readme_11:
    # Replace everything after it
    idx = readme_11.find('## Component Logic Source Code')
    readme_11 = readme_11[:idx]

new_readme_11 = readme_11.strip() + "\n\n## Component Logic Source Code\n\n" + markdown_11

with open(readme_11_path, 'w') as f:
    f.write(new_readme_11)

print("Code injection completely finished for Week 11 and Week 12!")
