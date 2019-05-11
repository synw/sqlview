import 'package:flutter/material.dart';

/// A builder for actions : update or delete
typedef void ItemActionBuilder(BuildContext context, Map<String, dynamic> item);

/// A widget builder
typedef Widget ItemWidgetBuilder(
    BuildContext context, Map<String, dynamic> item);

/// A strings builder
typedef String ItemStringBuilder(
    BuildContext context, Map<String, dynamic> item);
