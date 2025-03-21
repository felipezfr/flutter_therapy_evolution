import 'package:flutter/material.dart';

import 'widgets/empty_indicator_widget.dart';
import 'command.dart';
import 'widgets/error_indicator_widget.dart';

class CommandStreamListenableBuilder<Out> extends StatelessWidget {
  final CommandStream stream;
  final Widget Function(BuildContext context, Out value) builder;

  //Empty state message
  final String? emptyMessage;
  final String? emptyHowRegisterMessage;
  final IconData? emptyIconData;
  final bool showEmptyState;

  //Error state message
  final String? errorMessage;
  final void Function()? refresh;

  const CommandStreamListenableBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.emptyMessage,
    this.errorMessage,
    this.emptyHowRegisterMessage,
    this.emptyIconData,
    this.refresh,
    this.showEmptyState = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: stream,
      builder: (context, child) {
        if (stream.running) {
          return const Center(child: CircularProgressIndicator());
        }

        final streamResult = stream.result;

        if (streamResult == null) {
          return EmptyIndicatorWidget(
            emptyMessage: emptyMessage,
            iconData: emptyIconData,
            howRegisterMessage: emptyHowRegisterMessage,
          );
        }

        return streamResult.fold(
          (result) {
            if (result is List && result.isEmpty && showEmptyState) {
              return EmptyIndicatorWidget(
                emptyMessage: emptyMessage,
                iconData: emptyIconData,
                howRegisterMessage: emptyHowRegisterMessage,
              );
            }

            return builder(context, result as Out);
          },
          (error) {
            return ErrorIndicatorWidget(
              message: errorMessage ?? error.message,
              refresh: refresh,
            );
          },
        );
      },
    );
  }
}
