// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

import '../state_management/errors/base_exception.dart';
import '../state_management/errors/default_exception.dart';
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
abstract class _CommandStream<Out extends Object> extends ChangeNotifier {
  StreamSubscription<Result<Out, BaseException>>? _subscription;

  bool _loading = false;
  bool get loading => _loading;

  Result<Out, BaseException>? _result;
  Result<Out, BaseException>? get result => _result;

  void _execute(CommandActionStream0<Out> streamGetter) {
    _loading = true;
    _result = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = streamGetter().listen(
      (newResult) {
        _result = newResult;
        _loading = false;
        notifyListeners();
      },
      onError: (error) {
        final exception = error is BaseException
            ? error
            : DefaultException(
                message: error.toString(),
              );
        _result = Failure(exception);
        _loading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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

final class CommandStream0<Out extends Object> extends _CommandStream<Out> {
  final CommandActionStream0<Out> _actionStream;

  CommandStream0(this._actionStream);

  /// Executes the action.
  Future<void> execute() async {
    _execute(() => _actionStream());
  }
}

/// A [Command] that accepts no arguments.
final class CommandStream1<Out extends Object, In> extends _CommandStream<Out> {
  final CommandActionStream1<Out, In> _actionStream;

  CommandStream1(this._actionStream);

  /// Executes the action.
  Future<void> execute(In argument) async {
    _execute(() => _actionStream(argument));
  }
}
