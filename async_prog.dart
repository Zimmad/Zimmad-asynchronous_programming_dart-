import 'dart:async';

//! ---- ------- ----------- Exmample_1 (Future)---- ------- -----------//
/// To get some value from [Feture], You have to wait for it value using [await] keyword. To use [await] the function must be [async].
/// use [await] for future to kick start them. To kick start a [Future] and grab the final value of a Future you have to use the [await] keyword.
///

// void main(List<String> args) async {
//   print('hello world');
//   print(await getUserName());
//   print(await getAddress());
//   print('Runned after the future ');
// }

// // Future<String> getUserName() async {
// //   return Future.delayed(
// //     Duration(seconds: 1),
// //     () => 'zimmad',
// //   );
// // }

// Future<String> getUserName() async => 'this is name';

// Future<String> getAddress() {
//   return Future.value('1234 Main St');
// }

// Future<String> getUserNo() async {
//   await Future.delayed(Duration(seconds: 1));
//   return " 3333-344443333";
// }

//! ---- ------- ----------- Exmample_2 (Future Error handling)---- ------- -----------//

// void main(List<String> args) async {
//   // print(getFullName(firstName: '', lastName: 'also not empty'));

//   try {
//     print(await getFullName(firstName: '', lastName: 'lastName'));
//   } on FirstOrLastNameException {
//     print(' FirstAndLastNameException occured at line : 37');
//   }
// }

// Future<String> getFullName({
//   required String firstName,
//   required String lastName,
// }) async {
//   if (firstName.isEmpty || lastName.isEmpty) {
//     throw FirstOrLastNameException();
//   } else {
//     // return Future.value('$firstName $lastName');
//     return '$firstName $lastName'; // turn your function to sync
//   }
// }

// class FirstOrLastNameException implements Exception {
//   const FirstOrLastNameException();
// }

//! ---- ------- ----------- Exmample_3 (Future Chaining)---- ------- -----------//
//* Future chaing is : a Future that calculates a value and feds it into another future (which than produces another future value)
//* it is ther posibility of feeding the value of one future to another future

// void main(List<String> args) async {
//   //* this is chaining of futures
//   // print(await getLengt(await getString()));

// //* this is actual chaining of futures
//   final foo = await getString().then((value) =>
//       getLengt(value)); //we get a future of int and we than awit on it
//   print(foo);
// }

// Future<String> getString() => Future.delayed(
//       const Duration(seconds: 1),
//       () => 'this is a String',
//     );

// Future<int> getLengt(String value) => Future.delayed(
//       const Duration(seconds: 1),
//       () => value.length,
//     );

//! ---- ------- ----------- Exmample_4     (    Streams  )---- ------- -----------//
//* Streams are like chain of events
// void main(List<String> args) async {
//   /// To consume [Streams] use the keyword [await for]. It works just like [await (in case of futures)].
//   await for (var item in getStreamOfInts()) {
//     print(item);
//   }
// }

// //* there are multiple ways of returning a Stream. one way is to mark your function with a '*' like [async*]
// /// use a [yield] keyword inOrder to [return] a value within a stream
// Stream<int> getStreamOfInts() async* {
//   for (int i = 0; i < 10; i++) {
//     await Future.delayed(const Duration(seconds: 1));
//     yield i;
//   }
// }

// Stream<String> getNames() async* {
//   await Future.delayed(const Duration(seconds: 1));
//   yield 'Name';
//   throw Exception('something went wrong');
// }

//! ---- ------- ----------- Exmample_5    (Streams   [asyncExpnd method]  )---- ------- -----------//

/// [asyncExpand()] is a function on [Stream] that for every value that a [Stream] produces we can create another [Stream]
/// [asyncExpand()] is similar to [futture then] method

// void main(List<String> args) async {
//   final result = getNames().asyncExpand((event) => getCharacters(event));
//   await for (var i in result) {
//     print(i);
//   }
// }

// Stream<String> getCharacters(String fromString) async* {
//   for (int i = 0; i < fromString.length; i++) {
//     await Future.delayed(const Duration(milliseconds: 300));
//     yield fromString[i];
//   }
// }

// Stream<String> getNames() async* {
//   await Future.delayed(const Duration(milliseconds: 200));
//   yield 'Name     ';

//   await Future.delayed(const Duration(milliseconds: 200));
//   yield 'Second Name';
// }

//! ---- ------- ----------- Exmample_6     (Streams   [reduce method]  )---- ------- -----------//

/// [ reduce ] method on [Stream] gives the current and the previous value of the stream and allows you to do some calculation on the [it]
// void main(List<String> args) async {
//   /// getting [sum] of [getAllAges] [Stream]

//   int sum = 0;
//   await for (var age in getAllAges()) {
//     sum += age;
//   }
//   print(sum);

//   /// now using the [reduce] method

//   final sumSec = await getAllAges().reduce(sumFun);

//   // final sumSec =
//   //     await getAllAges().reduce((previous, element) => /*previous + element*/ sumFun(previous, element));

//   print(sumSec);
// }

// int sumFun(int a, int b) => a + b;

// Stream<int> getAllAges() async* {
//   yield 20;
//   yield 40;
//   yield 60;
//   yield 10;
//   yield 20;
//   yield 50;
// }

//! ---- ------- ----------- Exmample_7    (Streams   [async generator]  )---- ------- -----------//

///Example::::-- let say we want a function that take a start and end intigers and it will simply go from that start to that end and it will call a funtion
///with that value to know wether that value should be included in the resulting [Stream], that we are going to pass seperate function pointers to that function.
// void main(List<String> args) async {
//   /// will print out [ 0,1,2,3]
//   // await for (final value in numbers()) {
//   //   print(value);
//   // }

//   /// will print out only [ 1,3]
// //   await for (final value in numbers(f: oddNumbersOnly)) {
// //     print(value);
// //   }
// // }

//   /// will print out only [ 0,2,4,6,8,10]
//   await for (final numb in numbers(end: 11, f: eventNumbersOnly)) {
//     print(numb);
//   }
// }

// bool eventNumbersOnly(int val) => val % 2 == 0;
// bool oddNumbersOnly(int val) => val % 2 != 0;

// typedef IsIncluded = bool Function(int vlue);

// Stream<int> numbers({
//   int start = 0,
//   int end = 4,
//   IsIncluded? f,
// }) async* {
//   for (var i = start; i < end; i++) {
//     if (f == null || f(i)) {
//       yield i;
//     }
//   }
// }

//! ---- ------- ----------- Exmample_8    (Streams   [yield*] (yielding Streams)  )---- ------- -----------//

// void main(List<String> args) async {
//   await for (var name in allNames()) {
//     print(name);
//   }
// }

// Stream<String> maleNames() async* {
//   yield 'Omar ibn Khattab';
//   yield 'Khalid bin Waleed';
//   yield 'Salahuddin Ayubbi';
// }

// Stream<String> femaleNames() async* {
//   yield 'Fatimah';
//   yield 'Sadia';
//   yield 'Zohra';
// }

// Stream<String> allNames() async* {
//   /// This is one way
//   // await for (var name in maleNames()) {
//   //   yield name;
//   // }

//   // await for (var name in femaleNames()) {
//   //   yield name;
//   // }
// //* -----------      --------       -------------      -----------
//   /// [2nd way] of doing this
//   yield* maleNames();
//   yield* femaleNames();
// }

// //! ---- ------- ----------- Exmample_9    (Streams   [StreamControllers]  )---- ------- -----------//
// /// a [stream controller] is an object that we can add and read values from
// /// [ StreamController] is [read] and [write]. [Stream] are [read] only
// void main(List<String> args) async {
//   final controller = StreamController<String>();

//   controller.sink.add('Hello');
//   controller.sink.add('World');
//   controller.add(
//       'using add only, (no sink is used)'); // ToDo: what is the purpose of using [sink] while adding a value?

//   await for (var i in controller.stream) {
//     print(i);
//   }
// }

//! ---- ------- ----------- Exmample_10    (Streams   [Stream Tronsformers]  )---- ------- -----------//

/// A [StreamTransformer] is a class that takes one [Stream] and changes it into another [Stream]
/// A [streamtransformer] is use to transform every value of a stream and than return a [Stream]
/// A
// void main(List<String> args) async {
//   // await for (var name in names) {
//   //   print(name.toUpperCase());
//   // }

//   // await for (var name in names.map((name) => name.toLowerCase())) {
//   //   print(name);
//   // }

//   await for (var name in names.capatilizedUsingMap) {
//     print(name);
//   }

//   print('------------------------------------------------------------');

//   await for (var name in names.capatilizeUsingTransformer) {
//     print(name);
//   }
// }

// /// [StreamTreansformerBase< String(input val), String(output val) >  ]   needs one [@override] method

// class ToUpperCase extends StreamTransformerBase<String, String> {
//   @override
//   Stream<String> bind(Stream<String> stream) {
//     return stream.map((value) => value.toUpperCase());
//   }
// }

// extension on Stream<String> {
//   /// we uses our [transofrmer] here
//   Stream<String> get capatilizeUsingTransformer =>
//       this.transform(ToUpperCase());

//   /// [capatilizedUsingMap] uses [map] method directly
//   Stream<String> get capatilizedUsingMap =>
//       map((string) => string.toUpperCase());
// }

// Stream<String> names = Stream.fromIterable([
//   'Name 1',
//   'Name 2',
//   'Nmae 3',
// ]);

//! ---- ------- ----------- Exmample_11    (Streams   [.toList] method )---- ------- -----------//
/// creating a [Future] out of [Stream]
// void main(List<String> args) async {
//   final futureOfGetNames = getNames().toList();

//   final allNames = await futureOfGetNames;
//   print(allNames);
// }

// Stream<String> getNames() async* {
//   yield 'Omar ibn Khattab';
//   yield 'Khalid bin Waleed';
//   yield 'Salahuddin Ayubbi';
// }

//! ---- ------- ----------- Exmample_12    (Streams   [Absorbing Stream Errors]  )---- ------- -----------//
/// [3 ways] the three different ways of handling [Stream] [erros]

// void main(List<String> args) async {
//   // getNames().handleError(() {
//   //   print('an error occured while fetching data from stream');
//   // });

//   /// this will absorb [errros] using [absorbErrorsUsingHandleError()]
//   await for (final name in getNames().absorbErrorsUsingHandleError()) {
//     print(name);
//   }
//   ;

//   /// this will absorb [errros] using [absorbErrorsUsingHandlers2(]
//   await for (final name in getNames().absorbErrorsUsingHandlers2()) {
//     print(name);
//   }
//   ;

//   /// this will absorb [errros] using [absorbErrorsUsingTransformers()]
//   await for (var name in getNames().absorbErrorsUsingTransformers()) {
//     print(name);
//   }
// }

// extension AbsorbError<T> on Stream<T> {
//   Stream<T> absorbErrorsUsingHandleError() => handleError(
//         (error, stackTrace) {}, // we does not do anthing
//       );

//   Stream<T> absorbErrorsUsingHandlers2() {
//     return transform(StreamTransformer.fromHandlers(
//       handleError: (error, stackTrace, sink) => sink.close(),
//     ));
//   }

//   /// using the [transform (stramTransformer) ] to absorb [errors] inside our Stream
//   Stream<T> absorbErrorsUsingTransformers() => transform(StreamErrorAbsorber());
// }

// /// creating [StreamTransformerBase] for absorbing [errors] .
// class StreamErrorAbsorber<T> extends StreamTransformerBase<T, T> {
//   @override
//   Stream<T> bind(Stream<T> stream) {
//     final controller = StreamController<T>();

//     stream.listen(controller.sink.add,
//         onError: (error) {/* we just ignore the error */}, onDone: () {
//       controller.close();
//     });
//     return controller.stream;
//   }
// }

// /// --- our actual [Stream] of [String]
// Stream<String> getNames() async* {
//   yield 'Omar ibn Khattab';
//   yield 'Khalid bin Waleed';
//   yield 'Salahuddin Ayubbi';
//   throw 'this will trow an error at the end'; // this error will be absorb using stream transformers
// }

//! ---- ------- ----------- Exmample_13    (Streams   [Stream.asyncMap and Fold]  )---- ------- -----------//

// void main(List<String> args) async {
//   final result = await getNames()
//       .asyncMap((name) => extractCharacters(name))
//       .fold('', (previous, element /* [element] is List<String> */) {
//     final elements =
//         element.join(' '); // we convert a [List<String>] to a [String]
//     // return '$previous ||||  $elements'; // we returns the String with it previous value.
//     return '$previous ---  $elements'; // we returns the String with it previous value.
//   });
//   //  final result = await getNames().asyncMap((name) => extractCharacters(name));
//   // await for (var names in result) {
//   //   print(names);
//   // }

//   // int res = 0;
//   // List<List<int>> ints = [
//   //   [1, 2, 3, 4, 5],
//   //   [1, 2, 3, 4, 5]
//   // ];
//   // final sum = ints.fold(0, (previousValue, element) {
//   //   res = res +
//   //       element.fold(
//   //           0, (int previousValue, element) => previousValue + element);
//   //   return res;
//   // });

//   // print(res);
//   // print(sum);

//   print(result);
// }

// Stream<String> getNames() async* {
//   yield 'Omar ibn Khattab';
//   yield 'Khalid bin Waleed';
//   yield 'Salahuddin Ayubbi';
// }

// Future<List<String>> extractCharacters(String input) async {
//   final characters = <String>[];
//   for (var character in input.split('')) {
//     /* .split returns a list of sustrings */
//     await Future.delayed(Duration(microseconds: 100));
//     characters.add(character);
//   }
//   return characters;
// }

//! ---- ------- ----------- Exmample_14    (Streams   [Stream.asyncMap ]  )---- ------- -----------//

///using [asyncMap] that convets every [element] of a [Stream] to a [Stream] of itSelf
// void main(List<String> args) async {
//   final names = getNames().asyncExpand((name) => time3(name));
//   await for (var name in names) {
//     print(name);
//   }
// }

// Stream<String> getNames() async* {
//   yield 'Omar ibn Khattab';
//   yield 'Khalid bin Waleed';
//   yield 'Salahuddin Ayubbi';
// }

// // this function takes a stream value and repeats it three times

// Stream<String> time3(String value) {
//   return Stream.fromIterable(
//     Iterable.generate(
//       3,
//       (index) => value,
//     ),
//   );
// }

//! ---- ------- ----------- Exmample_15    (Streams   [Stream.asyncMap ]  )---- ------- -----------//

/// we have [Two Types] of [Stream] , [Broadcast Stream] and [Non-Broadcast Stream]
/// A [Broadcast Stream] is a [Stream] that multiple listeners can listen to at a sametime
/// A [Non-Broadcast Stream] is a [Stream] that only one listener can listen to at a sametime
///
// void main(List<String> args) async {
//   await braodCastStreamExample();
//   await nonBraodCastStreamExample();
// }

// Future<void> nonBraodCastStreamExample() async {
//   final controller = StreamController<String>();
//   controller.sink.add('Obeda bin Jarrah');
//   controller.sink.add('Abdurrehman ibn Gouf');
//   controller.sink.add('Tariq bin Ziyad');

//   late final sub1;
//   final sub2 = controller.stream;
//   try {
//     sub1 = controller.stream.listen((event) {
//       print('form non Broadcast stram sub1:  $event');
//     });

//     /// for non-Broadcast Stream we cannot have multiple listners
//     /// below code will throw an exception (so we puts it into a try_catch block)
//     sub2.listen((event) {
//       print('form non BroadCast Stram sub2: $event');
//     });
//   } catch (e) {
//     print(e);
//   }

//   // try {
//   //   await for (var name in controller.stream) {
//   //     print(name);

//   //     ///we are listening to the stream again. ( this is like nested for loop)
//   //     await for (var name2 in controller.stream) {
//   //       print(name2);
//   //     }
//   //   }
//   // } catch (e) {
//   //   print(e);
//   // }

//   controller.close();
//   controller.onCancel = () {
//     print('nonBroadcast Stream Oncancel called');
//     sub1.cancel();
//   };
// }

// Future<void> braodCastStreamExample() async {
//   final StreamController<String>
//       controller; /*  = StreamController<String>.broadcast(); works the same as bleow*/

//   controller = StreamController<String>.broadcast();

//   final sub1 = controller.stream.listen((name) {
//     print('sub1: $name');
//   });
//   final sub2 = controller.stream.listen((name) {
//     print('sub2: $name');
//   });

//   controller.sink.add('Obeda bin Jarrah');
//   controller.sink.add('Abdurrehman ibn Gouf');
//   controller.sink.add('Tariq bin Ziyad');

//   controller.close();
//   controller.onCancel = () {
//     print('onCancel');
//     sub1.cancel();
//     sub2.cancel();
//   };
// }

//! ---- ------- ----------- Exmample_16    (Streams   [Stream Timeout ]  )---- ------- -----------//

///when you wat your stream to give you a value in atleast some time (max time for every x number of secondes(duration))

// void main(List<String> args) async {
//   try {
//     await for (var name
        // in getNames().withTimeoutBetweenEvent(Duration(seconds: 3))) {
//       print(name);
//     }
//   } on TimeoutBetweenEventException catch (e, stacktrace) {
//     print('Timeout Between Event Exception :: $e');
//     print('Stack trace: $stacktrace');
//   }
// }

// Stream<String> getNames() async* {
//   yield 'Omar ibn Khattab';

//   await Future.delayed(Duration(seconds: 1));
//   yield 'Khalid bin Waleed';

//   await Future.delayed(Duration(seconds: 10));
//   yield 'Salahuddin Ayubbi';
// }

// extension WithTimeoutBetweenEvent<T> on Stream<T> {
//   Stream<T> withTimeoutBetweenEvent(Duration duration) =>
//       transform(TimeoutBetweenEvent(duration: duration));
// }

// class TimeoutBetweenEvent<E> extends StreamTransformerBase<E, E> {
//   final Duration duration;

//   TimeoutBetweenEvent({required this.duration});

//   @override
//   Stream<E> bind(Stream<E> stream) {
//     StreamController<E>? controller;
//     StreamSubscription<E>? subscription;
//     Timer? timer;

//     controller = StreamController(onListen: () {
//       stream.listen((data) {
//         timer?.cancel();

//         timer = Timer.periodic(
//           duration,
//           (timer) {
//             controller?.addError(TimeoutBetweenEventException(
//                 message:
//                     'timeout, we did not recieve any event in the expected time'));
//           },
//         );

//         controller?.add(data);
//       }, onError: controller?.addError, onDone: controller?.close);
//     }, onCancel: () {
//       subscription?.cancel();
//       timer?.cancel();
//     });

//     return controller.stream;
//   }
// }

// class TimeoutBetweenEventException implements Exception {
//   final String message;

//   TimeoutBetweenEventException({required this.message});
// }
