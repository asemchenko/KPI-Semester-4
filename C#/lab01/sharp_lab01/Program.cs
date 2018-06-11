// by Andrii Semchenko, group IP-63

// implementation based on Prim's algorithm

using System;

namespace sharp_lab01
{
    class Program
    {
        static void Main(string[] args)
        {
            int[,] matrixA;
            if (getAnswerYesOrNo("Create random matrix yes/no: "))
            {
                System.Console.Write("Input matrix size: ");
                matrixA = genRandomMatrix(readInteger());
                System.Console.WriteLine("Created matrix:");
                printMatrix(matrixA);
            }
            else
            {
                matrixA = readMatrix();
            }
            int[,] matrixB = calcMatrixB(matrixA);
            System.Console.WriteLine("Result: ");
            printMatrix(matrixB);
            System.Console.WriteLine("Press any key...");
            System.Console.ReadKey();
        }
        private static bool getAnswerYesOrNo(String request)
        {
            System.Console.Write(request);
            while (true)
            {
                var response = System.Console.ReadLine();
                if (response.Equals("yes"))
                {
                    return true;
                }
                else if (response.Equals("no"))
                {
                    return false;
                }
                System.Console.Write("Wrong answer. Input yes/no. Input your decision: ");
            }
        }
        private static int[,] genRandomMatrix(int size)
        {
            int[,] result = new int[size, size];
            Random randGenerator = new Random();
            for (int i = 0; i < size; i++)
            {
                for (int j = 0; j <= i; j++)
                {
                    result[i, j] = result[j, i] = randGenerator.Next() % 100;
                }
            }
            return result;
        }
        private static int readInteger()
        {
            int result;
            while (!int.TryParse(Console.ReadLine(),out result) || result <= 0)
            {
                System.Console.Write("Error. Please input number greater than 0: ");
            }
            return result;
        }
        static void printMatrix(int[,] matrix)
        {
            for (int i = 0; i < matrix.GetLength(0); i++)
            {
                for (int j = 0; j < matrix.GetLength(1); j++)
                {
                    System.Console.Write(matrix[i, j] + "\t");
                }
                System.Console.WriteLine();
            }
        }
        static int[,] readMatrix()
        {
            System.Console.Write("Input matrix size: ");
            int matrix_size = readInteger();
            int[,] matrixA = new int[matrix_size, matrix_size];
            System.Console.WriteLine("Input matrix A:");
            for (int i = 0; i < matrix_size; i++)
            {
                for (int j = 0; j < matrix_size; j++)
                {
                    System.Console.Write("Input element A[" + (i + 1) + "][" + (j + 1) + "]: ");
                    matrixA[i, j] = readInteger();
                }
            }
            return matrixA;
        }
        static int[,] calcMatrixB(int[,] matrixA)
        {
            int vertexCount = matrixA.GetLength(0);
            int[,] b = new int[vertexCount, vertexCount];
            for(int i = 0; i < vertexCount; ++i)
            {
                for (int j = 0; j <= i; j++)
                {
                    b[i, j] = b[j, i] = 0;
                }
            }
            var vertexsParent = getVertexsParent(matrixA);
            foreach (int key in vertexsParent.Keys)
            {
                int value = vertexsParent[key];
                b[key, value] = b[value, key] = 1;
            }
            return b;
        }
        private static System.Collections.Generic.Dictionary<int, int> getVertexsParent(int [,] matrixA)
        {
            int vertexCount = matrixA.GetLength(0);
            int[] distance = new int[vertexCount];
            for (int i = 0; i < distance.Length; ++i)
            {
                distance[i] = int.MaxValue;
            }
            var vertexs = new System.Collections.Generic.List<int>(vertexCount);
            var vertexsParent = new System.Collections.Generic.Dictionary<int, int>();
            for (int i = 0; i < vertexCount; ++i)
            {
                vertexs.Add(i);
            }
            distance[0] = 0;
            while (vertexs.Count != 0)
            {
                vertexs.Sort((x, y) => x - y);
                int curVertex = vertexs[0];
                vertexs.RemoveAt(0);
                foreach (int otherVertex in vertexs)
                {
                    int distFromCurToOther = matrixA[curVertex, otherVertex];
                    if (0 <= distFromCurToOther && distFromCurToOther < distance[otherVertex])
                    {
                        distance[otherVertex] = distFromCurToOther;
                        vertexsParent[otherVertex] = curVertex;
                    }
                }
            }
            return vertexsParent;
        }
    }
}
