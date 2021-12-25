enum PictureStyle {
  full,
  small,
  regular,
  thumb,
  blur,
  itemprop,
  thumbSmall,
  mediumLarge,
  avatarSmall,
  avatarRegular,
}

Map<PictureStyle, String> pictureStyleData = {
  PictureStyle.full: '@!full',
  PictureStyle.small: '@!small',
  PictureStyle.regular: '@!regular',
  PictureStyle.thumb: '@!thumbnail',
  PictureStyle.blur: '@!thumbnailBlur',
  PictureStyle.itemprop: '@!itemprop',
  PictureStyle.thumbSmall: '@!thumbnailSmall',
  PictureStyle.avatarSmall: '@!avatarSmall',
  PictureStyle.avatarRegular: '@!avatarRegular',
  PictureStyle.mediumLarge: '@!medium_large'
};

String getPictureUrl({
  required String key,
  PictureStyle? style = PictureStyle.regular,
}) {
  final String styleName = pictureStyleData[style ?? PictureStyle.regular]!;
  if (RegExp(r'default.svg$').hasMatch(key)) {
    return key;
  }
  if (RegExp(r'^\/\/cdn').hasMatch(key)) {
    return '$key${styleName}_webp';
  }
  if (RegExp(r'^blob:').hasMatch(key)) {
    return key;
  }
  if (RegExp(r'\/\/').hasMatch(key)) {
    return key;
  }
  if (RegExp(r'^photo\/').hasMatch(key)) {
    return 'https://cdn-oss.soapphoto.com/$key${styleName}_webp';
  }
  return 'https://cdn-oss.soapphoto.com/photo/$key${styleName}_webp';
}
