import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'dart:math';

//! ---- ------- ----------- Exmample_1 (Isolates)---- ------- -----------//

/// creatin an isolate function that will produce some messages

// void main(List<String> args) async {
//   await for (var msg in getMessages().take(10)) {
//     print(msg);
//   }
// }

// /// Creating an instance of the ports. This is going to be the entry of our isolates
// /// in this function we have the posibility to do our work. like producing some stream
// Stream<String> getMessages() async* {
//   /// The [RevievePort] has a [sendPort] ie {rp.sendPort}
//   final rp = ReceivePort();

//   /// so we get a copy of the [sendPort] and send it to [_getMesages()]

//   /// Isolate.spawn((message) { }, message)--the first parameter is the actual function that is the isolate, the second parameter
//   /// is our [sendPort]
//   ///  final foo = Isolate.spawn(_getMessages, sp.sendPort); // the [return] of this is [Future<Isolate>]
//   ///final foo = Isolate.spawn(_getMessages, sp.sendPort).asStream(); // this is now [Stream<Isolate>]
//   /// ```
//   ///  final foo = Isolate.spawn(_getMessages, rp.sendPort)  // foo is a [Stream<dynamic>] in our case it is a [Stream<String>]
//   ///  .asStream()
//   /// .asyncExpand((isolate) => rp);
//   /// ```

//   final foo = Isolate.spawn(_getMessages, rp.sendPort)
//       .asStream()
//       .asyncExpand((isolate) => rp)
//       .takeWhile((element) => element is String)
//       .cast<String>();
//   yield* foo;
// }

// ///  This function is same as [above] function
// ///```
// /// Stream<String> getMessages() async* {
// ///   final rp = ReceivePort();
// /// return Isolate.spawn(_getMessages, rp.sendPort)
// ///       .asStream()
// ///       .asyncExpand((isolate) => rp)
// ///       .takeWhile((element) => element is String)
// ///       .cast<String>();
// /// }
// /// ```

// void _getMessages(SendPort sp) async {
//   await for (final now in Stream.periodic(
//       const Duration(
//         milliseconds: 500,
//       ), (_) {
//     return DateTime.now().toIso8601String();
//   })) {
//     /// we have [now] as a [String]. we want to send to we want to send it back to
//     /// whoever creates an instance of us, the way to do so is to use [sendport.send()]
//     /// we are producing strings and sending it back to whoever creates an instance of us

//     sp.send(now);
//   }
// }

//! ---- ------- ----------- Exmample_2 (Isolate communication)---- ------- -----------//

/// IN this example we will talk about how to create [SendPort] an [RecievePort] to communicate
///  between isolate and wraper's(that spawn the isolate) function
// void main(List<String> args) async {
//   do {
//     stdout.write('Say somethig :');
//     final input = stdin.readLineSync(encoding: utf8);
//     switch (input?.trim().toLowerCase()) {
//       case null:
//         continue;
//       case 'exit':
//         exit(0);
//       default:
//         final msg = await getMessages(input!);
//         print(msg);
//     }
//   } while (true);
// }

// Future<String> getMessages(String message) async {
//   final rp = ReceivePort();
//   Isolate.spawn(_communicator, rp.sendPort);
//   final broadcastRp = rp.asBroadcastStream();
//   final SendPort communicatorSendPort = await broadcastRp.first;
//   communicatorSendPort.send(message);

//   return broadcastRp
//       .takeWhile((element) => element is String)
//       .cast<String>()
//       .take(1)
//       .first;
// }

// void _communicator(SendPort sp) async {
//   ///[SendPort] is jsut a vessel in order for us to communicate something back to whoever created an instance of usj ( [Isolate] )
//   ///[SendPort] has only [send] functin, it has no [recieve] function so we can only send data through [SendPort] and can't recieve
//   ///so we will create an instance of [RecievePort] here and will send its [sendport] to the  originator ( the function that creates an instance of [_communicator])
//   ///than we can use that [RecievePort.sendport] in order to get back the messages
//   final rp = ReceivePort();
//   sp.send(rp.sendPort);

//   final messages = rp
//       .takeWhile((element) => element is String)
//       .cast<String>(); // this stream of string contains only one message

//   /// we have only one message so we will [continue] after we get it in the map
//   await for (var message in messages) {
//     for (var entry in messagesAndResponces.entries) {
//       if (entry.key.trim().toLowerCase() == message.trim().toLowerCase()) {
//         sp.send(entry.value);
//         continue;
//       }
//     }
//     sp.send('I have no response to this!');
//   }
// }

// const messagesAndResponces = <String, String>{
//   '': 'ask me a question, like "how are you?"',
//   'Hello': 'HI',
//   'How are you?': 'Fine',
//   'What are you doing': 'Learning about Isolates in Dart',
//   'are you having fun': 'Yeah, for sure!',
//   'I love you ': 'Merry me, than'
// };

//! ---- ------- ----------- Exmample_3 (Keeping an Isolate Alive)---- ------- -----------//
/// This example functions the same as the previous one .
/// In this code we create an Isolate and kept it alive, and we are not creating a new
/// Isolate everytime the user input a message (String value)

// void main(List<String> args) async {
//   final responder = await Responder.create();
//   do {
//     stdout.write('Say somethig (or type exit): ');
//     final input = stdin.readLineSync(encoding: utf8);
//     switch (input?.trim().toLowerCase()) {
//       case null:
//         continue;
//       case 'exit':
//         exit(0);
//       default:
//         final msg = await responder.getMessages(input!);
//         print(msg);
//     }
//   } while (true);
// }

// /// this [Responder] will create an instance of the [_communicator] using the [Isolate.spawn]
// /// and will hold that [Isolate] alive in itself
// class Responder {
//   final ReceivePort rp;
//   final Stream<dynamic> broadcastRp;
//   final SendPort communicatorSendPort;

//   Responder({
//     required this.rp,
//     required this.broadcastRp,
//     required this.communicatorSendPort,
//   });

//   /// [static create method] --------------------------
//   /// Dart [constructor] always synchronous. there is no [asynchronous constructor]
//   /// in order to create an [asyn constructor] create a [static async] function
//   static Future<Responder> create() async {
//     // the goal of this function is to spawn an isolate and than save that informaiton within this Responder object

//     final rp = ReceivePort();
//     Isolate.spawn(_communicator, rp.sendPort);
//     final broadcastRp = rp.asBroadcastStream();
//     final SendPort communicatorSendPort = await broadcastRp.first;

//     return Responder(
//         rp: rp,
//         broadcastRp: broadcastRp,
//         communicatorSendPort: communicatorSendPort);
//   }

//   Future<String> getMessages(String message) async {
//     communicatorSendPort.send(message);

//     return broadcastRp
//         .takeWhile((element) => element is String)
//         .cast<String>()
//         .take(1)
//         .first;
//   }
// }

// /// [_communicator] ---------------------------------------
// void _communicator(SendPort sp) async {
//   final rp = ReceivePort();
//   sp.send(rp.sendPort);

//   final messages = rp.takeWhile((element) => element is String).cast<String>();

//   await for (var message in messages) {
//     for (var entry in messagesAndResponces.entries) {
//       if (entry.key.trim().toLowerCase() == message.trim().toLowerCase()) {
//         sp.send(entry.value);
//         continue;
//       }
//     }
//     sp.send('I have no response to this!');
//   }
// }

// const messagesAndResponces = <String, String>{
//   '': 'ask me a question, like "how are you?"',
//   'Hello': 'HI',
//   'How are you?': 'Fine',
//   'What are you doing': 'Learning about Isolates in Dart',
//   'are you having fun': 'Yeah, for sure!',
//   'I love you ': 'Merry me, than'
// };

//! ---- ------- ----------- Exmample_4 (Downloading and Parsing Json with Isolate)---- ------- -----------//
/// We are going to create an isolate that will grab the content (json data) from this url( http://jsonplaceholder.typicode.com/todos/ )
/// our isolate will parse the contents of tihs json (from "http://jsonplaceholder.typicode.com/todos/")

// void main(List<String> args) async {
//   final rp = ReceivePort();
//   Isolate.spawn(_parseJsonIsolateEntry, rp.sendPort);

//   final todos = rp
//       .takeWhile((element) => element is Iterable<ToDO>)
//       .cast<Iterable<ToDO>>()
//       .take(1);

//   List<ToDO> listTodo = [];
//   await for (var todo in todos) {
//     listTodo = todo.toList();
//   }
//   print(listTodo);
// }

// void _parseJsonIsolateEntry(SendPort sp) async {
//   final cliient = HttpClient();
//   final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/');

//   final toDos = await cliient
//       .getUrl(url)
//       .then((req) => req.close())
//       .then((response) => response.transform(utf8.decoder).join())
//       .then((value) => jsonDecode(value) as List<dynamic>)
//       .then((json) => json.map((map) => ToDO.fromJson(json: map)));

//   sp.send(toDos);
// }

// class ToDO {
//   final int userId;
//   final int id;
//   final String title;
//   final bool completed;

//   ToDO(
//       {required this.userId,
//       required this.id,
//       required this.title,
//       required this.completed});

//   ToDO.fromJson({required Map<String, dynamic> json})
//       : userId = json['userId'],
//         id = json['id'] as int,
//         title = json['title'],
//         completed = json['completed'];

//   @override
//   String toString() {
//     return '''  UsetId : $userId,
//         id : $id,
//         title : $title,
//         completed : $completed

//     ''';
//   }
// }





