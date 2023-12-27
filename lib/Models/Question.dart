// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Question questionFromJson(String str) => Question.fromJson(json.decode(str));

String questionToJson(Question data) => json.encode(data.toJson());

class Question {
  String title;
  String name;
  String slug;
  String description;
  QuestionJsonSchema schema;

  Question({
    required this.title,
    required this.name,
    required this.slug,
    required this.description,
    required this.schema,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    title: json["title"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    schema: QuestionJsonSchema.fromJson(json["schema"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "name": name,
    "slug": slug,
    "description": description,
    "schema": schema.toJson(),
  };
}

class QuestionJsonSchema {
  List<QuestionField> fields;

  QuestionJsonSchema({
    required this.fields,
  });

  factory QuestionJsonSchema.fromJson(Map<String, dynamic> json) => QuestionJsonSchema(
    fields: List<QuestionField>.from(json["fields"].map((x) => QuestionField.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "fields": List<dynamic>.from(fields.map((x) => x.toJson())),
  };
}

class QuestionField {
  String type;
  int version;
  QuestionFieldSchema schema;

  QuestionField({
    required this.type,
    required this.version,
    required this.schema,
  });

  factory QuestionField.fromJson(Map<String, dynamic> json) => QuestionField(
    type: json["type"],
    version: json["version"],
    schema: QuestionFieldSchema.fromJson(json["schema"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "version": version,
    "schema": schema.toJson(),
  };
}

class QuestionFieldSchema {
  String name;
  String label;
  dynamic hidden;
  bool? readonly;
  List<Option>? options;
  List<FluffyField>? fields;

  QuestionFieldSchema({
    required this.name,
    required this.label,
    this.hidden,
    this.readonly,
    this.options,
    this.fields,
  });

  factory QuestionFieldSchema.fromJson(Map<String, dynamic> json) => QuestionFieldSchema(
    name: json["name"],
    label: json["label"],
    hidden: json["hidden"],
    readonly: json["readonly"],
    options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
    fields: json["fields"] == null ? [] : List<FluffyField>.from(json["fields"]!.map((x) => FluffyField.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "label": label,
    "hidden": hidden,
    "readonly": readonly,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
    "fields": fields == null ? [] : List<dynamic>.from(fields!.map((x) => x.toJson())),
  };
}

class FluffyField {
  String type;
  int version;
  FluffySchema schema;

  FluffyField({
    required this.type,
    required this.version,
    required this.schema,
  });

  factory FluffyField.fromJson(Map<String, dynamic> json) => FluffyField(
    type: json["type"],
    version: json["version"],
    schema: FluffySchema.fromJson(json["schema"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "version": version,
    "schema": schema.toJson(),
  };
}

class FluffySchema {
  String name;
  String label;
  bool? hidden;
  bool? readonly;
  List<Option>? options;

  FluffySchema({
    required this.name,
    required this.label,
    this.hidden,
    this.readonly,
    this.options,
  });

  factory FluffySchema.fromJson(Map<String, dynamic> json) => FluffySchema(
    name: json["name"],
    label: json["label"],
    hidden: json["hidden"],
    readonly: json["readonly"],
    options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "label": label,
    "hidden": hidden,
    "readonly": readonly,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}

class Option {
  String key;
  String value;

  Option({
    required this.key,
    required this.value,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}
