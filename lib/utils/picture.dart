
enum PictureStyle {
  full,
  raw,
  small,
  regular,
  thumb,
  blur,
  itemprop,
}

Map<PictureStyle, String> pictureStyleData = {
  PictureStyle.full: '-pictureFull',
  PictureStyle.raw: '',
  PictureStyle.small: '-pictureSmall',
  PictureStyle.regular: '-pictureRegular',
  PictureStyle.thumb: '-pictureThumb',
  PictureStyle.blur: '-pictureThumbBlur',
  PictureStyle.itemprop: '-itemprop',
};

String getPictureUrl({String key, PictureStyle style: PictureStyle.blur}) {
  String styleName = pictureStyleData[style];
  if (RegExp(r'default.svg$').hasMatch(key)) {
    return key;
  }
  if (RegExp(r'^\/\/cdn').hasMatch(key)) {
    return '$key$styleName';
  }
  if (RegExp(r'^blob:').hasMatch(key)) {
    return key;
  }
  if (RegExp(r'\/\/').hasMatch(key)) {
    return key;
  }
  return 'https://cdn.soapphoto.com/$key$styleName';
}
