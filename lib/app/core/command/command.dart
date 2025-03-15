// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_therapy_evolution/app/core/log/log_manager.dart';
import 'package:result_dart/result_dart.dart';

import '../errors/base_exception.dart';
import '../errors/default_exception.dart';
import '../typedefs/result_typedef.dart';

/// Defines a command action that returns a [Result] of type [T].
/// Used by [Command0] for actions without arguments.
typedef CommandAction0<T extends Object> = Output<T> Function();

/// Defines a command action that returns a [Result] of type [T].
/// Takes an argument of type [A].
/// Used by [Command1] for actions with one argument.
typedef CommandAction1<T extends Object, A> = Output<T> Function(A);

typedef CommandActionStream0<T extends Object>
    = Stream<Result<T, BaseException>> Function();
typedef CommandActionStream1<T extends Object, A>
    = Stream<Result<T, BaseException>> Function(A);

/// Facilitates interaction with a view model.
///
/// Encapsulates an action,
/// exposes its running and error states,
/// and ensures that it can't be launched again until it finishes.
///
/// Use [Command0] for actions without arguments.
/// Use [Command1] for actions with one argument.
///
/// Actions must return a [Result] of type [Out].
///
/// Consume the action result by listening to changes,
/// then call to [clearResult] when the state is consumed.
abstract class Command<Out extends Object> extends ChangeNotifier {
  bool _running = false;

  /// Whether the action is running.
  bool get running => _running;

  Result<Out, BaseException>? _result;

  /// Whether the action completed with an error.
  bool get error => _result is Failure;

  /// Whether the action completed successfully.
  bool get success => _result is Success;

  /// The result of the most recent action.
  ///
  /// Returns `null` if the action is running or completed with an error.
  Result<Out, BaseException>? get result => _result;

  /// Clears the most recent action's result.
  void clearResult() {
    _result = null;
    notifyListeners();
  }

  /// Execute the provided [action], notifying listeners and
  /// setting the running and result states as necessary.
  Future<void> _execute(CommandAction0<Out> action) async {
    // Ensure the action can't launch multiple times.
    // e.g. avoid multiple taps on button
    if (_running) return;

    // Notify listeners.
    // e.g. button shows loading state
    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// A [Command] command for handling streams
abstract class CommandStream<Out extends Object> extends ChangeNotifier {
  StreamSubscription<Result<Out, BaseException>>? _subscription;

  bool _running = false;
  bool get running => _running;

  /// Whether the action completed with an error.
  bool get error => _result is Failure;

  /// Whether the action completed successfully.
  bool get success => _result is Success;

  Result<Out, BaseException>? _result;
  Result<Out, BaseException>? get result => _result;

  void _execute(CommandActionStream0<Out> streamGetter) {
    _running = true;
    _result = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = streamGetter().listen(
      (newResult) {
        _result = newResult;
        _running = false;
        notifyListeners();
      },
      onError: (error) {
        Log.error('Eror CommandStream $Out', error: error);
        final exception = error is BaseException
            ? error
            : DefaultException(
                message: error.toString(),
              );
        _result = Failure(exception);
        _running = false;
        notifyListeners();
      },
    );
  }

  @override
  // ignore: must_call_super
  void dispose() {
    _subscription?.cancel();
    //When calling super.Discose() it is not possible to perform the stream again
  }
}

/// A [Command] that accepts no arguments.
final class Command0<Out extends Object> extends Command<Out> {
  /// Creates a [Command0] with the provided [CommandAction0].
  Command0(this._action);

  final CommandAction0<Out> _action;

  /// Executes the action.
  Future<void> execute() async {
    await _execute(() => _action());
  }
}

/// A [Command] that accepts one argument.
final class Command1<Out extends Object, In> extends Command<Out> {
  /// Creates a [Command1] with the provided [CommandAction1].
  Command1(this._action);

  final CommandAction1<Out, In> _action;

  /// Executes the action with the specified [argument].
  Future<void> execute(In argument) async {
    await _execute(() => _action(argument));
  }
}

final class CommandStream0<Out extends Object> extends CommandStream<Out> {
  final CommandActionStream0<Out> _actionStream;

  CommandStream0(this._actionStream);

  /// Executes the action.
  Future<void> execute() async {
    _execute(() => _actionStream());
  }
}

/// A [Command] that accepts no arguments.
final class CommandStream1<Out extends Object, In> extends CommandStream<Out> {
  final CommandActionStream1<Out, In> _actionStream;

  CommandStream1(this._actionStream);

  /// Executes the action.
  Future<void> execute(In argument) async {
    _execute(() => _actionStream(argument));
  }
}
