import re

with open('ece251_week_12_slides.tex', 'r') as f:
    content = f.read()

new_slides = """
\begin{frame}{7. Complex Exception Theory: Restartable & Precise Exceptions}
\begin{itemize}
    \item \textbf{Precise Exceptions}: The MIPS pipeline explicitly guarantees that the state of the processor is saved precisely at the faulting instruction natively. All preceding instructions must cleanly commit, and instruction following it are entirely purged.
    \item \textbf{Restartable Datapaths}: Because we physically track execution limits backwards via the \texttt{EPC} ($P_C$ - 4), the OS possesses the native mathematical capacity to transparently re-inject the failed program directly into the fetching queues exactly where it stopped.
    \item \textbf{Imprecise Exceptions}: Heavily clustered Out-Of-Order CPU architectures mathematically drop pinpoint recovery limitations, isolating faults to a general "vicinity" and drastically ballooning OS handler complexity constraints natively.
\end{itemize}
\end{frame}

\begin{frame}{8. Complex Exception Theory: Multiple Fault Constraints}
\begin{itemize}
    \item What natively happens if \textbf{two isolated instructions} concurrently crash across uniquely decoupled pipeline stages during the exact same $T_c$ clock window? (e.g., A memory fault physically intersecting an arithmetic overflow).
    \item \textbf{Hardware Prioritization}: The digital architecture intrinsically favors the \textit{oldest} structural instruction actively running (residing mathematically furthest down the pipeline tracks, such as EX/MEM bounds).
    \item Younger instructions trailing backwards across the IF/ID registers simply haven't formally completed their theoretical lifetimes yet, and thus structurally yield their active interrupts until re-execution.
\end{itemize}
\end{frame}

\begin{frame}[fragile]{9. Global Sandbox: \texttt{pipelined\_cpu\_exceptions}}
\begin{itemize}
    \item All the digital concepts actively synthesized are tracked continuously inside our live \texttt{pipelined\_cpu\_exceptions} hardware namespace.\\
    \item The entire Patterson \& Hennessy theoretical framework natively compiles into executable boolean topologies:
\end{itemize}
\begin{verbatim}
├── datapath.sv   # Maps NextPC -> 0x8000_0180 OS boundary
├── hazard.sv     # Maps asynchronous Exception_Flag -> flush loops
├── mem.sv        # Bootstraps .org boundary arrays cleanly
├── controller.sv # Natively tracks Exception bounds
└── test_prog.asm # Compiles structural exception MIPS sequences
\end{verbatim}
\end{frame}

\begin{frame}{10. Debugging Resolutions: 4-Bit ALU Decoupling}
\begin{itemize}
    \item Incorporating complex math vectors natively clashed with native MIPS bounds.
    \item By natively widening \texttt{alucontrol} variables from structural 3-Bit \texttt{[2:0]} to deep 4-Bit \texttt{[3:0]} limits, we decoupled math logic fundamentally:
    \item Combinational overlap failures mathematically disappeared because Arithmetic Logic (`4'b0111`) permanently diverged dynamically away from Sequential structural footprints actively isolating \texttt{MULT} (`4'b1001`) and \texttt{DIV} (`4'b1000`) execution bounds!
\end{itemize}
\end{frame}

\begin{frame}{11. Debugging Resolutions: Memory Depth \& Aliasing}
\begin{itemize}
    \item Exceptions mechanically redirect hardware to absolute vector limit \texttt{0x8000 0180}.
    \item A generic Datapath limiting array depth to parameter $r=6$ natively forces Index \texttt{96} (\texttt{0x180}) to roll back via modulus limits dynamically onto integer \texttt{32} (\texttt{0x080}).
    \item Expanding system boundaries natively to $r=8$ establishes a valid OS memory isolation space stretching cleanly to $2^8 = 256$ deep memory frames, granting the OS handler dedicated non-aliasing boundaries natively.
\end{itemize}
\end{frame}

\begin{frame}{12. Verification Matrix: The 7 Assembly Playbooks}
\begin{itemize}
    \item We fully assert the architecture logic leveraging extensive workload matrices simulating MIPS bounds:
    \begin{enumerate}
        \item \texttt{prog1\_simple}: Linear testing ensuring Forwarding pipelines.
        \item \texttt{prog2\_leaf}: Validating Control branches flushing predictions cleanly.
        \item \texttt{prog3\_nested}: Nested variables generating Load/Use stalls on stacks.
        \item \textbf{\texttt{prog4\_interrupts}}: Structurally overriding datapath sequences internally dumping active limits securely into kernel space.
    \end{enumerate}
\end{itemize}
\end{frame}
"""

# Split points
pre_retrospective = content[:content.find("\\begin{frame}{7.")]
post_retrospective = content[content.find("\\begin{frame}{7."):]

# Renumber post_retrospective
def renumber_match(match):
    new_num = int(match.group(1)) + 6 # Offset by 6 since we added 6 slides (7 to 12)
    return f"\\begin{{frame}}[{match.group(2)}]{{{new_num}."

# Regex to match \begin{frame}[fragile]{7. or \begin{frame}{7.
import re
# We will handle [fragile] optionally
renumbered_post = re.sub(r'\\begin\{frame\}(\[fragile\])?\{(\d+)\.', lambda m: f'\\begin{{frame}}{m.group(1) or ""}{{{int(m.group(2)) + 6}.', post_retrospective)

final_content = pre_retrospective + new_slides + "\n" + renumbered_post

with open('ece251_week_12_slides.tex', 'w') as f:
    f.write(final_content)

print("Done rewriting and sequentially numbering slides.")
