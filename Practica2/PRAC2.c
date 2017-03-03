#include <stdio.h>

int main(int argc, char **argv)
{
    int N = 80;
    int amc = 5;
    int cmc = 24;
    int mmc = 27;
    char a[N];
    char x = 7;

    for (int i = 0; i < N; i ++)
    {
        x = (amc * x + cmc) % mmc;
        a[i] = x + 64;
    }

    for (int pasada = 0; pasada < N; pasada++)
    {
        for (int j = 0; j < N - pasada - 1; j++)
        {
            if (a[j] > a[j+1])
            {
                char aux = a[j];
                a[j] = a[j+1];
                a[j+1] = aux;
            }
        }
    }

    for (int i = 0; i < N; i++)
        printf("%c ", a[i]);
}