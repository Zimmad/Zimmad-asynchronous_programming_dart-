import 'dart:isolate';

/// creatin an isolate function that will produce some messages

void main(List<String> args) async {
  await for (var msg in getMessages().take(10)) {
    print(msg);
  }
}

/// Creating an instance of the ports. This is going to be the entry of our isolates
/// in this function we have the posibility to do our work. like producing some stream
Stream<String> getMessages() async* {
  /// The [RevievePort] has a [sendPort] ie {rp.sendPort}
  final rp = ReceivePort();

  /// so we get a copy of the [sendPort] and send it to [_getMesages()]

  /// Isolate.spawn((message) { }, message)--the first parameter is the actual function that is the isolate, the second parameter
  /// is our [sendPort]
  ///  final foo = Isolate.spawn(_getMessages, sp.sendPort); // the [return] of this is [Future<Isolate>]
  ///final foo = Isolate.spawn(_getMessages, sp.sendPort).asStream(); // this is now [Stream<Isolate>]
  /// ```
  ///  final foo = Isolate.spawn(_getMessages, rp.sendPort)  // foo is a [Stream<dynamic>] in our case it is a [Stream<String>]
  ///  .asStream()
  /// .asyncExpand((isolate) => rp);
  /// ```

  final foo = Isolate.spawn(_getMessages, rp.sendPort)
      .asStream()
      .asyncExpand((isolate) => rp)
      .takeWhile((element) => element is String)
      .cast<String>();
  yield* foo;
}

///  This function is same as [above] function
///```
/// Stream<String> getMessages() async* {
///   final rp = ReceivePort();
/// return Isolate.spawn(_getMessages, rp.sendPort)
///       .asStream()
///       .asyncExpand((isolate) => rp)
///       .takeWhile((element) => element is String)
///       .cast<String>();
/// }
/// ```

void _getMessages(SendPort sp) async {
  await for (final now in Stream.periodic(
      const Duration(
        milliseconds: 500,
      ), (_) {
    return DateTime.now().toIso8601String();
  })) {
    /// we have [now] as a [String]. we want to send to we want to send it back to
    /// whoever creates an instance of us, the way to do so is to use [sendport.send()]
    /// we are producing strings and sending it back to whoever creates an instance of us

    sp.send(now);
  }
}
