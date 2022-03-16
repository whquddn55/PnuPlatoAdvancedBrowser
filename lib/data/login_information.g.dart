// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_information.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetLoginInformationCollection on Isar {
  IsarCollection<LoginInformation> get loginInformations {
    return getCollection('LoginInformation');
  }
}

final LoginInformationSchema = CollectionSchema(
  name: 'LoginInformation',
  schema:
      '{"name":"LoginInformation","idName":"isarId","properties":[{"name":"department","type":"String"},{"name":"imgUrl","type":"String"},{"name":"loginMsg","type":"String"},{"name":"loginStatus","type":"Bool"},{"name":"moodleSessionKey","type":"String"},{"name":"name","type":"String"},{"name":"sessionKey","type":"String"},{"name":"studentId","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _LoginInformationNativeAdapter(),
  webAdapter: const _LoginInformationWebAdapter(),
  idName: 'isarId',
  propertyIds: {
    'department': 0,
    'imgUrl': 1,
    'loginMsg': 2,
    'loginStatus': 3,
    'moodleSessionKey': 4,
    'name': 5,
    'sessionKey': 6,
    'studentId': 7
  },
  listProperties: {},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.isarId == Isar.autoIncrement) {
      return null;
    } else {
      return obj.isarId;
    }
  },
  setId: null,
  getLinks: (obj) => [],
  version: 2,
);

class _LoginInformationWebAdapter extends IsarWebTypeAdapter<LoginInformation> {
  const _LoginInformationWebAdapter();

  @override
  Object serialize(
      IsarCollection<LoginInformation> collection, LoginInformation object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'department', object.department);
    IsarNative.jsObjectSet(jsObj, 'imgUrl', object.imgUrl);
    IsarNative.jsObjectSet(jsObj, 'isarId', object.isarId);
    IsarNative.jsObjectSet(jsObj, 'loginMsg', object.loginMsg);
    IsarNative.jsObjectSet(jsObj, 'loginStatus', object.loginStatus);
    IsarNative.jsObjectSet(jsObj, 'moodleSessionKey', object.moodleSessionKey);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    IsarNative.jsObjectSet(jsObj, 'sessionKey', object.sessionKey);
    IsarNative.jsObjectSet(jsObj, 'studentId', object.studentId);
    return jsObj;
  }

  @override
  LoginInformation deserialize(
      IsarCollection<LoginInformation> collection, dynamic jsObj) {
    final object = LoginInformation(
      department: IsarNative.jsObjectGet(jsObj, 'department') ?? '',
      imgUrl: IsarNative.jsObjectGet(jsObj, 'imgUrl') ?? '',
      loginMsg: IsarNative.jsObjectGet(jsObj, 'loginMsg') ?? '',
      loginStatus: IsarNative.jsObjectGet(jsObj, 'loginStatus') ?? false,
      moodleSessionKey: IsarNative.jsObjectGet(jsObj, 'moodleSessionKey') ?? '',
      name: IsarNative.jsObjectGet(jsObj, 'name') ?? '',
      sessionKey: IsarNative.jsObjectGet(jsObj, 'sessionKey') ?? '',
      studentId: IsarNative.jsObjectGet(jsObj, 'studentId') ?? '',
    );
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'department':
        return (IsarNative.jsObjectGet(jsObj, 'department') ?? '') as P;
      case 'imgUrl':
        return (IsarNative.jsObjectGet(jsObj, 'imgUrl') ?? '') as P;
      case 'isarId':
        return (IsarNative.jsObjectGet(jsObj, 'isarId') ??
            double.negativeInfinity) as P;
      case 'loginMsg':
        return (IsarNative.jsObjectGet(jsObj, 'loginMsg') ?? '') as P;
      case 'loginStatus':
        return (IsarNative.jsObjectGet(jsObj, 'loginStatus') ?? false) as P;
      case 'moodleSessionKey':
        return (IsarNative.jsObjectGet(jsObj, 'moodleSessionKey') ?? '') as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
      case 'sessionKey':
        return (IsarNative.jsObjectGet(jsObj, 'sessionKey') ?? '') as P;
      case 'studentId':
        return (IsarNative.jsObjectGet(jsObj, 'studentId') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, LoginInformation object) {}
}

class _LoginInformationNativeAdapter
    extends IsarNativeTypeAdapter<LoginInformation> {
  const _LoginInformationNativeAdapter();

  @override
  void serialize(
      IsarCollection<LoginInformation> collection,
      IsarRawObject rawObj,
      LoginInformation object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.department;
    final _department = IsarBinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += (_department.length) as int;
    final value1 = object.imgUrl;
    final _imgUrl = IsarBinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += (_imgUrl.length) as int;
    final value2 = object.loginMsg;
    final _loginMsg = IsarBinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += (_loginMsg.length) as int;
    final value3 = object.loginStatus;
    final _loginStatus = value3;
    final value4 = object.moodleSessionKey;
    final _moodleSessionKey = IsarBinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += (_moodleSessionKey.length) as int;
    final value5 = object.name;
    final _name = IsarBinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += (_name.length) as int;
    final value6 = object.sessionKey;
    final _sessionKey = IsarBinaryWriter.utf8Encoder.convert(value6);
    dynamicSize += (_sessionKey.length) as int;
    final value7 = object.studentId;
    final _studentId = IsarBinaryWriter.utf8Encoder.convert(value7);
    dynamicSize += (_studentId.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _department);
    writer.writeBytes(offsets[1], _imgUrl);
    writer.writeBytes(offsets[2], _loginMsg);
    writer.writeBool(offsets[3], _loginStatus);
    writer.writeBytes(offsets[4], _moodleSessionKey);
    writer.writeBytes(offsets[5], _name);
    writer.writeBytes(offsets[6], _sessionKey);
    writer.writeBytes(offsets[7], _studentId);
  }

  @override
  LoginInformation deserialize(IsarCollection<LoginInformation> collection,
      int id, IsarBinaryReader reader, List<int> offsets) {
    final object = LoginInformation(
      department: reader.readString(offsets[0]),
      imgUrl: reader.readString(offsets[1]),
      loginMsg: reader.readString(offsets[2]),
      loginStatus: reader.readBool(offsets[3]),
      moodleSessionKey: reader.readString(offsets[4]),
      name: reader.readString(offsets[5]),
      sessionKey: reader.readString(offsets[6]),
      studentId: reader.readString(offsets[7]),
    );
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readBool(offset)) as P;
      case 4:
        return (reader.readString(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      case 6:
        return (reader.readString(offset)) as P;
      case 7:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, LoginInformation object) {}
}

extension LoginInformationQueryWhereSort
    on QueryBuilder<LoginInformation, LoginInformation, QWhere> {
  QueryBuilder<LoginInformation, LoginInformation, QAfterWhere> anyIsarId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension LoginInformationQueryWhere
    on QueryBuilder<LoginInformation, LoginInformation, QWhereClause> {
  QueryBuilder<LoginInformation, LoginInformation, QAfterWhereClause>
      isarIdEqualTo(int isarId) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: true,
      upper: [isarId],
      includeUpper: true,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterWhereClause>
      isarIdNotEqualTo(int isarId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [isarId],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [isarId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [isarId],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [isarId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterWhereClause>
      isarIdGreaterThan(
    int isarId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: include,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterWhereClause>
      isarIdLessThan(
    int isarId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [isarId],
      includeUpper: include,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterWhereClause>
      isarIdBetween(
    int lowerIsarId,
    int upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerIsarId],
      includeLower: includeLower,
      upper: [upperIsarId],
      includeUpper: includeUpper,
    ));
  }
}

extension LoginInformationQueryFilter
    on QueryBuilder<LoginInformation, LoginInformation, QFilterCondition> {
  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      departmentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'department',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      departmentGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'department',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      departmentLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'department',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      departmentBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'department',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      departmentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'department',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      departmentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'department',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      departmentContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'department',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      departmentMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'department',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      imgUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'imgUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      imgUrlGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'imgUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      imgUrlLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'imgUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      imgUrlBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'imgUrl',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      imgUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'imgUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      imgUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'imgUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      imgUrlContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'imgUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      imgUrlMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'imgUrl',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      isarIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      isarIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      isarIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      isarIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'isarId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      loginMsgEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'loginMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      loginMsgGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'loginMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      loginMsgLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'loginMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      loginMsgBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'loginMsg',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      loginMsgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'loginMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      loginMsgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'loginMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      loginMsgContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'loginMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      loginMsgMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'loginMsg',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      loginStatusEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'loginStatus',
      value: value,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      moodleSessionKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'moodleSessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      moodleSessionKeyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'moodleSessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      moodleSessionKeyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'moodleSessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      moodleSessionKeyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'moodleSessionKey',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      moodleSessionKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'moodleSessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      moodleSessionKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'moodleSessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      moodleSessionKeyContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'moodleSessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      moodleSessionKeyMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'moodleSessionKey',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      sessionKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'sessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      sessionKeyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'sessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      sessionKeyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'sessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      sessionKeyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'sessionKey',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      sessionKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'sessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      sessionKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'sessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      sessionKeyContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'sessionKey',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      sessionKeyMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'sessionKey',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      studentIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'studentId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      studentIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'studentId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      studentIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'studentId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      studentIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'studentId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      studentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'studentId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      studentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'studentId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      studentIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'studentId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterFilterCondition>
      studentIdMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'studentId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension LoginInformationQueryLinks
    on QueryBuilder<LoginInformation, LoginInformation, QFilterCondition> {}

extension LoginInformationQueryWhereSortBy
    on QueryBuilder<LoginInformation, LoginInformation, QSortBy> {
  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByDepartment() {
    return addSortByInternal('department', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByDepartmentDesc() {
    return addSortByInternal('department', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByImgUrl() {
    return addSortByInternal('imgUrl', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByImgUrlDesc() {
    return addSortByInternal('imgUrl', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByLoginMsg() {
    return addSortByInternal('loginMsg', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByLoginMsgDesc() {
    return addSortByInternal('loginMsg', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByLoginStatus() {
    return addSortByInternal('loginStatus', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByLoginStatusDesc() {
    return addSortByInternal('loginStatus', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByMoodleSessionKey() {
    return addSortByInternal('moodleSessionKey', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByMoodleSessionKeyDesc() {
    return addSortByInternal('moodleSessionKey', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortBySessionKey() {
    return addSortByInternal('sessionKey', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortBySessionKeyDesc() {
    return addSortByInternal('sessionKey', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByStudentId() {
    return addSortByInternal('studentId', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      sortByStudentIdDesc() {
    return addSortByInternal('studentId', Sort.desc);
  }
}

extension LoginInformationQueryWhereSortThenBy
    on QueryBuilder<LoginInformation, LoginInformation, QSortThenBy> {
  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByDepartment() {
    return addSortByInternal('department', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByDepartmentDesc() {
    return addSortByInternal('department', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByImgUrl() {
    return addSortByInternal('imgUrl', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByImgUrlDesc() {
    return addSortByInternal('imgUrl', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByLoginMsg() {
    return addSortByInternal('loginMsg', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByLoginMsgDesc() {
    return addSortByInternal('loginMsg', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByLoginStatus() {
    return addSortByInternal('loginStatus', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByLoginStatusDesc() {
    return addSortByInternal('loginStatus', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByMoodleSessionKey() {
    return addSortByInternal('moodleSessionKey', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByMoodleSessionKeyDesc() {
    return addSortByInternal('moodleSessionKey', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenBySessionKey() {
    return addSortByInternal('sessionKey', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenBySessionKeyDesc() {
    return addSortByInternal('sessionKey', Sort.desc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByStudentId() {
    return addSortByInternal('studentId', Sort.asc);
  }

  QueryBuilder<LoginInformation, LoginInformation, QAfterSortBy>
      thenByStudentIdDesc() {
    return addSortByInternal('studentId', Sort.desc);
  }
}

extension LoginInformationQueryWhereDistinct
    on QueryBuilder<LoginInformation, LoginInformation, QDistinct> {
  QueryBuilder<LoginInformation, LoginInformation, QDistinct>
      distinctByDepartment({bool caseSensitive = true}) {
    return addDistinctByInternal('department', caseSensitive: caseSensitive);
  }

  QueryBuilder<LoginInformation, LoginInformation, QDistinct> distinctByImgUrl(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('imgUrl', caseSensitive: caseSensitive);
  }

  QueryBuilder<LoginInformation, LoginInformation, QDistinct>
      distinctByIsarId() {
    return addDistinctByInternal('isarId');
  }

  QueryBuilder<LoginInformation, LoginInformation, QDistinct>
      distinctByLoginMsg({bool caseSensitive = true}) {
    return addDistinctByInternal('loginMsg', caseSensitive: caseSensitive);
  }

  QueryBuilder<LoginInformation, LoginInformation, QDistinct>
      distinctByLoginStatus() {
    return addDistinctByInternal('loginStatus');
  }

  QueryBuilder<LoginInformation, LoginInformation, QDistinct>
      distinctByMoodleSessionKey({bool caseSensitive = true}) {
    return addDistinctByInternal('moodleSessionKey',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<LoginInformation, LoginInformation, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<LoginInformation, LoginInformation, QDistinct>
      distinctBySessionKey({bool caseSensitive = true}) {
    return addDistinctByInternal('sessionKey', caseSensitive: caseSensitive);
  }

  QueryBuilder<LoginInformation, LoginInformation, QDistinct>
      distinctByStudentId({bool caseSensitive = true}) {
    return addDistinctByInternal('studentId', caseSensitive: caseSensitive);
  }
}

extension LoginInformationQueryProperty
    on QueryBuilder<LoginInformation, LoginInformation, QQueryProperty> {
  QueryBuilder<LoginInformation, String, QQueryOperations>
      departmentProperty() {
    return addPropertyNameInternal('department');
  }

  QueryBuilder<LoginInformation, String, QQueryOperations> imgUrlProperty() {
    return addPropertyNameInternal('imgUrl');
  }

  QueryBuilder<LoginInformation, int, QQueryOperations> isarIdProperty() {
    return addPropertyNameInternal('isarId');
  }

  QueryBuilder<LoginInformation, String, QQueryOperations> loginMsgProperty() {
    return addPropertyNameInternal('loginMsg');
  }

  QueryBuilder<LoginInformation, bool, QQueryOperations> loginStatusProperty() {
    return addPropertyNameInternal('loginStatus');
  }

  QueryBuilder<LoginInformation, String, QQueryOperations>
      moodleSessionKeyProperty() {
    return addPropertyNameInternal('moodleSessionKey');
  }

  QueryBuilder<LoginInformation, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<LoginInformation, String, QQueryOperations>
      sessionKeyProperty() {
    return addPropertyNameInternal('sessionKey');
  }

  QueryBuilder<LoginInformation, String, QQueryOperations> studentIdProperty() {
    return addPropertyNameInternal('studentId');
  }
}
