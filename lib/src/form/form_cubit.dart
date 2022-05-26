import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:duffer/duffer.dart';
import 'package:flutter/foundation.dart';

SerializerRegistry formSerializers = SerializerRegistry();

class FormCubit extends Cubit<FormData> {

  FormCubit() : super(const FormData(values: {}));

  String get jsonData => state.jsonData;

  void setValue(String key, dynamic value) {
    var values = Map.of(state.values);
    values[key] = value;
    emit(FormData(values: values));
  }

}


@immutable
class FormData {

  final Map<String, dynamic> values;

  String get jsonData {
    var copiedData = Map<String, dynamic>.from(values);
    _preSerialize(copiedData);
    return jsonEncode(copiedData);
  }

  ByteBuf get binaryData {
    var copiedData = Map<String, dynamic>.from(values);
    _preSerialize(copiedData);
    return pickles.dump(copiedData);
  }

  dynamic operator [](String key) => values[key];

  //<editor-fold desc="Data Methods">
  const FormData({
    this.values = const {},
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is FormData &&
              runtimeType == other.runtimeType &&
              values == other.values);

  @override
  int get hashCode => values.hashCode;

  @override
  String toString() {
    return 'FormData{' + ' values: $values,' + '}';
  }

  FormData copyWith({
    Map<String, dynamic>? values,
  }) {
    return FormData(
      values: values ?? this.values,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'values': values,
    };
  }

  factory FormData.fromMap(Map<String, dynamic> map) {
    return FormData(
      values: map['values'] as Map<String, dynamic>,
    );
  }

//</editor-fold>
}

mixin Serializer<T> {

  Map<String, dynamic> serialize(T value);
  T deserialize(Map<String, dynamic> data);

}

Map<String, dynamic> _preSerialize(Map<String, dynamic> map) {
  for (var entry in map.entries) {
    var t = entry.value.runtimeType;
    if (t == String || t == int || t == double || t == bool) {
      // Ignore primitives
    } else if (entry.value is List) {
      var list = entry.value as List;
      if (list.isNotEmpty) {
        var peek = list.first;
        var pt = peek.runtimeType;
        if (pt == String || pt == int || pt == double || pt == bool) {
          // Ignore primitives
        } else if (formSerializers.hasSerializer(peek)) {
          map[entry.key] = list.map((e) => formSerializers.serialize(e)).toList();
        } else {
          if (kDebugMode) print("Using fallback toString() serializer for '${entry.key}'($t)");
          map[entry.key] = list.map((e) => e.toString()).toList();
        }
      }
    } else if (entry.value is Map<String, dynamic>) {
      _preSerialize(entry.value);
    } else if (formSerializers.hasSerializer(entry.value)) {
      map[entry.key] = formSerializers.serialize(entry.value);
    } else {
      map[entry.key] = entry.value.toString();
    }
  }
  return map;
}

class SerializerRegistry {

  Map<Type, Serializer> serializers = {};

  bool hasSerializer(dynamic value) => serializers[value.runtimeType] != null;

  void register(Serializer serializer, Type type) {
    serializers[type] = serializer;
  }

  dynamic deserialize(Map<String, dynamic> data, Type type) => serializers[type]!.deserialize(data);
  Map<String, dynamic> serialize(dynamic value) => serializers[value.runtimeType]!.serialize(value);

}

class InlineSerializer<T> with Serializer<T> {

  T Function(Map<String, dynamic>) deserializeFunc;
  Map<String, dynamic> Function(T) serializeFunc;

  @override
  T deserialize(Map<String, dynamic> data) => deserializeFunc(data);

  @override
  Map<String, dynamic> serialize(T value) => serializeFunc(value);

  InlineSerializer({
    required this.deserializeFunc,
    required this.serializeFunc,
  });
}