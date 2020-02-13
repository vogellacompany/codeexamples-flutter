Future<void> printSomeThingDelayed() {
  return Future.delayed(Duration(seconds: 3), () => print('Testing futures'));
}

main() async {
  await printSomeThingDelayed();
  print('Another output ...');
}