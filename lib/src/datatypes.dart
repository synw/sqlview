import 'package:flutter/material.dart';

/// A builder for actions : update or delete
typedef ItemActionBuilder = void Function(
    BuildContext context, Map<String, dynamic> item);

/// A widget builder
typedef ItemWidgetBuilder = Widget Function(
    BuildContext context, Map<String, dynamic> item);

/// A strings builder
typedef ItemStringBuilder = String Function(
    BuildContext context, Map<String, dynamic> item);
