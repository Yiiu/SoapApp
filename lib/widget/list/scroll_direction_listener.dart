// 数据共享
import 'package:flutter/material.dart';

typedef OnScrollDirectionChanged = void Function(VerticalDirection direction);

class ScrollDirection extends InheritedWidget {
  const ScrollDirection({
    required this.direction,
    required Widget child,
  }) : super(child: child);

  final VerticalDirection? direction;

  bool get up => direction == VerticalDirection.up;

  bool get down => direction == VerticalDirection.down;

  static ScrollDirection? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScrollDirection>();
  }

  @override
  bool updateShouldNotify(ScrollDirection oldWidget) {
    return oldWidget.direction != direction;
  }
}

class ScrollDirectionListener extends StatefulWidget {
  const ScrollDirectionListener({
    required this.child,
    this.onScrollDirectionChanged,
    this.depth,
  });

  final Widget child;

  /// The callback that is invoked whenever the scroll direction changes.
  final OnScrollDirectionChanged? onScrollDirectionChanged;

  /// The depth of the scroll notification this listener should listen for.
  ///
  /// Useful when multiple scroll views are built below the listener (e.g.
  /// when using a [NestedScrollView]).
  ///
  /// When `null` listens to every scroll notification regardless of depth.
  final int? depth;

  @override
  _ScrollDirectionListenerState createState() =>
      _ScrollDirectionListenerState();
}

class _ScrollDirectionListenerState extends State<ScrollDirectionListener>
    with RouteAware {
  double _lastPosition = 0;
  VerticalDirection? _direction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didPushNext() {
    if (mounted) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          // Assume scrolling up when a new route gets pushed onto the screen.
          // This is a workaround for the ListCardAnimation to prevent a
          // repeating animation when the next route gets popped and the list
          // cards become visible again.
          _direction = VerticalDirection.up;
        });
      });
    }
  }

  void _changeDirection(VerticalDirection direction) {
    if (mounted && _direction != direction) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          _direction = direction;
        });

        widget.onScrollDirectionChanged?.call(direction);
      });
    }
  }

  bool _onNotification(ScrollNotification notification) {
    if (widget.depth != null && notification.depth != widget.depth) {
      return false;
    }

    final scrollPosition = notification.metrics.pixels;
    if (scrollPosition <= 100) {
      _changeDirection(VerticalDirection.up);
    } else if (_lastPosition < scrollPosition) {
      // scrolling down
      _changeDirection(VerticalDirection.down);
    } else if (_lastPosition > scrollPosition) {
      // scrolling up
      _changeDirection(VerticalDirection.up);
    }

    _lastPosition = scrollPosition;

    return false;
  }

  void _reset() {
    if (mounted) {
      setState(() {
        _direction = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: widget.child,
    );
  }
}
