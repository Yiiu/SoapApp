// ignore: avoid_classes_with_only_static_members

import 'package:jiffy/jiffy.dart';

final Map<String, String> constellation = {
  'capricorn': '摩羯座',
  'aquarius': '水瓶座',
  'pisces': '双鱼座',
  'aries': '白羊座',
  'taurus': '金牛座',
  'gemini': '双子座',
  'cancer': '巨蟹座',
  'leo': '狮子座',
  'virgo': '处女座',
  'libra': '天秤座',
  'scorpio': '天蝎座',
  'sagittarius': '射手座',
};

final Map<String, String> constellationEng = {
  '摩羯座': 'capricorn',
  '水瓶座': 'aquarius',
  '双鱼座': 'pisces',
  '白羊座': 'aries',
  '金牛座': 'taurus',
  '双子座': 'gemini',
  '巨蟹座': 'cancer',
  '狮子座': 'leo',
  '处女座': 'virgo',
  '天秤座': 'libra',
  '天蝎座': 'scorpio',
  '射手座': 'sagittarius',
};

String getConstellation(String birthday) {
  const String capricorn = '摩羯座'; //Capricorn 摩羯座（12月22日～1月20日）
  const String aquarius = '水瓶座'; //Aquarius 水瓶座（1月21日～2月19日）
  const String pisces = '双鱼座'; //Pisces 双鱼座（2月20日～3月20日）
  const String aries = '白羊座'; //3月21日～4月20日
  const String taurus = '金牛座'; //4月21～5月21日
  const String gemini = '双子座'; //5月22日～6月21日
  const String cancer = '巨蟹座'; //Cancer 巨蟹座（6月22日～7月22日）
  const String leo = '狮子座'; //Leo 狮子座（7月23日～8月23日）
  const String virgo = '处女座'; //Virgo 处女座（8月24日～9月23日）
  const String libra = '天秤座'; //Libra 天秤座（9月24日～10月23日）
  const String scorpio = '天蝎座'; //Scorpio 天蝎座（10月24日～11月22日）
  const String sagittarius = '射手座'; //Sagittarius 射手座（11月23日～12月21日）

  final int month = Jiffy.parse(birthday).month;
  final int day = Jiffy.parse(birthday).daysInMonth;
  String constellation = '';

  switch (month) {
    case DateTime.january:
      constellation = day < 21 ? capricorn : aquarius;
      break;
    case DateTime.february:
      constellation = day < 20 ? aquarius : pisces;
      break;
    case DateTime.march:
      constellation = day < 21 ? pisces : aries;
      break;
    case DateTime.april:
      constellation = day < 21 ? aries : taurus;
      break;
    case DateTime.may:
      constellation = day < 22 ? taurus : gemini;
      break;
    case DateTime.june:
      constellation = day < 22 ? gemini : cancer;
      break;
    case DateTime.july:
      constellation = day < 23 ? cancer : leo;
      break;
    case DateTime.august:
      constellation = day < 24 ? leo : virgo;
      break;
    case DateTime.september:
      constellation = day < 24 ? virgo : libra;
      break;
    case DateTime.october:
      constellation = day < 24 ? libra : scorpio;
      break;
    case DateTime.november:
      constellation = day < 23 ? scorpio : sagittarius;
      break;
    case DateTime.december:
      constellation = day < 22 ? sagittarius : capricorn;
      break;
  }

  return constellation;
}
