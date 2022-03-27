// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'data/app_setting.dart';
import 'data/course.dart';
import 'data/db_order.dart';
import 'data/login_information.dart';
import 'data/notification/notification.dart';
import 'data/todo/todo.dart';
import 'data/user_data.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 3284734248980943431),
      name: 'Todo',
      lastPropertyId: const IdUid(12, 9034691011289567091),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5937245691610532397),
            name: 'dbId',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 7180789667227499195),
            name: 'index',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 88563245766398739),
            name: 'id',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6915353404330730178),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7086502057598590637),
            name: 'courseId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3950634135583286619),
            name: 'dueDate',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7243918767836596024),
            name: 'availability',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7364091361633818541),
            name: 'iconUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 4437214406351049793),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 7203101575986117035),
            name: 'statusIndex',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 7790827462074813127),
            name: 'userDefined',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 9034691011289567091),
            name: 'checked',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 4420181251981158404),
      name: 'Notification',
      lastPropertyId: const IdUid(7, 8605540700619887406),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5782222212685242326),
            name: 'dbId',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 6359859855093440055),
            name: 'url',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7170557344293606843),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4668613904382870533),
            name: 'body',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 6861565402815390903),
            name: 'time',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4011268913774024298),
            name: 'type',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 7419517741216255617),
      name: 'LoginInformation',
      lastPropertyId: const IdUid(9, 8022903993677831274),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 634094398182009305),
            name: 'dbId',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 3578730515291647593),
            name: 'loginStatus',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1205553556073291920),
            name: 'sessionKey',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7846494685238956114),
            name: 'moodleSessionKey',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7324954176180697997),
            name: 'loginMsg',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4484816848956330079),
            name: 'studentId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4926548132399196020),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 8485526282138067975),
            name: 'department',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 8022903993677831274),
            name: 'imgUrl',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 5304213255211063717),
      name: 'UserData',
      lastPropertyId: const IdUid(9, 6354478781775989372),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7946840175745358240),
            name: 'dbId',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 7333475653602065520),
            name: 'username',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1369289785613228728),
            name: 'password',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7457526091426554720),
            name: 'lastNotiSyncTime',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 6354478781775989372),
            name: 'lastTodoSyncTime',
            type: 10,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 1760169772214913091),
      name: 'DBOrder',
      lastPropertyId: const IdUid(2, 8580495941994490358),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 214376942078346924),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8580495941994490358),
            name: 'idList',
            type: 30,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(7, 7986024428822729645),
      name: 'Course',
      lastPropertyId: const IdUid(4, 3934253625317376529),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 167486112161231587),
            name: 'dbId',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 7107934111124358014),
            name: 'id',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4641037228727225763),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3934253625317376529),
            name: 'sub',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(8, 3903414118031854863),
      name: 'AppSetting',
      lastPropertyId: const IdUid(4, 6447168916149222508),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4259758747337110548),
            name: 'dbId',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8318608979497059794),
            name: 'isFirst',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(8, 3903414118031854863),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [4816851749500283845],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        5044159418328435229,
        8910649686947288288,
        1440128632270886262,
        4338693111533517871,
        8600077381834846601,
        2531200934916819732,
        7212746729534182033,
        8605540700619887406,
        82835774111024215,
        6435263826418195440,
        3716490607939816256,
        1457919830521390142,
        6447168916149222508
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Todo: EntityDefinition<Todo>(
        model: _entities[0],
        toOneRelations: (Todo object) => [],
        toManyRelations: (Todo object) => {},
        getId: (Todo object) => object.dbId,
        setId: (Todo object, int id) {
          object.dbId = id;
        },
        objectToFB: (Todo object, fb.Builder fbb) {
          final idOffset = fbb.writeString(object.id);
          final titleOffset = fbb.writeString(object.title);
          final courseIdOffset = fbb.writeString(object.courseId);
          final iconUrlOffset = fbb.writeString(object.iconUrl);
          final typeOffset = fbb.writeString(object.type);
          fbb.startTable(13);
          fbb.addInt64(0, object.dbId);
          fbb.addInt64(1, object.index);
          fbb.addOffset(2, idOffset);
          fbb.addOffset(3, titleOffset);
          fbb.addOffset(4, courseIdOffset);
          fbb.addInt64(5, object.dueDate?.millisecondsSinceEpoch);
          fbb.addBool(6, object.availability);
          fbb.addOffset(7, iconUrlOffset);
          fbb.addOffset(8, typeOffset);
          fbb.addInt64(9, object.statusIndex);
          fbb.addBool(10, object.userDefined);
          fbb.addBool(11, object.checked);
          fbb.finish(fbb.endTable());
          return object.dbId;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dueDateValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 14);
          final object = Todo(
              index: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              id: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              title: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 10, ''),
              courseId: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 12, ''),
              dueDate: dueDateValue == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(dueDateValue),
              availability: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 16, false),
              iconUrl: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 18, ''),
              type: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 20, ''),
              statusIndex:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0),
              userDefined: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 24, false),
              checked: const fb.BoolReader().vTableGet(buffer, rootOffset, 26, false))
            ..dbId = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    Notification: EntityDefinition<Notification>(
        model: _entities[1],
        toOneRelations: (Notification object) => [],
        toManyRelations: (Notification object) => {},
        getId: (Notification object) => object.dbId,
        setId: (Notification object, int id) {
          object.dbId = id;
        },
        objectToFB: (Notification object, fb.Builder fbb) {
          final urlOffset = fbb.writeString(object.url);
          final titleOffset = fbb.writeString(object.title);
          final bodyOffset = fbb.writeString(object.body);
          final typeOffset = fbb.writeString(object.type);
          fbb.startTable(8);
          fbb.addInt64(0, object.dbId);
          fbb.addOffset(1, urlOffset);
          fbb.addOffset(2, titleOffset);
          fbb.addOffset(3, bodyOffset);
          fbb.addInt64(4, object.time.millisecondsSinceEpoch);
          fbb.addOffset(5, typeOffset);
          fbb.finish(fbb.endTable());
          return object.dbId;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Notification(
              title: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              body: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 10, ''),
              url: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              time: DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0)),
              type: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 14, ''))
            ..dbId = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    LoginInformation: EntityDefinition<LoginInformation>(
        model: _entities[2],
        toOneRelations: (LoginInformation object) => [],
        toManyRelations: (LoginInformation object) => {},
        getId: (LoginInformation object) => object.dbId,
        setId: (LoginInformation object, int id) {
          object.dbId = id;
        },
        objectToFB: (LoginInformation object, fb.Builder fbb) {
          final sessionKeyOffset = fbb.writeString(object.sessionKey);
          final moodleSessionKeyOffset =
              fbb.writeString(object.moodleSessionKey);
          final loginMsgOffset = fbb.writeString(object.loginMsg);
          final studentIdOffset = fbb.writeString(object.studentId);
          final nameOffset = fbb.writeString(object.name);
          final departmentOffset = fbb.writeString(object.department);
          final imgUrlOffset = fbb.writeString(object.imgUrl);
          fbb.startTable(10);
          fbb.addInt64(0, object.dbId);
          fbb.addBool(1, object.loginStatus);
          fbb.addOffset(2, sessionKeyOffset);
          fbb.addOffset(3, moodleSessionKeyOffset);
          fbb.addOffset(4, loginMsgOffset);
          fbb.addOffset(5, studentIdOffset);
          fbb.addOffset(6, nameOffset);
          fbb.addOffset(7, departmentOffset);
          fbb.addOffset(8, imgUrlOffset);
          fbb.finish(fbb.endTable());
          return object.dbId;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = LoginInformation(
              loginStatus:
                  const fb.BoolReader().vTableGet(buffer, rootOffset, 6, false),
              sessionKey: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              moodleSessionKey: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 10, ''),
              loginMsg: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 12, ''),
              studentId: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 14, ''),
              name: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 16, ''),
              department: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 18, ''),
              imgUrl: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 20, ''))
            ..dbId = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    UserData: EntityDefinition<UserData>(
        model: _entities[3],
        toOneRelations: (UserData object) => [],
        toManyRelations: (UserData object) => {},
        getId: (UserData object) => object.dbId,
        setId: (UserData object, int id) {
          object.dbId = id;
        },
        objectToFB: (UserData object, fb.Builder fbb) {
          final usernameOffset = fbb.writeString(object.username);
          final passwordOffset = fbb.writeString(object.password);
          fbb.startTable(10);
          fbb.addInt64(0, object.dbId);
          fbb.addOffset(1, usernameOffset);
          fbb.addOffset(2, passwordOffset);
          fbb.addInt64(7, object.lastNotiSyncTime.millisecondsSinceEpoch);
          fbb.addInt64(8, object.lastTodoSyncTime.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.dbId;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = UserData()
            ..dbId = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..username = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '')
            ..password = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 8, '')
            ..lastNotiSyncTime = DateTime.fromMillisecondsSinceEpoch(
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0))
            ..lastTodoSyncTime = DateTime.fromMillisecondsSinceEpoch(
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0));

          return object;
        }),
    DBOrder: EntityDefinition<DBOrder>(
        model: _entities[4],
        toOneRelations: (DBOrder object) => [],
        toManyRelations: (DBOrder object) => {},
        getId: (DBOrder object) => object.id,
        setId: (DBOrder object, int id) {
          object.id = id;
        },
        objectToFB: (DBOrder object, fb.Builder fbb) {
          final idListOffset = fbb.writeList(
              object.idList.map(fbb.writeString).toList(growable: false));
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, idListOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = DBOrder(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              idList: const fb.ListReader<String>(
                      fb.StringReader(asciiOptimization: true),
                      lazy: false)
                  .vTableGet(buffer, rootOffset, 6, []));

          return object;
        }),
    Course: EntityDefinition<Course>(
        model: _entities[5],
        toOneRelations: (Course object) => [],
        toManyRelations: (Course object) => {},
        getId: (Course object) => object.dbId,
        setId: (Course object, int id) {
          object.dbId = id;
        },
        objectToFB: (Course object, fb.Builder fbb) {
          final idOffset = fbb.writeString(object.id);
          final titleOffset = fbb.writeString(object.title);
          final subOffset = fbb.writeString(object.sub);
          fbb.startTable(5);
          fbb.addInt64(0, object.dbId);
          fbb.addOffset(1, idOffset);
          fbb.addOffset(2, titleOffset);
          fbb.addOffset(3, subOffset);
          fbb.finish(fbb.endTable());
          return object.dbId;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Course(
              title: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              sub: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 10, ''),
              id: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''))
            ..dbId = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    AppSetting: EntityDefinition<AppSetting>(
        model: _entities[6],
        toOneRelations: (AppSetting object) => [],
        toManyRelations: (AppSetting object) => {},
        getId: (AppSetting object) => object.dbId,
        setId: (AppSetting object, int id) {
          object.dbId = id;
        },
        objectToFB: (AppSetting object, fb.Builder fbb) {
          fbb.startTable(5);
          fbb.addInt64(0, object.dbId);
          fbb.addBool(1, object.isFirst);
          fbb.finish(fbb.endTable());
          return object.dbId;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = AppSetting()
            ..dbId = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..isFirst =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 6, false);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Todo] entity fields to define ObjectBox queries.
class Todo_ {
  /// see [Todo.dbId]
  static final dbId = QueryIntegerProperty<Todo>(_entities[0].properties[0]);

  /// see [Todo.index]
  static final index = QueryIntegerProperty<Todo>(_entities[0].properties[1]);

  /// see [Todo.id]
  static final id = QueryStringProperty<Todo>(_entities[0].properties[2]);

  /// see [Todo.title]
  static final title = QueryStringProperty<Todo>(_entities[0].properties[3]);

  /// see [Todo.courseId]
  static final courseId = QueryStringProperty<Todo>(_entities[0].properties[4]);

  /// see [Todo.dueDate]
  static final dueDate = QueryIntegerProperty<Todo>(_entities[0].properties[5]);

  /// see [Todo.availability]
  static final availability =
      QueryBooleanProperty<Todo>(_entities[0].properties[6]);

  /// see [Todo.iconUrl]
  static final iconUrl = QueryStringProperty<Todo>(_entities[0].properties[7]);

  /// see [Todo.type]
  static final type = QueryStringProperty<Todo>(_entities[0].properties[8]);

  /// see [Todo.statusIndex]
  static final statusIndex =
      QueryIntegerProperty<Todo>(_entities[0].properties[9]);

  /// see [Todo.userDefined]
  static final userDefined =
      QueryBooleanProperty<Todo>(_entities[0].properties[10]);

  /// see [Todo.checked]
  static final checked =
      QueryBooleanProperty<Todo>(_entities[0].properties[11]);
}

/// [Notification] entity fields to define ObjectBox queries.
class Notification_ {
  /// see [Notification.dbId]
  static final dbId =
      QueryIntegerProperty<Notification>(_entities[1].properties[0]);

  /// see [Notification.url]
  static final url =
      QueryStringProperty<Notification>(_entities[1].properties[1]);

  /// see [Notification.title]
  static final title =
      QueryStringProperty<Notification>(_entities[1].properties[2]);

  /// see [Notification.body]
  static final body =
      QueryStringProperty<Notification>(_entities[1].properties[3]);

  /// see [Notification.time]
  static final time =
      QueryIntegerProperty<Notification>(_entities[1].properties[4]);

  /// see [Notification.type]
  static final type =
      QueryStringProperty<Notification>(_entities[1].properties[5]);
}

/// [LoginInformation] entity fields to define ObjectBox queries.
class LoginInformation_ {
  /// see [LoginInformation.dbId]
  static final dbId =
      QueryIntegerProperty<LoginInformation>(_entities[2].properties[0]);

  /// see [LoginInformation.loginStatus]
  static final loginStatus =
      QueryBooleanProperty<LoginInformation>(_entities[2].properties[1]);

  /// see [LoginInformation.sessionKey]
  static final sessionKey =
      QueryStringProperty<LoginInformation>(_entities[2].properties[2]);

  /// see [LoginInformation.moodleSessionKey]
  static final moodleSessionKey =
      QueryStringProperty<LoginInformation>(_entities[2].properties[3]);

  /// see [LoginInformation.loginMsg]
  static final loginMsg =
      QueryStringProperty<LoginInformation>(_entities[2].properties[4]);

  /// see [LoginInformation.studentId]
  static final studentId =
      QueryStringProperty<LoginInformation>(_entities[2].properties[5]);

  /// see [LoginInformation.name]
  static final name =
      QueryStringProperty<LoginInformation>(_entities[2].properties[6]);

  /// see [LoginInformation.department]
  static final department =
      QueryStringProperty<LoginInformation>(_entities[2].properties[7]);

  /// see [LoginInformation.imgUrl]
  static final imgUrl =
      QueryStringProperty<LoginInformation>(_entities[2].properties[8]);
}

/// [UserData] entity fields to define ObjectBox queries.
class UserData_ {
  /// see [UserData.dbId]
  static final dbId =
      QueryIntegerProperty<UserData>(_entities[3].properties[0]);

  /// see [UserData.username]
  static final username =
      QueryStringProperty<UserData>(_entities[3].properties[1]);

  /// see [UserData.password]
  static final password =
      QueryStringProperty<UserData>(_entities[3].properties[2]);

  /// see [UserData.lastNotiSyncTime]
  static final lastNotiSyncTime =
      QueryIntegerProperty<UserData>(_entities[3].properties[3]);

  /// see [UserData.lastTodoSyncTime]
  static final lastTodoSyncTime =
      QueryIntegerProperty<UserData>(_entities[3].properties[4]);
}

/// [DBOrder] entity fields to define ObjectBox queries.
class DBOrder_ {
  /// see [DBOrder.id]
  static final id = QueryIntegerProperty<DBOrder>(_entities[4].properties[0]);

  /// see [DBOrder.idList]
  static final idList =
      QueryStringVectorProperty<DBOrder>(_entities[4].properties[1]);
}

/// [Course] entity fields to define ObjectBox queries.
class Course_ {
  /// see [Course.dbId]
  static final dbId = QueryIntegerProperty<Course>(_entities[5].properties[0]);

  /// see [Course.id]
  static final id = QueryStringProperty<Course>(_entities[5].properties[1]);

  /// see [Course.title]
  static final title = QueryStringProperty<Course>(_entities[5].properties[2]);

  /// see [Course.sub]
  static final sub = QueryStringProperty<Course>(_entities[5].properties[3]);
}

/// [AppSetting] entity fields to define ObjectBox queries.
class AppSetting_ {
  /// see [AppSetting.dbId]
  static final dbId =
      QueryIntegerProperty<AppSetting>(_entities[6].properties[0]);

  /// see [AppSetting.isFirst]
  static final isFirst =
      QueryBooleanProperty<AppSetting>(_entities[6].properties[1]);
}
