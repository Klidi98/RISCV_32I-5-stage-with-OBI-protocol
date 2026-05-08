volatile int result;

int count_list(int *p) {
    if (*p == -1) return 0;
    return 1 + count_list(p + 1);
}

int main() {
    static int list[] = { 7, 3, 9, 12, -1 };

    result = count_list(list); 

    while (1);  
    return 0;
}
