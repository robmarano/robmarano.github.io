# robmarano.github.io

Convert to PDF from markdown

```bash
sudo apt-get install pandoc texlive-latex-base texlive-fonts-recommended texlive-extra-utils texlive-latex-extra
```

```bash
pandoc --reference-links --dpi=150 -t pdf ece251-syllabus-spring-2025.md -V geometry="left=3cm,right=3cm,top
=2cm,bottom=2cm" -o ece251_comp_arch_syllabus_spring_2025.pdf
```
