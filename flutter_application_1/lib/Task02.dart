import 'dart:io';

void main(){

stdout.write("Enter your name : ");
String? name = stdin.readLineSync();

stdout.write("Enter your age : ");
int age = int.parse(stdin.readLineSync()!);

if(age<18)
{
 print("Sorry $name, are not eligiable for registration");

}
else{
  print(" $name, you are eligiable for registration..");

}
stdout.write("How many numbers you want to enter");
int n = int.parse(stdin.readLineSync()!);

List <int> numbers = [];
for(int i =0; i<n; i++)
stdout.write("Enter number ${i+1}:");
int num = int.parse(stdin.readLineSync()!);
numbers.add(num);

print("you Enter : $numbers");

}