class GooglePlacesModel {
  String? description;
  List<MatchedSubstring>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Term>? terms;
  List<String>? types;

  GooglePlacesModel({this.description, this.matchedSubstrings, this.placeId, this.reference, this.structuredFormatting, this.terms, this.types});

  factory GooglePlacesModel.fromJson(Map<String, dynamic> json) {
    return GooglePlacesModel(
      description: json['description'],
      matchedSubstrings: json['matched_substrings'] != null ? (json['matched_substrings'] as List).map((i) => MatchedSubstring.fromJson(i)).toList() : null,
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting: json['structured_formatting'] != null ? StructuredFormatting.fromJson(json['structured_formatting']) : null,
      terms: json['terms'] != null ? (json['terms'] as List).map((i) => Term.fromJson(i)).toList() : null,
      types: json['types'] != null ? new List<String>.from(json['types']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = description;
    data['place_id'] = placeId;
    data['reference'] = reference;
    if (matchedSubstrings != null) {
      data['matched_substrings'] = matchedSubstrings!.map((v) => v.toJson()).toList();
    }
    if (structuredFormatting != null) {
      data['structured_formatting'] = structuredFormatting!.toJson();
    }
    if (terms != null) {
      data['terms'] = terms!.map((v) => v.toJson()).toList();
    }
    if (types != null) {
      data['types'] = types;
    }
    return data;
  }
}

class Term {
  int? offset;
  String? value;

  Term({this.offset, this.value});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      offset: json['offset'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = offset;
    data['value'] = value;
    return data;
  }
}

class MatchedSubstring {
  int? length;
  int? offset;

  MatchedSubstring({this.length, this.offset});

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(
      length: json['length'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = length;
    data['offset'] = offset;
    return data;
  }
}

class StructuredFormatting {
  String? mainText;
  List<MainTextMatchedSubstring>? mainTextMatchedSubstrings;
  String? secondaryText;

  StructuredFormatting({this.mainText, this.mainTextMatchedSubstrings, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'],
      mainTextMatchedSubstrings: json['main_text_matched_substrings'] != null ? (json['main_text_matched_substrings'] as List).map((i) => MainTextMatchedSubstring.fromJson(i)).toList() : null,
      secondaryText: json['secondary_text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_text'] = mainText;
    data['secondary_text'] = secondaryText;
    if (mainTextMatchedSubstrings != null) {
      data['main_text_matched_substrings'] = mainTextMatchedSubstrings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainTextMatchedSubstring {
  int? length;
  int? offset;

  MainTextMatchedSubstring({this.length, this.offset});

  factory MainTextMatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MainTextMatchedSubstring(
      length: json['length'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = length;
    data['offset'] = offset;
    return data;
  }
}
