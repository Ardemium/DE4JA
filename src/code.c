#include <stdio.h>
#include <string.h>

void use_strcpy() {
    char src[10] = "source";
    char dest[10];
    strcpy(dest, src);
}

void use_strcpy_with_input() {
    char src[50];
    char dest[50];
    fgets(src, sizeof(src), stdin);
    strcpy(dest, src);
}

void use_strcpy_with_input_mismatch() {
    char src[50];
    char dest[20];
    fgets(src, sizeof(src), stdin);
    strcpy(dest, src);
}

int main() {
    use_strcpy();
    use_strcpy_with_input();
    use_strcpy_with_input_mismatch();
    return 0;
}