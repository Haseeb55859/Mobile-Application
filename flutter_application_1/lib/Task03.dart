import 'dart:io';
void main()
{
  stdout.write("Enter the value of n :");
  int n = int.parse(stdin.readLineSync()!);

  for(int i =0; i<n; i++)
  {
    for(int j =1; j<i; j++){
      stdout.write("$j");
    }
  }
  print("");

}