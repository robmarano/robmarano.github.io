import sys
import PyPDF2

def extract_text(pdf_path, txt_path):
    with open(pdf_path, 'rb') as f:
        reader = PyPDF2.PdfReader(f)
        with open(txt_path, 'w', encoding='utf-8') as out:
            for page in reader.pages:
                out.write(page.extract_text() + "\n")

if __name__ == '__main__':
    extract_text("Digital Design and Verilog HDL Fundamentals.pdf", "dd_fundamentals.txt")
    extract_text("Verilog HDL Design Examples.pdf", "vhd_examples.txt")
    extract_text("Structural Design with Verilog - Harris.pdf", "struct_harris.txt")
