import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SelectTileConfig<T> {
  SelectTileConfig({
    required this.title,
    required this.value,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final T value;
}

class SoapSelectList<T> extends StatelessWidget {
  const SoapSelectList({
    Key? key,
    required this.value,
    required this.onChange,
    required this.config,
  }) : super(key: key);

  final T value;
  final void Function(T) onChange;
  final List<SelectTileConfig<T>> config;

  Widget _tileWidget(SelectTileConfig<T> config, BuildContext context) {
    final bool selected = value == config.value;
    return ListTile(
      title: Text(
        config.title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () {
        onChange(config.value);
      },
      subtitle: config.subtitle != null
          ? Text(
              config.subtitle!,
              style: const TextStyle(
                fontSize: 12,
              ),
            )
          : null,
      trailing: selected
          ? Icon(
              FeatherIcons.check,
              color: Theme.of(context).primaryColor,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: config.length,
            itemBuilder: (BuildContext context, int index) {
              return _tileWidget(config[index], context);
            },
          ),
        ),
      ),
    );
  }
}
