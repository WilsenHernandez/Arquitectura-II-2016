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
        for (int i = 0; i < N - pasada - 1; i++)
        {
            if (a[i] > a[i+1])
            {
                char aux = a[i];
                a[i] = a[i+1];
                a[i+1] = aux;
            }
        }
    }

    for (int i = 0; i < N; i++)
        printf("%c ", a[i]);
}