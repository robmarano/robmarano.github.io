#include <stdio.h>

char *prompt = "> ";
char *newline = "\n";
char *msg1 = "Hello, World!";
char *msg2 = "Integer = ";
char *msg3 = "Pi = ";

int foobar = 4;
float pi = 3.14159265;

void main(void)
{
    printf("%s", prompt);
    printf("%s", msg1);
    printf("%s", newline);
    printf("%s", prompt);
    printf("%s", msg2);
    printf("%d", foobar);
    printf("%s", newline);
    printf("%s", prompt);
    printf("%s", msg3);
    printf("%f", pi);
    printf("%s", newline);
}