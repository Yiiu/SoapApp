import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadMoreListener extends StatefulWidget {
  const LoadMoreListener({
    required this.child,
    this.listen = true,
    this.onLoadMore,
  });

  final Widget child;
  final bool listen;
  final AsyncCallback? onLoadMore;

  @override
  _LoadMoreListenerState createState() => _LoadMoreListenerState();
}

class _LoadMoreListenerState extends State<LoadMoreListener> {
  bool _loading = false;

  double _lastPosition = 0;
  VerticalDirection? _direction;

  Future<void> _loadMore() async {
    if (_loading) {
      return;
    }

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    await widget.onLoadMore!();

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _changeDirection(VerticalDirection direction) {
    if (mounted && _direction != direction) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          _direction = direction;
        });
      });
    }
  }

  bool _onNotification(ScrollNotification notification) {
    final scrollPosition = notification.metrics.pixels;

    if (_lastPosition < scrollPosition) {
      _changeDirection(VerticalDirection.down);
    } else if (_lastPosition > scrollPosition) {
      _changeDirection(VerticalDirection.up);
    }
    if (notification.metrics.extentAfter <= 200 &&
        _direction == VerticalDirection.up) {
      _loadMore();
    }
    _lastPosition = scrollPosition;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: !widget.listen || _loading ? null : _onNotification,
      child: widget.child,
    );
  }
}

// 数据共享
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
