// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>

// int main()
// {
//     val numbers = mutableListOf<Int>()
//     print("Введите три числа через пробел: ")
//     val input = readLine()
    
//     if (input != null) {
//         val nums = input.split(" ")
//         for (num in nums) {
//             numbers.add(num.toInt())
//         }
//     }

//     bubbleSort(numbers)

//     // Вывод отсортированных чисел
//     println("Отсортированный массив: $numbers")
//     println("Число, стоящее между двумя другими: ${numbers[1]}")
// // /*
// //      Для чтения входных данных необходимо получить их
// //      из стандартного потока ввода (stdin).
// //      Данные во входном потоке соответствуют описанному
// //      в условии формату. Обычно входные данные состоят
// //      из нескольких строк.

// //      Можно использовать несколько функций для чтения из stdin:
// //      * scanf() -- читает данные из потока;
// //      * fgets() -- читает строку из потока;
// //      * gets() -- читает строку из потока до символа '\n'.

// //      Чтобы прочитать из строки стандартного потока:
// //      * число -- int var; scanf("%d", &var);
// //      * строку -- char svar[100]; scanf("%s", svar);
// //      * массив чисел известной длины --
// //      int len; scanf("%d", &len);
// //      int* arr = (int*) malloc(len * sizeof(int));
// //      for (int i = 0; i < len; ++i)
// //       scanf("%d", &arr[i]);
// //      * последовательность слов до конца файла --
// //      char word[100];
// //      while (scanf("%s", word) == 1) {
// //       // do something with word
// //      }

// //      Чтобы вывести результат в стандартный поток вывода (stdout),
// //      можно использовать функцию printf().

// //      Возможное решение задачи "Вычислите сумму A+B":


// //      int a, b;
// //      scanf("%d%d", &a, &b);
// //      printf("%d\n", a + b);
// // */

//      return 0;
// }

// fun bubbleSort(numbers: MutableList<Int>) {
//     val n = numbers.size
//     for (i in 0 until n - 1) {
//         for (j in 0 until n - i - 1) {
//             if (numbers[j] > numbers[j + 1]) {
//                 val temp = numbers[j]
//                 numbers[j] = numbers[j + 1]
//                 numbers[j + 1] = temp
//             }
//         }
//     }
// }


