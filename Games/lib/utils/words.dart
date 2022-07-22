import "dart:math";

String words() {
  
  List<String> fruits = ["naranja".toUpperCase(), "pera".toUpperCase(), "uva".toUpperCase(), "mora".toUpperCase()];
  List<int> weights = [1, 2, 3, 4];


  List<int> l = [];
  weights.asMap().forEach((int idx, int weight) { 
    l += List.filled(weight, idx); 
  });
  //print(l); 

  
  var _random = new Random();
  int idx = l[_random.nextInt(l.length)];

  return fruits[idx].toUpperCase();
}