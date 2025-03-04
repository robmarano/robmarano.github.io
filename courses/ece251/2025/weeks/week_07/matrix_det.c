#include <stdio.h>
#include <stdlib.h>

#define N 3

// Function for finding the determinant of a matrix.
int getDet(int mat[N][N], int n)
{

    // Base case: if the matrix is 1x1
    if (n == 1)
    {
        return mat[0][0];
    }

    // Base case for 2x2 matrix
    if (n == 2)
    {
        return mat[0][0] * mat[1][1] -
               mat[0][1] * mat[1][0];
    }

    // Recursive case for larger matrices
    int res = 0;
    for (int col = 0; col < n; ++col)
    {

        // Create a submatrix by removing the
        // first row and the current column
        int sub[N][N]; // Submatrix
        for (int i = 1; i < n; ++i)
        {
            int subcol = 0;
            for (int j = 0; j < n; ++j)
            {

                // Skip the current column
                if (j == col)
                    continue;

                // Fill the submatrix
                sub[i - 1][subcol++] = mat[i][j];
            }
        }

        // Cofactor expansion
        int sign = (col % 2 == 0) ? 1 : -1;
        res += sign * mat[0][col] * getDet(sub, n - 1);
    }

    return res;
}

// Driver program to test the above function
int main()
{
    // int mat[N][N] = {{10, 5, 1},
    //                  {1, 10, 5},
    //                  {5, 1, 10}};
    int mat[N][N] = {{1, 2, 3},
                     {4, 5, 6},
                     {7, 8, 9}};
    // int mat[N][N] = {{1, 0, 0},
    //                  {0, 1, 0},
    //                  {0, 0, 1}};
    printf("%d\n", getDet(mat, N));
    return 0;
}
