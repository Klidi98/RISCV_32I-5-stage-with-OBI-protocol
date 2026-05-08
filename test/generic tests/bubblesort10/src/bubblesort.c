#include "bubblesort.h"

void bubble_sort(int *arr, uint32_t n)
{
    if (n < 2) return;

    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1 - i; j++) {
            int a = arr[j];
            int b = arr[j + 1];

            if (b < a) {
                arr[j]     = b;
                arr[j + 1] = a;
            }
        }
    }
}
