// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetUserDataCollection on Isar {
  IsarCollection<UserData> get userDatas {
    return getCollection('UserData');
  }
}

final UserDataSchema = CollectionSchema(
  name: 'UserData',
  schema:
      '{"name":"UserData","idName":"isarId","properties":[{"name":"isFirst","type":"Bool"},{"name":"lastSyncTime","type":"Long"},{"name":"password","type":"String"},{"name":"username","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _UserDataNativeAdapter(),
  webAdapter: const _UserDataWebAdapter(),
  idName: 'isarId',
  propertyIds: {'isFirst': 0, 'lastSyncTime': 1, 'password': 2, 'username': 3},
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

class _UserDataWebAdapter extends IsarWebTypeAdapter<UserData> {
  const _UserDataWebAdapter();

  @override
  Object serialize(IsarCollection<UserData> collection, UserData object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'isFirst', object.isFirst);
    IsarNative.jsObjectSet(jsObj, 'isarId', object.isarId);
    IsarNative.jsObjectSet(jsObj, 'lastSyncTime',
        object.lastSyncTime.toUtc().millisecondsSinceEpoch);
    IsarNative.jsObjectSet(jsObj, 'password', object.password);
    IsarNative.jsObjectSet(jsObj, 'username', object.username);
    return jsObj;
  }

  @override
  UserData deserialize(IsarCollection<UserData> collection, dynamic jsObj) {
    final object = UserData();
    object.isFirst = IsarNative.jsObjectGet(jsObj, 'isFirst') ?? false;
    object.lastSyncTime = IsarNative.jsObjectGet(jsObj, 'lastSyncTime') != null
        ? DateTime.fromMillisecondsSinceEpoch(
                IsarNative.jsObjectGet(jsObj, 'lastSyncTime'),
                isUtc: true)
            .toLocal()
        : DateTime.fromMillisecondsSinceEpoch(0);
    object.password = IsarNative.jsObjectGet(jsObj, 'password') ?? '';
    object.username = IsarNative.jsObjectGet(jsObj, 'username') ?? '';
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'isFirst':
        return (IsarNative.jsObjectGet(jsObj, 'isFirst') ?? false) as P;
      case 'isarId':
        return (IsarNative.jsObjectGet(jsObj, 'isarId') ??
            double.negativeInfinity) as P;
      case 'lastSyncTime':
        return (IsarNative.jsObjectGet(jsObj, 'lastSyncTime') != null
            ? DateTime.fromMillisecondsSinceEpoch(
                    IsarNative.jsObjectGet(jsObj, 'lastSyncTime'),
                    isUtc: true)
                .toLocal()
            : DateTime.fromMillisecondsSinceEpoch(0)) as P;
      case 'password':
        return (IsarNative.jsObjectGet(jsObj, 'password') ?? '') as P;
      case 'username':
        return (IsarNative.jsObjectGet(jsObj, 'username') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, UserData object) {}
}

class _UserDataNativeAdapter extends IsarNativeTypeAdapter<UserData> {
  const _UserDataNativeAdapter();

  @override
  void serialize(IsarCollection<UserData> collection, IsarRawObject rawObj,
      UserData object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.isFirst;
    final _isFirst = value0;
    final value1 = object.lastSyncTime;
    final _lastSyncTime = value1;
    final value2 = object.password;
    final _password = IsarBinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += (_password.length) as int;
    final value3 = object.username;
    final _username = IsarBinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += (_username.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBool(offsets[0], _isFirst);
    writer.writeDateTime(offsets[1], _lastSyncTime);
    writer.writeBytes(offsets[2], _password);
    writer.writeBytes(offsets[3], _username);
  }

  @override
  UserData deserialize(IsarCollection<UserData> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = UserData();
    object.isFirst = reader.readBool(offsets[0]);
    object.lastSyncTime = reader.readDateTime(offsets[1]);
    object.password = reader.readString(offsets[2]);
    object.username = reader.readString(offsets[3]);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readBool(offset)) as P;
      case 1:
        return (reader.readDateTime(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, UserData object) {}
}

extension UserDataQueryWhereSort on QueryBuilder<UserData, UserData, QWhere> {
  QueryBuilder<UserData, UserData, QAfterWhere> anyIsarId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension UserDataQueryWhere on QueryBuilder<UserData, UserData, QWhereClause> {
  QueryBuilder<UserData, UserData, QAfterWhereClause> isarIdEqualTo(
      int isarId) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: true,
      upper: [isarId],
      includeUpper: true,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterWhereClause> isarIdNotEqualTo(
      int isarId) {
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

  QueryBuilder<UserData, UserData, QAfterWhereClause> isarIdGreaterThan(
    int isarId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: include,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterWhereClause> isarIdLessThan(
    int isarId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [isarId],
      includeUpper: include,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterWhereClause> isarIdBetween(
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

extension UserDataQueryFilter
    on QueryBuilder<UserData, UserData, QFilterCondition> {
  QueryBuilder<UserData, UserData, QAfterFilterCondition> isFirstEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isFirst',
      value: value,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> isarIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<UserData, UserData, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<UserData, UserData, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<UserData, UserData, QAfterFilterCondition> lastSyncTimeEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastSyncTime',
      value: value,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition>
      lastSyncTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastSyncTime',
      value: value,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> lastSyncTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastSyncTime',
      value: value,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> lastSyncTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastSyncTime',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> passwordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'password',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> passwordGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'password',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> passwordLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'password',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> passwordBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'password',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> passwordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'password',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> passwordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'password',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> passwordContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'password',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> passwordMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'password',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> usernameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'username',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> usernameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'username',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> usernameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'username',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> usernameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'username',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> usernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'username',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> usernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'username',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> usernameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'username',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserData, UserData, QAfterFilterCondition> usernameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'username',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension UserDataQueryLinks
    on QueryBuilder<UserData, UserData, QFilterCondition> {}

extension UserDataQueryWhereSortBy
    on QueryBuilder<UserData, UserData, QSortBy> {
  QueryBuilder<UserData, UserData, QAfterSortBy> sortByIsFirst() {
    return addSortByInternal('isFirst', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> sortByIsFirstDesc() {
    return addSortByInternal('isFirst', Sort.desc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> sortByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> sortByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> sortByLastSyncTime() {
    return addSortByInternal('lastSyncTime', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> sortByLastSyncTimeDesc() {
    return addSortByInternal('lastSyncTime', Sort.desc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> sortByPassword() {
    return addSortByInternal('password', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> sortByPasswordDesc() {
    return addSortByInternal('password', Sort.desc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> sortByUsername() {
    return addSortByInternal('username', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> sortByUsernameDesc() {
    return addSortByInternal('username', Sort.desc);
  }
}

extension UserDataQueryWhereSortThenBy
    on QueryBuilder<UserData, UserData, QSortThenBy> {
  QueryBuilder<UserData, UserData, QAfterSortBy> thenByIsFirst() {
    return addSortByInternal('isFirst', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> thenByIsFirstDesc() {
    return addSortByInternal('isFirst', Sort.desc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> thenByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> thenByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> thenByLastSyncTime() {
    return addSortByInternal('lastSyncTime', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> thenByLastSyncTimeDesc() {
    return addSortByInternal('lastSyncTime', Sort.desc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> thenByPassword() {
    return addSortByInternal('password', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> thenByPasswordDesc() {
    return addSortByInternal('password', Sort.desc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> thenByUsername() {
    return addSortByInternal('username', Sort.asc);
  }

  QueryBuilder<UserData, UserData, QAfterSortBy> thenByUsernameDesc() {
    return addSortByInternal('username', Sort.desc);
  }
}

extension UserDataQueryWhereDistinct
    on QueryBuilder<UserData, UserData, QDistinct> {
  QueryBuilder<UserData, UserData, QDistinct> distinctByIsFirst() {
    return addDistinctByInternal('isFirst');
  }

  QueryBuilder<UserData, UserData, QDistinct> distinctByIsarId() {
    return addDistinctByInternal('isarId');
  }

  QueryBuilder<UserData, UserData, QDistinct> distinctByLastSyncTime() {
    return addDistinctByInternal('lastSyncTime');
  }

  QueryBuilder<UserData, UserData, QDistinct> distinctByPassword(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('password', caseSensitive: caseSensitive);
  }

  QueryBuilder<UserData, UserData, QDistinct> distinctByUsername(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('username', caseSensitive: caseSensitive);
  }
}

extension UserDataQueryProperty
    on QueryBuilder<UserData, UserData, QQueryProperty> {
  QueryBuilder<UserData, bool, QQueryOperations> isFirstProperty() {
    return addPropertyNameInternal('isFirst');
  }

  QueryBuilder<UserData, int, QQueryOperations> isarIdProperty() {
    return addPropertyNameInternal('isarId');
  }

  QueryBuilder<UserData, DateTime, QQueryOperations> lastSyncTimeProperty() {
    return addPropertyNameInternal('lastSyncTime');
  }

  QueryBuilder<UserData, String, QQueryOperations> passwordProperty() {
    return addPropertyNameInternal('password');
  }

  QueryBuilder<UserData, String, QQueryOperations> usernameProperty() {
    return addPropertyNameInternal('username');
  }
}
