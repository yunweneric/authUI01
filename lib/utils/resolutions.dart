import 'package:flutter/material.dart';

double kWidth(context) => MediaQuery.of(context).size.width;
double kHeight(context) => MediaQuery.of(context).size.height;
SizedBox kSpacer(context) => SizedBox(height: kHeight(context) / 3);
