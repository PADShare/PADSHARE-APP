import 'package:flutter/cupertino.dart';
import 'package:padshare/Source/models/data/data.dart';

class DummyData{
  static int interval = 5;

  static List<Data> barData = [
    // Data(id: 0, name: 'Mon', y: 15, color: Color(0xff19bfff)),
    // Data(id: 1, name: 'Tue', y: -12, color: Color(0xffff4d94)),
    // Data(id: 2, name: 'Wen', y: 11, color: Color(0xff2bdb94)),
    // Data(id: 3, name: 'Thur', y: 13, color: Color(0xfff5df66)),
    // Data(id: 4, name: 'Fri', y: 10, color: Color(0xff789fdd))
    Data(
      id: 0,
      name: 'Mon',
      y: 15,
      color: Color(0xff19bfff),
    ),
    Data(
      name: 'Tue',
      id: 1,
      y: 12,
      color: Color(0xffff4d94),
    ),
    Data(
      name: 'Wed',
      id: 2,
      y: 11,
      color: Color(0xff2bdb90),
    ),
    Data(
      name: 'Thu',
      id: 3,
      y: 10,
      color: Color(0xffffdd80),
    ),
    Data(
      name: 'Fri',
      id: 4,
      y: 6,
      color: Color(0xff2bdb90),
    ),
    Data(
      name: 'Sat',
      id: 5,
      y: 17,
      color: Color(0xffffdd80),
    ),
    Data(
      name: 'Sun',
      id: 6,
      y: 5,
      color: Color(0xffff4d94),
    ),
  ];
}