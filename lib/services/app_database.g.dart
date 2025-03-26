// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EntidadTable extends Entidad with TableInfo<$EntidadTable, EntidadData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntidadTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bicMeta = const VerificationMeta('bic');
  @override
  late final GeneratedColumn<String> bic = GeneratedColumn<String>(
      'bic', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _webMeta = const VerificationMeta('web');
  @override
  late final GeneratedColumn<String> web = GeneratedColumn<String>(
      'web', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoMeta = const VerificationMeta('logo');
  @override
  late final GeneratedColumn<String> logo = GeneratedColumn<String>(
      'logo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, bic, web, phone, email, logo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entidad';
  @override
  VerificationContext validateIntegrity(Insertable<EntidadData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bic')) {
      context.handle(
          _bicMeta, bic.isAcceptableOrUnknown(data['bic']!, _bicMeta));
    }
    if (data.containsKey('web')) {
      context.handle(
          _webMeta, web.isAcceptableOrUnknown(data['web']!, _webMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('logo')) {
      context.handle(
          _logoMeta, logo.isAcceptableOrUnknown(data['logo']!, _logoMeta));
    } else if (isInserting) {
      context.missing(_logoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntidadData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntidadData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      bic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bic']),
      web: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}web']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      logo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo'])!,
    );
  }

  @override
  $EntidadTable createAlias(String alias) {
    return $EntidadTable(attachedDatabase, alias);
  }
}

class EntidadData extends DataClass implements Insertable<EntidadData> {
  final int id;
  final String name;
  final String? bic;
  final String? web;
  final String? phone;
  final String? email;
  final String logo;
  const EntidadData(
      {required this.id,
      required this.name,
      this.bic,
      this.web,
      this.phone,
      this.email,
      required this.logo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || bic != null) {
      map['bic'] = Variable<String>(bic);
    }
    if (!nullToAbsent || web != null) {
      map['web'] = Variable<String>(web);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['logo'] = Variable<String>(logo);
    return map;
  }

  EntidadCompanion toCompanion(bool nullToAbsent) {
    return EntidadCompanion(
      id: Value(id),
      name: Value(name),
      bic: bic == null && nullToAbsent ? const Value.absent() : Value(bic),
      web: web == null && nullToAbsent ? const Value.absent() : Value(web),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      logo: Value(logo),
    );
  }

  factory EntidadData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntidadData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bic: serializer.fromJson<String?>(json['bic']),
      web: serializer.fromJson<String?>(json['web']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      logo: serializer.fromJson<String>(json['logo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bic': serializer.toJson<String?>(bic),
      'web': serializer.toJson<String?>(web),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'logo': serializer.toJson<String>(logo),
    };
  }

  EntidadData copyWith(
          {int? id,
          String? name,
          Value<String?> bic = const Value.absent(),
          Value<String?> web = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          String? logo}) =>
      EntidadData(
        id: id ?? this.id,
        name: name ?? this.name,
        bic: bic.present ? bic.value : this.bic,
        web: web.present ? web.value : this.web,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        logo: logo ?? this.logo,
      );
  EntidadData copyWithCompanion(EntidadCompanion data) {
    return EntidadData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bic: data.bic.present ? data.bic.value : this.bic,
      web: data.web.present ? data.web.value : this.web,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      logo: data.logo.present ? data.logo.value : this.logo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntidadData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bic: $bic, ')
          ..write('web: $web, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('logo: $logo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, bic, web, phone, email, logo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntidadData &&
          other.id == this.id &&
          other.name == this.name &&
          other.bic == this.bic &&
          other.web == this.web &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.logo == this.logo);
}

class EntidadCompanion extends UpdateCompanion<EntidadData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> bic;
  final Value<String?> web;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String> logo;
  const EntidadCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bic = const Value.absent(),
    this.web = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.logo = const Value.absent(),
  });
  EntidadCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.bic = const Value.absent(),
    this.web = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    required String logo,
  })  : name = Value(name),
        logo = Value(logo);
  static Insertable<EntidadData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? bic,
    Expression<String>? web,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? logo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bic != null) 'bic': bic,
      if (web != null) 'web': web,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (logo != null) 'logo': logo,
    });
  }

  EntidadCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? bic,
      Value<String?>? web,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String>? logo}) {
    return EntidadCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bic: bic ?? this.bic,
      web: web ?? this.web,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logo: logo ?? this.logo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bic.present) {
      map['bic'] = Variable<String>(bic.value);
    }
    if (web.present) {
      map['web'] = Variable<String>(web.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (logo.present) {
      map['logo'] = Variable<String>(logo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntidadCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bic: $bic, ')
          ..write('web: $web, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('logo: $logo')
          ..write(')'))
        .toString();
  }
}

class $CuentaTable extends Cuenta with TableInfo<$CuentaTable, CuentaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CuentaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ibanMeta = const VerificationMeta('iban');
  @override
  late final GeneratedColumn<String> iban = GeneratedColumn<String>(
      'iban', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taeMeta = const VerificationMeta('tae');
  @override
  late final GeneratedColumn<double> tae = GeneratedColumn<double>(
      'tae', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Titular, String> titular =
      GeneratedColumn<String>('titular', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Titular>($CuentaTable.$convertertitular);
  static const VerificationMeta _entidadMeta =
      const VerificationMeta('entidad');
  @override
  late final GeneratedColumn<String> entidad = GeneratedColumn<String>(
      'entidad', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES entidad (name)'));
  @override
  List<GeneratedColumn> get $columns => [id, name, iban, tae, titular, entidad];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cuenta';
  @override
  VerificationContext validateIntegrity(Insertable<CuentaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('iban')) {
      context.handle(
          _ibanMeta, iban.isAcceptableOrUnknown(data['iban']!, _ibanMeta));
    } else if (isInserting) {
      context.missing(_ibanMeta);
    }
    if (data.containsKey('tae')) {
      context.handle(
          _taeMeta, tae.isAcceptableOrUnknown(data['tae']!, _taeMeta));
    } else if (isInserting) {
      context.missing(_taeMeta);
    }
    if (data.containsKey('entidad')) {
      context.handle(_entidadMeta,
          entidad.isAcceptableOrUnknown(data['entidad']!, _entidadMeta));
    } else if (isInserting) {
      context.missing(_entidadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuentaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CuentaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iban: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}iban'])!,
      tae: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tae'])!,
      titular: $CuentaTable.$convertertitular.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}titular'])!),
      entidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidad'])!,
    );
  }

  @override
  $CuentaTable createAlias(String alias) {
    return $CuentaTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Titular, String, String> $convertertitular =
      const EnumNameConverter<Titular>(Titular.values);
}

class CuentaData extends DataClass implements Insertable<CuentaData> {
  final int id;
  final String name;
  final String iban;
  final double tae;
  final Titular titular;
  final String entidad;
  const CuentaData(
      {required this.id,
      required this.name,
      required this.iban,
      required this.tae,
      required this.titular,
      required this.entidad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['iban'] = Variable<String>(iban);
    map['tae'] = Variable<double>(tae);
    {
      map['titular'] =
          Variable<String>($CuentaTable.$convertertitular.toSql(titular));
    }
    map['entidad'] = Variable<String>(entidad);
    return map;
  }

  CuentaCompanion toCompanion(bool nullToAbsent) {
    return CuentaCompanion(
      id: Value(id),
      name: Value(name),
      iban: Value(iban),
      tae: Value(tae),
      titular: Value(titular),
      entidad: Value(entidad),
    );
  }

  factory CuentaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CuentaData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iban: serializer.fromJson<String>(json['iban']),
      tae: serializer.fromJson<double>(json['tae']),
      titular: $CuentaTable.$convertertitular
          .fromJson(serializer.fromJson<String>(json['titular'])),
      entidad: serializer.fromJson<String>(json['entidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iban': serializer.toJson<String>(iban),
      'tae': serializer.toJson<double>(tae),
      'titular': serializer
          .toJson<String>($CuentaTable.$convertertitular.toJson(titular)),
      'entidad': serializer.toJson<String>(entidad),
    };
  }

  CuentaData copyWith(
          {int? id,
          String? name,
          String? iban,
          double? tae,
          Titular? titular,
          String? entidad}) =>
      CuentaData(
        id: id ?? this.id,
        name: name ?? this.name,
        iban: iban ?? this.iban,
        tae: tae ?? this.tae,
        titular: titular ?? this.titular,
        entidad: entidad ?? this.entidad,
      );
  CuentaData copyWithCompanion(CuentaCompanion data) {
    return CuentaData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iban: data.iban.present ? data.iban.value : this.iban,
      tae: data.tae.present ? data.tae.value : this.tae,
      titular: data.titular.present ? data.titular.value : this.titular,
      entidad: data.entidad.present ? data.entidad.value : this.entidad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CuentaData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iban: $iban, ')
          ..write('tae: $tae, ')
          ..write('titular: $titular, ')
          ..write('entidad: $entidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, iban, tae, titular, entidad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CuentaData &&
          other.id == this.id &&
          other.name == this.name &&
          other.iban == this.iban &&
          other.tae == this.tae &&
          other.titular == this.titular &&
          other.entidad == this.entidad);
}

class CuentaCompanion extends UpdateCompanion<CuentaData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> iban;
  final Value<double> tae;
  final Value<Titular> titular;
  final Value<String> entidad;
  const CuentaCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iban = const Value.absent(),
    this.tae = const Value.absent(),
    this.titular = const Value.absent(),
    this.entidad = const Value.absent(),
  });
  CuentaCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String iban,
    required double tae,
    required Titular titular,
    required String entidad,
  })  : name = Value(name),
        iban = Value(iban),
        tae = Value(tae),
        titular = Value(titular),
        entidad = Value(entidad);
  static Insertable<CuentaData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? iban,
    Expression<double>? tae,
    Expression<String>? titular,
    Expression<String>? entidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iban != null) 'iban': iban,
      if (tae != null) 'tae': tae,
      if (titular != null) 'titular': titular,
      if (entidad != null) 'entidad': entidad,
    });
  }

  CuentaCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? iban,
      Value<double>? tae,
      Value<Titular>? titular,
      Value<String>? entidad}) {
    return CuentaCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iban: iban ?? this.iban,
      tae: tae ?? this.tae,
      titular: titular ?? this.titular,
      entidad: entidad ?? this.entidad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iban.present) {
      map['iban'] = Variable<String>(iban.value);
    }
    if (tae.present) {
      map['tae'] = Variable<double>(tae.value);
    }
    if (titular.present) {
      map['titular'] =
          Variable<String>($CuentaTable.$convertertitular.toSql(titular.value));
    }
    if (entidad.present) {
      map['entidad'] = Variable<String>(entidad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuentaCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iban: $iban, ')
          ..write('tae: $tae, ')
          ..write('titular: $titular, ')
          ..write('entidad: $entidad')
          ..write(')'))
        .toString();
  }
}

class $SaldosCuentaTable extends SaldosCuenta
    with TableInfo<$SaldosCuentaTable, SaldosCuentaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaldosCuentaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cuentaMeta = const VerificationMeta('cuenta');
  @override
  late final GeneratedColumn<int> cuenta = GeneratedColumn<int>(
      'cuenta', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cuenta (id)'));
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _saldoMeta = const VerificationMeta('saldo');
  @override
  late final GeneratedColumn<double> saldo = GeneratedColumn<double>(
      'saldo', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, cuenta, fecha, saldo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saldos_cuenta';
  @override
  VerificationContext validateIntegrity(Insertable<SaldosCuentaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cuenta')) {
      context.handle(_cuentaMeta,
          cuenta.isAcceptableOrUnknown(data['cuenta']!, _cuentaMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('saldo')) {
      context.handle(
          _saldoMeta, saldo.isAcceptableOrUnknown(data['saldo']!, _saldoMeta));
    } else if (isInserting) {
      context.missing(_saldoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaldosCuentaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaldosCuentaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cuenta: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cuenta']),
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
      saldo: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}saldo'])!,
    );
  }

  @override
  $SaldosCuentaTable createAlias(String alias) {
    return $SaldosCuentaTable(attachedDatabase, alias);
  }
}

class SaldosCuentaData extends DataClass
    implements Insertable<SaldosCuentaData> {
  final int id;
  final int? cuenta;
  final DateTime fecha;
  final double saldo;
  const SaldosCuentaData(
      {required this.id,
      this.cuenta,
      required this.fecha,
      required this.saldo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || cuenta != null) {
      map['cuenta'] = Variable<int>(cuenta);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    map['saldo'] = Variable<double>(saldo);
    return map;
  }

  SaldosCuentaCompanion toCompanion(bool nullToAbsent) {
    return SaldosCuentaCompanion(
      id: Value(id),
      cuenta:
          cuenta == null && nullToAbsent ? const Value.absent() : Value(cuenta),
      fecha: Value(fecha),
      saldo: Value(saldo),
    );
  }

  factory SaldosCuentaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaldosCuentaData(
      id: serializer.fromJson<int>(json['id']),
      cuenta: serializer.fromJson<int?>(json['cuenta']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      saldo: serializer.fromJson<double>(json['saldo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cuenta': serializer.toJson<int?>(cuenta),
      'fecha': serializer.toJson<DateTime>(fecha),
      'saldo': serializer.toJson<double>(saldo),
    };
  }

  SaldosCuentaData copyWith(
          {int? id,
          Value<int?> cuenta = const Value.absent(),
          DateTime? fecha,
          double? saldo}) =>
      SaldosCuentaData(
        id: id ?? this.id,
        cuenta: cuenta.present ? cuenta.value : this.cuenta,
        fecha: fecha ?? this.fecha,
        saldo: saldo ?? this.saldo,
      );
  SaldosCuentaData copyWithCompanion(SaldosCuentaCompanion data) {
    return SaldosCuentaData(
      id: data.id.present ? data.id.value : this.id,
      cuenta: data.cuenta.present ? data.cuenta.value : this.cuenta,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      saldo: data.saldo.present ? data.saldo.value : this.saldo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaldosCuentaData(')
          ..write('id: $id, ')
          ..write('cuenta: $cuenta, ')
          ..write('fecha: $fecha, ')
          ..write('saldo: $saldo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cuenta, fecha, saldo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaldosCuentaData &&
          other.id == this.id &&
          other.cuenta == this.cuenta &&
          other.fecha == this.fecha &&
          other.saldo == this.saldo);
}

class SaldosCuentaCompanion extends UpdateCompanion<SaldosCuentaData> {
  final Value<int> id;
  final Value<int?> cuenta;
  final Value<DateTime> fecha;
  final Value<double> saldo;
  const SaldosCuentaCompanion({
    this.id = const Value.absent(),
    this.cuenta = const Value.absent(),
    this.fecha = const Value.absent(),
    this.saldo = const Value.absent(),
  });
  SaldosCuentaCompanion.insert({
    this.id = const Value.absent(),
    this.cuenta = const Value.absent(),
    required DateTime fecha,
    required double saldo,
  })  : fecha = Value(fecha),
        saldo = Value(saldo);
  static Insertable<SaldosCuentaData> custom({
    Expression<int>? id,
    Expression<int>? cuenta,
    Expression<DateTime>? fecha,
    Expression<double>? saldo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cuenta != null) 'cuenta': cuenta,
      if (fecha != null) 'fecha': fecha,
      if (saldo != null) 'saldo': saldo,
    });
  }

  SaldosCuentaCompanion copyWith(
      {Value<int>? id,
      Value<int?>? cuenta,
      Value<DateTime>? fecha,
      Value<double>? saldo}) {
    return SaldosCuentaCompanion(
      id: id ?? this.id,
      cuenta: cuenta ?? this.cuenta,
      fecha: fecha ?? this.fecha,
      saldo: saldo ?? this.saldo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cuenta.present) {
      map['cuenta'] = Variable<int>(cuenta.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (saldo.present) {
      map['saldo'] = Variable<double>(saldo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaldosCuentaCompanion(')
          ..write('id: $id, ')
          ..write('cuenta: $cuenta, ')
          ..write('fecha: $fecha, ')
          ..write('saldo: $saldo')
          ..write(')'))
        .toString();
  }
}

class $DepositoTable extends Deposito
    with TableInfo<$DepositoTable, DepositoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepositoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imposicionMeta =
      const VerificationMeta('imposicion');
  @override
  late final GeneratedColumn<double> imposicion = GeneratedColumn<double>(
      'imposicion', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _renovacionMeta =
      const VerificationMeta('renovacion');
  @override
  late final GeneratedColumn<bool> renovacion = GeneratedColumn<bool>(
      'renovacion', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("renovacion" IN (0, 1))'));
  static const VerificationMeta _inicioMeta = const VerificationMeta('inicio');
  @override
  late final GeneratedColumn<DateTime> inicio = GeneratedColumn<DateTime>(
      'inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _vencimientoMeta =
      const VerificationMeta('vencimiento');
  @override
  late final GeneratedColumn<DateTime> vencimiento = GeneratedColumn<DateTime>(
      'vencimiento', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _taeMeta = const VerificationMeta('tae');
  @override
  late final GeneratedColumn<double> tae = GeneratedColumn<double>(
      'tae', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Titular, String> titular =
      GeneratedColumn<String>('titular', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Titular>($DepositoTable.$convertertitular);
  static const VerificationMeta _entidadMeta =
      const VerificationMeta('entidad');
  @override
  late final GeneratedColumn<String> entidad = GeneratedColumn<String>(
      'entidad', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES entidad (name)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        codigo,
        imposicion,
        renovacion,
        inicio,
        vencimiento,
        tae,
        titular,
        entidad
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deposito';
  @override
  VerificationContext validateIntegrity(Insertable<DepositoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    }
    if (data.containsKey('imposicion')) {
      context.handle(
          _imposicionMeta,
          imposicion.isAcceptableOrUnknown(
              data['imposicion']!, _imposicionMeta));
    } else if (isInserting) {
      context.missing(_imposicionMeta);
    }
    if (data.containsKey('renovacion')) {
      context.handle(
          _renovacionMeta,
          renovacion.isAcceptableOrUnknown(
              data['renovacion']!, _renovacionMeta));
    } else if (isInserting) {
      context.missing(_renovacionMeta);
    }
    if (data.containsKey('inicio')) {
      context.handle(_inicioMeta,
          inicio.isAcceptableOrUnknown(data['inicio']!, _inicioMeta));
    } else if (isInserting) {
      context.missing(_inicioMeta);
    }
    if (data.containsKey('vencimiento')) {
      context.handle(
          _vencimientoMeta,
          vencimiento.isAcceptableOrUnknown(
              data['vencimiento']!, _vencimientoMeta));
    } else if (isInserting) {
      context.missing(_vencimientoMeta);
    }
    if (data.containsKey('tae')) {
      context.handle(
          _taeMeta, tae.isAcceptableOrUnknown(data['tae']!, _taeMeta));
    } else if (isInserting) {
      context.missing(_taeMeta);
    }
    if (data.containsKey('entidad')) {
      context.handle(_entidadMeta,
          entidad.isAcceptableOrUnknown(data['entidad']!, _entidadMeta));
    } else if (isInserting) {
      context.missing(_entidadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DepositoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DepositoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      codigo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo']),
      imposicion: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}imposicion'])!,
      renovacion: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}renovacion'])!,
      inicio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}inicio'])!,
      vencimiento: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}vencimiento'])!,
      tae: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tae'])!,
      titular: $DepositoTable.$convertertitular.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}titular'])!),
      entidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidad'])!,
    );
  }

  @override
  $DepositoTable createAlias(String alias) {
    return $DepositoTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Titular, String, String> $convertertitular =
      const EnumNameConverter<Titular>(Titular.values);
}

class DepositoData extends DataClass implements Insertable<DepositoData> {
  final int id;
  final String name;
  final String? codigo;
  final double imposicion;
  final bool renovacion;
  final DateTime inicio;
  final DateTime vencimiento;
  final double tae;
  final Titular titular;
  final String entidad;
  const DepositoData(
      {required this.id,
      required this.name,
      this.codigo,
      required this.imposicion,
      required this.renovacion,
      required this.inicio,
      required this.vencimiento,
      required this.tae,
      required this.titular,
      required this.entidad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || codigo != null) {
      map['codigo'] = Variable<String>(codigo);
    }
    map['imposicion'] = Variable<double>(imposicion);
    map['renovacion'] = Variable<bool>(renovacion);
    map['inicio'] = Variable<DateTime>(inicio);
    map['vencimiento'] = Variable<DateTime>(vencimiento);
    map['tae'] = Variable<double>(tae);
    {
      map['titular'] =
          Variable<String>($DepositoTable.$convertertitular.toSql(titular));
    }
    map['entidad'] = Variable<String>(entidad);
    return map;
  }

  DepositoCompanion toCompanion(bool nullToAbsent) {
    return DepositoCompanion(
      id: Value(id),
      name: Value(name),
      codigo:
          codigo == null && nullToAbsent ? const Value.absent() : Value(codigo),
      imposicion: Value(imposicion),
      renovacion: Value(renovacion),
      inicio: Value(inicio),
      vencimiento: Value(vencimiento),
      tae: Value(tae),
      titular: Value(titular),
      entidad: Value(entidad),
    );
  }

  factory DepositoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DepositoData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      codigo: serializer.fromJson<String?>(json['codigo']),
      imposicion: serializer.fromJson<double>(json['imposicion']),
      renovacion: serializer.fromJson<bool>(json['renovacion']),
      inicio: serializer.fromJson<DateTime>(json['inicio']),
      vencimiento: serializer.fromJson<DateTime>(json['vencimiento']),
      tae: serializer.fromJson<double>(json['tae']),
      titular: $DepositoTable.$convertertitular
          .fromJson(serializer.fromJson<String>(json['titular'])),
      entidad: serializer.fromJson<String>(json['entidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'codigo': serializer.toJson<String?>(codigo),
      'imposicion': serializer.toJson<double>(imposicion),
      'renovacion': serializer.toJson<bool>(renovacion),
      'inicio': serializer.toJson<DateTime>(inicio),
      'vencimiento': serializer.toJson<DateTime>(vencimiento),
      'tae': serializer.toJson<double>(tae),
      'titular': serializer
          .toJson<String>($DepositoTable.$convertertitular.toJson(titular)),
      'entidad': serializer.toJson<String>(entidad),
    };
  }

  DepositoData copyWith(
          {int? id,
          String? name,
          Value<String?> codigo = const Value.absent(),
          double? imposicion,
          bool? renovacion,
          DateTime? inicio,
          DateTime? vencimiento,
          double? tae,
          Titular? titular,
          String? entidad}) =>
      DepositoData(
        id: id ?? this.id,
        name: name ?? this.name,
        codigo: codigo.present ? codigo.value : this.codigo,
        imposicion: imposicion ?? this.imposicion,
        renovacion: renovacion ?? this.renovacion,
        inicio: inicio ?? this.inicio,
        vencimiento: vencimiento ?? this.vencimiento,
        tae: tae ?? this.tae,
        titular: titular ?? this.titular,
        entidad: entidad ?? this.entidad,
      );
  DepositoData copyWithCompanion(DepositoCompanion data) {
    return DepositoData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      imposicion:
          data.imposicion.present ? data.imposicion.value : this.imposicion,
      renovacion:
          data.renovacion.present ? data.renovacion.value : this.renovacion,
      inicio: data.inicio.present ? data.inicio.value : this.inicio,
      vencimiento:
          data.vencimiento.present ? data.vencimiento.value : this.vencimiento,
      tae: data.tae.present ? data.tae.value : this.tae,
      titular: data.titular.present ? data.titular.value : this.titular,
      entidad: data.entidad.present ? data.entidad.value : this.entidad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DepositoData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('codigo: $codigo, ')
          ..write('imposicion: $imposicion, ')
          ..write('renovacion: $renovacion, ')
          ..write('inicio: $inicio, ')
          ..write('vencimiento: $vencimiento, ')
          ..write('tae: $tae, ')
          ..write('titular: $titular, ')
          ..write('entidad: $entidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, codigo, imposicion, renovacion,
      inicio, vencimiento, tae, titular, entidad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DepositoData &&
          other.id == this.id &&
          other.name == this.name &&
          other.codigo == this.codigo &&
          other.imposicion == this.imposicion &&
          other.renovacion == this.renovacion &&
          other.inicio == this.inicio &&
          other.vencimiento == this.vencimiento &&
          other.tae == this.tae &&
          other.titular == this.titular &&
          other.entidad == this.entidad);
}

class DepositoCompanion extends UpdateCompanion<DepositoData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> codigo;
  final Value<double> imposicion;
  final Value<bool> renovacion;
  final Value<DateTime> inicio;
  final Value<DateTime> vencimiento;
  final Value<double> tae;
  final Value<Titular> titular;
  final Value<String> entidad;
  const DepositoCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.codigo = const Value.absent(),
    this.imposicion = const Value.absent(),
    this.renovacion = const Value.absent(),
    this.inicio = const Value.absent(),
    this.vencimiento = const Value.absent(),
    this.tae = const Value.absent(),
    this.titular = const Value.absent(),
    this.entidad = const Value.absent(),
  });
  DepositoCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.codigo = const Value.absent(),
    required double imposicion,
    required bool renovacion,
    required DateTime inicio,
    required DateTime vencimiento,
    required double tae,
    required Titular titular,
    required String entidad,
  })  : name = Value(name),
        imposicion = Value(imposicion),
        renovacion = Value(renovacion),
        inicio = Value(inicio),
        vencimiento = Value(vencimiento),
        tae = Value(tae),
        titular = Value(titular),
        entidad = Value(entidad);
  static Insertable<DepositoData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? codigo,
    Expression<double>? imposicion,
    Expression<bool>? renovacion,
    Expression<DateTime>? inicio,
    Expression<DateTime>? vencimiento,
    Expression<double>? tae,
    Expression<String>? titular,
    Expression<String>? entidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (codigo != null) 'codigo': codigo,
      if (imposicion != null) 'imposicion': imposicion,
      if (renovacion != null) 'renovacion': renovacion,
      if (inicio != null) 'inicio': inicio,
      if (vencimiento != null) 'vencimiento': vencimiento,
      if (tae != null) 'tae': tae,
      if (titular != null) 'titular': titular,
      if (entidad != null) 'entidad': entidad,
    });
  }

  DepositoCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? codigo,
      Value<double>? imposicion,
      Value<bool>? renovacion,
      Value<DateTime>? inicio,
      Value<DateTime>? vencimiento,
      Value<double>? tae,
      Value<Titular>? titular,
      Value<String>? entidad}) {
    return DepositoCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      codigo: codigo ?? this.codigo,
      imposicion: imposicion ?? this.imposicion,
      renovacion: renovacion ?? this.renovacion,
      inicio: inicio ?? this.inicio,
      vencimiento: vencimiento ?? this.vencimiento,
      tae: tae ?? this.tae,
      titular: titular ?? this.titular,
      entidad: entidad ?? this.entidad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (imposicion.present) {
      map['imposicion'] = Variable<double>(imposicion.value);
    }
    if (renovacion.present) {
      map['renovacion'] = Variable<bool>(renovacion.value);
    }
    if (inicio.present) {
      map['inicio'] = Variable<DateTime>(inicio.value);
    }
    if (vencimiento.present) {
      map['vencimiento'] = Variable<DateTime>(vencimiento.value);
    }
    if (tae.present) {
      map['tae'] = Variable<double>(tae.value);
    }
    if (titular.present) {
      map['titular'] = Variable<String>(
          $DepositoTable.$convertertitular.toSql(titular.value));
    }
    if (entidad.present) {
      map['entidad'] = Variable<String>(entidad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepositoCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('codigo: $codigo, ')
          ..write('imposicion: $imposicion, ')
          ..write('renovacion: $renovacion, ')
          ..write('inicio: $inicio, ')
          ..write('vencimiento: $vencimiento, ')
          ..write('tae: $tae, ')
          ..write('titular: $titular, ')
          ..write('entidad: $entidad')
          ..write(')'))
        .toString();
  }
}

class $FondoTable extends Fondo with TableInfo<$FondoTable, FondoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FondoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isinMeta = const VerificationMeta('isin');
  @override
  late final GeneratedColumn<String> isin = GeneratedColumn<String>(
      'isin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _participacionesMeta =
      const VerificationMeta('participaciones');
  @override
  late final GeneratedColumn<double> participaciones = GeneratedColumn<double>(
      'participaciones', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _valorInicialMeta =
      const VerificationMeta('valorInicial');
  @override
  late final GeneratedColumn<double> valorInicial = GeneratedColumn<double>(
      'valor_inicial', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fechaInicialMeta =
      const VerificationMeta('fechaInicial');
  @override
  late final GeneratedColumn<DateTime> fechaInicial = GeneratedColumn<DateTime>(
      'fecha_inicial', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Titular, String> titular =
      GeneratedColumn<String>('titular', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Titular>($FondoTable.$convertertitular);
  static const VerificationMeta _entidadMeta =
      const VerificationMeta('entidad');
  @override
  late final GeneratedColumn<String> entidad = GeneratedColumn<String>(
      'entidad', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES entidad (name)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        isin,
        participaciones,
        valorInicial,
        fechaInicial,
        titular,
        entidad
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fondo';
  @override
  VerificationContext validateIntegrity(Insertable<FondoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('isin')) {
      context.handle(
          _isinMeta, isin.isAcceptableOrUnknown(data['isin']!, _isinMeta));
    }
    if (data.containsKey('participaciones')) {
      context.handle(
          _participacionesMeta,
          participaciones.isAcceptableOrUnknown(
              data['participaciones']!, _participacionesMeta));
    } else if (isInserting) {
      context.missing(_participacionesMeta);
    }
    if (data.containsKey('valor_inicial')) {
      context.handle(
          _valorInicialMeta,
          valorInicial.isAcceptableOrUnknown(
              data['valor_inicial']!, _valorInicialMeta));
    } else if (isInserting) {
      context.missing(_valorInicialMeta);
    }
    if (data.containsKey('fecha_inicial')) {
      context.handle(
          _fechaInicialMeta,
          fechaInicial.isAcceptableOrUnknown(
              data['fecha_inicial']!, _fechaInicialMeta));
    } else if (isInserting) {
      context.missing(_fechaInicialMeta);
    }
    if (data.containsKey('entidad')) {
      context.handle(_entidadMeta,
          entidad.isAcceptableOrUnknown(data['entidad']!, _entidadMeta));
    } else if (isInserting) {
      context.missing(_entidadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FondoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FondoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}isin']),
      participaciones: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}participaciones'])!,
      valorInicial: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valor_inicial'])!,
      fechaInicial: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_inicial'])!,
      titular: $FondoTable.$convertertitular.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}titular'])!),
      entidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidad'])!,
    );
  }

  @override
  $FondoTable createAlias(String alias) {
    return $FondoTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Titular, String, String> $convertertitular =
      const EnumNameConverter<Titular>(Titular.values);
}

class FondoData extends DataClass implements Insertable<FondoData> {
  final int id;
  final String name;
  final String? isin;
  final double participaciones;
  final double valorInicial;
  final DateTime fechaInicial;
  final Titular titular;
  final String entidad;
  const FondoData(
      {required this.id,
      required this.name,
      this.isin,
      required this.participaciones,
      required this.valorInicial,
      required this.fechaInicial,
      required this.titular,
      required this.entidad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || isin != null) {
      map['isin'] = Variable<String>(isin);
    }
    map['participaciones'] = Variable<double>(participaciones);
    map['valor_inicial'] = Variable<double>(valorInicial);
    map['fecha_inicial'] = Variable<DateTime>(fechaInicial);
    {
      map['titular'] =
          Variable<String>($FondoTable.$convertertitular.toSql(titular));
    }
    map['entidad'] = Variable<String>(entidad);
    return map;
  }

  FondoCompanion toCompanion(bool nullToAbsent) {
    return FondoCompanion(
      id: Value(id),
      name: Value(name),
      isin: isin == null && nullToAbsent ? const Value.absent() : Value(isin),
      participaciones: Value(participaciones),
      valorInicial: Value(valorInicial),
      fechaInicial: Value(fechaInicial),
      titular: Value(titular),
      entidad: Value(entidad),
    );
  }

  factory FondoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FondoData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isin: serializer.fromJson<String?>(json['isin']),
      participaciones: serializer.fromJson<double>(json['participaciones']),
      valorInicial: serializer.fromJson<double>(json['valorInicial']),
      fechaInicial: serializer.fromJson<DateTime>(json['fechaInicial']),
      titular: $FondoTable.$convertertitular
          .fromJson(serializer.fromJson<String>(json['titular'])),
      entidad: serializer.fromJson<String>(json['entidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isin': serializer.toJson<String?>(isin),
      'participaciones': serializer.toJson<double>(participaciones),
      'valorInicial': serializer.toJson<double>(valorInicial),
      'fechaInicial': serializer.toJson<DateTime>(fechaInicial),
      'titular': serializer
          .toJson<String>($FondoTable.$convertertitular.toJson(titular)),
      'entidad': serializer.toJson<String>(entidad),
    };
  }

  FondoData copyWith(
          {int? id,
          String? name,
          Value<String?> isin = const Value.absent(),
          double? participaciones,
          double? valorInicial,
          DateTime? fechaInicial,
          Titular? titular,
          String? entidad}) =>
      FondoData(
        id: id ?? this.id,
        name: name ?? this.name,
        isin: isin.present ? isin.value : this.isin,
        participaciones: participaciones ?? this.participaciones,
        valorInicial: valorInicial ?? this.valorInicial,
        fechaInicial: fechaInicial ?? this.fechaInicial,
        titular: titular ?? this.titular,
        entidad: entidad ?? this.entidad,
      );
  FondoData copyWithCompanion(FondoCompanion data) {
    return FondoData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isin: data.isin.present ? data.isin.value : this.isin,
      participaciones: data.participaciones.present
          ? data.participaciones.value
          : this.participaciones,
      valorInicial: data.valorInicial.present
          ? data.valorInicial.value
          : this.valorInicial,
      fechaInicial: data.fechaInicial.present
          ? data.fechaInicial.value
          : this.fechaInicial,
      titular: data.titular.present ? data.titular.value : this.titular,
      entidad: data.entidad.present ? data.entidad.value : this.entidad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FondoData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isin: $isin, ')
          ..write('participaciones: $participaciones, ')
          ..write('valorInicial: $valorInicial, ')
          ..write('fechaInicial: $fechaInicial, ')
          ..write('titular: $titular, ')
          ..write('entidad: $entidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isin, participaciones, valorInicial,
      fechaInicial, titular, entidad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FondoData &&
          other.id == this.id &&
          other.name == this.name &&
          other.isin == this.isin &&
          other.participaciones == this.participaciones &&
          other.valorInicial == this.valorInicial &&
          other.fechaInicial == this.fechaInicial &&
          other.titular == this.titular &&
          other.entidad == this.entidad);
}

class FondoCompanion extends UpdateCompanion<FondoData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> isin;
  final Value<double> participaciones;
  final Value<double> valorInicial;
  final Value<DateTime> fechaInicial;
  final Value<Titular> titular;
  final Value<String> entidad;
  const FondoCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isin = const Value.absent(),
    this.participaciones = const Value.absent(),
    this.valorInicial = const Value.absent(),
    this.fechaInicial = const Value.absent(),
    this.titular = const Value.absent(),
    this.entidad = const Value.absent(),
  });
  FondoCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isin = const Value.absent(),
    required double participaciones,
    required double valorInicial,
    required DateTime fechaInicial,
    required Titular titular,
    required String entidad,
  })  : name = Value(name),
        participaciones = Value(participaciones),
        valorInicial = Value(valorInicial),
        fechaInicial = Value(fechaInicial),
        titular = Value(titular),
        entidad = Value(entidad);
  static Insertable<FondoData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? isin,
    Expression<double>? participaciones,
    Expression<double>? valorInicial,
    Expression<DateTime>? fechaInicial,
    Expression<String>? titular,
    Expression<String>? entidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isin != null) 'isin': isin,
      if (participaciones != null) 'participaciones': participaciones,
      if (valorInicial != null) 'valor_inicial': valorInicial,
      if (fechaInicial != null) 'fecha_inicial': fechaInicial,
      if (titular != null) 'titular': titular,
      if (entidad != null) 'entidad': entidad,
    });
  }

  FondoCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? isin,
      Value<double>? participaciones,
      Value<double>? valorInicial,
      Value<DateTime>? fechaInicial,
      Value<Titular>? titular,
      Value<String>? entidad}) {
    return FondoCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isin: isin ?? this.isin,
      participaciones: participaciones ?? this.participaciones,
      valorInicial: valorInicial ?? this.valorInicial,
      fechaInicial: fechaInicial ?? this.fechaInicial,
      titular: titular ?? this.titular,
      entidad: entidad ?? this.entidad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isin.present) {
      map['isin'] = Variable<String>(isin.value);
    }
    if (participaciones.present) {
      map['participaciones'] = Variable<double>(participaciones.value);
    }
    if (valorInicial.present) {
      map['valor_inicial'] = Variable<double>(valorInicial.value);
    }
    if (fechaInicial.present) {
      map['fecha_inicial'] = Variable<DateTime>(fechaInicial.value);
    }
    if (titular.present) {
      map['titular'] =
          Variable<String>($FondoTable.$convertertitular.toSql(titular.value));
    }
    if (entidad.present) {
      map['entidad'] = Variable<String>(entidad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FondoCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isin: $isin, ')
          ..write('participaciones: $participaciones, ')
          ..write('valorInicial: $valorInicial, ')
          ..write('fechaInicial: $fechaInicial, ')
          ..write('titular: $titular, ')
          ..write('entidad: $entidad')
          ..write(')'))
        .toString();
  }
}

class $ValoresFondoTable extends ValoresFondo
    with TableInfo<$ValoresFondoTable, ValoresFondoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ValoresFondoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fondoMeta = const VerificationMeta('fondo');
  @override
  late final GeneratedColumn<int> fondo = GeneratedColumn<int>(
      'fondo', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES fondo (id)'));
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
      'valor', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TipoOp?, String> tipo =
      GeneratedColumn<String>('tipo', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<TipoOp?>($ValoresFondoTable.$convertertipon);
  static const VerificationMeta _participacionesMeta =
      const VerificationMeta('participaciones');
  @override
  late final GeneratedColumn<double> participaciones = GeneratedColumn<double>(
      'participaciones', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fondo, fecha, valor, tipo, participaciones];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'valores_fondo';
  @override
  VerificationContext validateIntegrity(Insertable<ValoresFondoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fondo')) {
      context.handle(
          _fondoMeta, fondo.isAcceptableOrUnknown(data['fondo']!, _fondoMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('participaciones')) {
      context.handle(
          _participacionesMeta,
          participaciones.isAcceptableOrUnknown(
              data['participaciones']!, _participacionesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ValoresFondoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ValoresFondoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fondo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fondo']),
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
      valor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valor'])!,
      tipo: $ValoresFondoTable.$convertertipon.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])),
      participaciones: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}participaciones']),
    );
  }

  @override
  $ValoresFondoTable createAlias(String alias) {
    return $ValoresFondoTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoOp, String, String> $convertertipo =
      const EnumNameConverter<TipoOp>(TipoOp.values);
  static JsonTypeConverter2<TipoOp?, String?, String?> $convertertipon =
      JsonTypeConverter2.asNullable($convertertipo);
}

class ValoresFondoData extends DataClass
    implements Insertable<ValoresFondoData> {
  final int id;
  final int? fondo;
  final DateTime fecha;
  final double valor;
  final TipoOp? tipo;
  final double? participaciones;
  const ValoresFondoData(
      {required this.id,
      this.fondo,
      required this.fecha,
      required this.valor,
      this.tipo,
      this.participaciones});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || fondo != null) {
      map['fondo'] = Variable<int>(fondo);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    map['valor'] = Variable<double>(valor);
    if (!nullToAbsent || tipo != null) {
      map['tipo'] =
          Variable<String>($ValoresFondoTable.$convertertipon.toSql(tipo));
    }
    if (!nullToAbsent || participaciones != null) {
      map['participaciones'] = Variable<double>(participaciones);
    }
    return map;
  }

  ValoresFondoCompanion toCompanion(bool nullToAbsent) {
    return ValoresFondoCompanion(
      id: Value(id),
      fondo:
          fondo == null && nullToAbsent ? const Value.absent() : Value(fondo),
      fecha: Value(fecha),
      valor: Value(valor),
      tipo: tipo == null && nullToAbsent ? const Value.absent() : Value(tipo),
      participaciones: participaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(participaciones),
    );
  }

  factory ValoresFondoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ValoresFondoData(
      id: serializer.fromJson<int>(json['id']),
      fondo: serializer.fromJson<int?>(json['fondo']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      valor: serializer.fromJson<double>(json['valor']),
      tipo: $ValoresFondoTable.$convertertipon
          .fromJson(serializer.fromJson<String?>(json['tipo'])),
      participaciones: serializer.fromJson<double?>(json['participaciones']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fondo': serializer.toJson<int?>(fondo),
      'fecha': serializer.toJson<DateTime>(fecha),
      'valor': serializer.toJson<double>(valor),
      'tipo': serializer
          .toJson<String?>($ValoresFondoTable.$convertertipon.toJson(tipo)),
      'participaciones': serializer.toJson<double?>(participaciones),
    };
  }

  ValoresFondoData copyWith(
          {int? id,
          Value<int?> fondo = const Value.absent(),
          DateTime? fecha,
          double? valor,
          Value<TipoOp?> tipo = const Value.absent(),
          Value<double?> participaciones = const Value.absent()}) =>
      ValoresFondoData(
        id: id ?? this.id,
        fondo: fondo.present ? fondo.value : this.fondo,
        fecha: fecha ?? this.fecha,
        valor: valor ?? this.valor,
        tipo: tipo.present ? tipo.value : this.tipo,
        participaciones: participaciones.present
            ? participaciones.value
            : this.participaciones,
      );
  ValoresFondoData copyWithCompanion(ValoresFondoCompanion data) {
    return ValoresFondoData(
      id: data.id.present ? data.id.value : this.id,
      fondo: data.fondo.present ? data.fondo.value : this.fondo,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      valor: data.valor.present ? data.valor.value : this.valor,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      participaciones: data.participaciones.present
          ? data.participaciones.value
          : this.participaciones,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ValoresFondoData(')
          ..write('id: $id, ')
          ..write('fondo: $fondo, ')
          ..write('fecha: $fecha, ')
          ..write('valor: $valor, ')
          ..write('tipo: $tipo, ')
          ..write('participaciones: $participaciones')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fondo, fecha, valor, tipo, participaciones);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ValoresFondoData &&
          other.id == this.id &&
          other.fondo == this.fondo &&
          other.fecha == this.fecha &&
          other.valor == this.valor &&
          other.tipo == this.tipo &&
          other.participaciones == this.participaciones);
}

class ValoresFondoCompanion extends UpdateCompanion<ValoresFondoData> {
  final Value<int> id;
  final Value<int?> fondo;
  final Value<DateTime> fecha;
  final Value<double> valor;
  final Value<TipoOp?> tipo;
  final Value<double?> participaciones;
  const ValoresFondoCompanion({
    this.id = const Value.absent(),
    this.fondo = const Value.absent(),
    this.fecha = const Value.absent(),
    this.valor = const Value.absent(),
    this.tipo = const Value.absent(),
    this.participaciones = const Value.absent(),
  });
  ValoresFondoCompanion.insert({
    this.id = const Value.absent(),
    this.fondo = const Value.absent(),
    required DateTime fecha,
    required double valor,
    this.tipo = const Value.absent(),
    this.participaciones = const Value.absent(),
  })  : fecha = Value(fecha),
        valor = Value(valor);
  static Insertable<ValoresFondoData> custom({
    Expression<int>? id,
    Expression<int>? fondo,
    Expression<DateTime>? fecha,
    Expression<double>? valor,
    Expression<String>? tipo,
    Expression<double>? participaciones,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fondo != null) 'fondo': fondo,
      if (fecha != null) 'fecha': fecha,
      if (valor != null) 'valor': valor,
      if (tipo != null) 'tipo': tipo,
      if (participaciones != null) 'participaciones': participaciones,
    });
  }

  ValoresFondoCompanion copyWith(
      {Value<int>? id,
      Value<int?>? fondo,
      Value<DateTime>? fecha,
      Value<double>? valor,
      Value<TipoOp?>? tipo,
      Value<double?>? participaciones}) {
    return ValoresFondoCompanion(
      id: id ?? this.id,
      fondo: fondo ?? this.fondo,
      fecha: fecha ?? this.fecha,
      valor: valor ?? this.valor,
      tipo: tipo ?? this.tipo,
      participaciones: participaciones ?? this.participaciones,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fondo.present) {
      map['fondo'] = Variable<int>(fondo.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
          $ValoresFondoTable.$convertertipon.toSql(tipo.value));
    }
    if (participaciones.present) {
      map['participaciones'] = Variable<double>(participaciones.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ValoresFondoCompanion(')
          ..write('id: $id, ')
          ..write('fondo: $fondo, ')
          ..write('fecha: $fecha, ')
          ..write('valor: $valor, ')
          ..write('tipo: $tipo, ')
          ..write('participaciones: $participaciones')
          ..write(')'))
        .toString();
  }
}

class $HistoricoTable extends Historico
    with TableInfo<$HistoricoTable, HistoricoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoricoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalCuentasMeta =
      const VerificationMeta('totalCuentas');
  @override
  late final GeneratedColumn<double> totalCuentas = GeneratedColumn<double>(
      'total_cuentas', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalDepositosMeta =
      const VerificationMeta('totalDepositos');
  @override
  late final GeneratedColumn<double> totalDepositos = GeneratedColumn<double>(
      'total_depositos', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalFondosMeta =
      const VerificationMeta('totalFondos');
  @override
  late final GeneratedColumn<double> totalFondos = GeneratedColumn<double>(
      'total_fondos', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fecha, totalCuentas, totalDepositos, totalFondos];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historico';
  @override
  VerificationContext validateIntegrity(Insertable<HistoricoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('total_cuentas')) {
      context.handle(
          _totalCuentasMeta,
          totalCuentas.isAcceptableOrUnknown(
              data['total_cuentas']!, _totalCuentasMeta));
    } else if (isInserting) {
      context.missing(_totalCuentasMeta);
    }
    if (data.containsKey('total_depositos')) {
      context.handle(
          _totalDepositosMeta,
          totalDepositos.isAcceptableOrUnknown(
              data['total_depositos']!, _totalDepositosMeta));
    } else if (isInserting) {
      context.missing(_totalDepositosMeta);
    }
    if (data.containsKey('total_fondos')) {
      context.handle(
          _totalFondosMeta,
          totalFondos.isAcceptableOrUnknown(
              data['total_fondos']!, _totalFondosMeta));
    } else if (isInserting) {
      context.missing(_totalFondosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoricoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoricoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
      totalCuentas: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_cuentas'])!,
      totalDepositos: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_depositos'])!,
      totalFondos: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_fondos'])!,
    );
  }

  @override
  $HistoricoTable createAlias(String alias) {
    return $HistoricoTable(attachedDatabase, alias);
  }
}

class HistoricoData extends DataClass implements Insertable<HistoricoData> {
  final int id;
  final DateTime fecha;
  final double totalCuentas;
  final double totalDepositos;
  final double totalFondos;
  const HistoricoData(
      {required this.id,
      required this.fecha,
      required this.totalCuentas,
      required this.totalDepositos,
      required this.totalFondos});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha'] = Variable<DateTime>(fecha);
    map['total_cuentas'] = Variable<double>(totalCuentas);
    map['total_depositos'] = Variable<double>(totalDepositos);
    map['total_fondos'] = Variable<double>(totalFondos);
    return map;
  }

  HistoricoCompanion toCompanion(bool nullToAbsent) {
    return HistoricoCompanion(
      id: Value(id),
      fecha: Value(fecha),
      totalCuentas: Value(totalCuentas),
      totalDepositos: Value(totalDepositos),
      totalFondos: Value(totalFondos),
    );
  }

  factory HistoricoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoricoData(
      id: serializer.fromJson<int>(json['id']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      totalCuentas: serializer.fromJson<double>(json['totalCuentas']),
      totalDepositos: serializer.fromJson<double>(json['totalDepositos']),
      totalFondos: serializer.fromJson<double>(json['totalFondos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fecha': serializer.toJson<DateTime>(fecha),
      'totalCuentas': serializer.toJson<double>(totalCuentas),
      'totalDepositos': serializer.toJson<double>(totalDepositos),
      'totalFondos': serializer.toJson<double>(totalFondos),
    };
  }

  HistoricoData copyWith(
          {int? id,
          DateTime? fecha,
          double? totalCuentas,
          double? totalDepositos,
          double? totalFondos}) =>
      HistoricoData(
        id: id ?? this.id,
        fecha: fecha ?? this.fecha,
        totalCuentas: totalCuentas ?? this.totalCuentas,
        totalDepositos: totalDepositos ?? this.totalDepositos,
        totalFondos: totalFondos ?? this.totalFondos,
      );
  HistoricoData copyWithCompanion(HistoricoCompanion data) {
    return HistoricoData(
      id: data.id.present ? data.id.value : this.id,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      totalCuentas: data.totalCuentas.present
          ? data.totalCuentas.value
          : this.totalCuentas,
      totalDepositos: data.totalDepositos.present
          ? data.totalDepositos.value
          : this.totalDepositos,
      totalFondos:
          data.totalFondos.present ? data.totalFondos.value : this.totalFondos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoricoData(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('totalCuentas: $totalCuentas, ')
          ..write('totalDepositos: $totalDepositos, ')
          ..write('totalFondos: $totalFondos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fecha, totalCuentas, totalDepositos, totalFondos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoricoData &&
          other.id == this.id &&
          other.fecha == this.fecha &&
          other.totalCuentas == this.totalCuentas &&
          other.totalDepositos == this.totalDepositos &&
          other.totalFondos == this.totalFondos);
}

class HistoricoCompanion extends UpdateCompanion<HistoricoData> {
  final Value<int> id;
  final Value<DateTime> fecha;
  final Value<double> totalCuentas;
  final Value<double> totalDepositos;
  final Value<double> totalFondos;
  const HistoricoCompanion({
    this.id = const Value.absent(),
    this.fecha = const Value.absent(),
    this.totalCuentas = const Value.absent(),
    this.totalDepositos = const Value.absent(),
    this.totalFondos = const Value.absent(),
  });
  HistoricoCompanion.insert({
    this.id = const Value.absent(),
    required DateTime fecha,
    required double totalCuentas,
    required double totalDepositos,
    required double totalFondos,
  })  : fecha = Value(fecha),
        totalCuentas = Value(totalCuentas),
        totalDepositos = Value(totalDepositos),
        totalFondos = Value(totalFondos);
  static Insertable<HistoricoData> custom({
    Expression<int>? id,
    Expression<DateTime>? fecha,
    Expression<double>? totalCuentas,
    Expression<double>? totalDepositos,
    Expression<double>? totalFondos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fecha != null) 'fecha': fecha,
      if (totalCuentas != null) 'total_cuentas': totalCuentas,
      if (totalDepositos != null) 'total_depositos': totalDepositos,
      if (totalFondos != null) 'total_fondos': totalFondos,
    });
  }

  HistoricoCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? fecha,
      Value<double>? totalCuentas,
      Value<double>? totalDepositos,
      Value<double>? totalFondos}) {
    return HistoricoCompanion(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      totalCuentas: totalCuentas ?? this.totalCuentas,
      totalDepositos: totalDepositos ?? this.totalDepositos,
      totalFondos: totalFondos ?? this.totalFondos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (totalCuentas.present) {
      map['total_cuentas'] = Variable<double>(totalCuentas.value);
    }
    if (totalDepositos.present) {
      map['total_depositos'] = Variable<double>(totalDepositos.value);
    }
    if (totalFondos.present) {
      map['total_fondos'] = Variable<double>(totalFondos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoricoCompanion(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('totalCuentas: $totalCuentas, ')
          ..write('totalDepositos: $totalDepositos, ')
          ..write('totalFondos: $totalFondos')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EntidadTable entidad = $EntidadTable(this);
  late final $CuentaTable cuenta = $CuentaTable(this);
  late final $SaldosCuentaTable saldosCuenta = $SaldosCuentaTable(this);
  late final $DepositoTable deposito = $DepositoTable(this);
  late final $FondoTable fondo = $FondoTable(this);
  late final $ValoresFondoTable valoresFondo = $ValoresFondoTable(this);
  late final $HistoricoTable historico = $HistoricoTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [entidad, cuenta, saldosCuenta, deposito, fondo, valoresFondo, historico];
}

typedef $$EntidadTableCreateCompanionBuilder = EntidadCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> bic,
  Value<String?> web,
  Value<String?> phone,
  Value<String?> email,
  required String logo,
});
typedef $$EntidadTableUpdateCompanionBuilder = EntidadCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> bic,
  Value<String?> web,
  Value<String?> phone,
  Value<String?> email,
  Value<String> logo,
});

final class $$EntidadTableReferences
    extends BaseReferences<_$AppDatabase, $EntidadTable, EntidadData> {
  $$EntidadTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CuentaTable, List<CuentaData>> _cuentaRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.cuenta,
          aliasName: $_aliasNameGenerator(db.entidad.name, db.cuenta.entidad));

  $$CuentaTableProcessedTableManager get cuentaRefs {
    final manager = $$CuentaTableTableManager($_db, $_db.cuenta)
        .filter((f) => f.entidad.name.sqlEquals($_itemColumn<String>('name')!));

    final cache = $_typedResult.readTableOrNull(_cuentaRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DepositoTable, List<DepositoData>>
      _depositoRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.deposito,
              aliasName:
                  $_aliasNameGenerator(db.entidad.name, db.deposito.entidad));

  $$DepositoTableProcessedTableManager get depositoRefs {
    final manager = $$DepositoTableTableManager($_db, $_db.deposito)
        .filter((f) => f.entidad.name.sqlEquals($_itemColumn<String>('name')!));

    final cache = $_typedResult.readTableOrNull(_depositoRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FondoTable, List<FondoData>> _fondoRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.fondo,
          aliasName: $_aliasNameGenerator(db.entidad.name, db.fondo.entidad));

  $$FondoTableProcessedTableManager get fondoRefs {
    final manager = $$FondoTableTableManager($_db, $_db.fondo)
        .filter((f) => f.entidad.name.sqlEquals($_itemColumn<String>('name')!));

    final cache = $_typedResult.readTableOrNull(_fondoRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EntidadTableFilterComposer
    extends Composer<_$AppDatabase, $EntidadTable> {
  $$EntidadTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bic => $composableBuilder(
      column: $table.bic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get web => $composableBuilder(
      column: $table.web, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logo => $composableBuilder(
      column: $table.logo, builder: (column) => ColumnFilters(column));

  Expression<bool> cuentaRefs(
      Expression<bool> Function($$CuentaTableFilterComposer f) f) {
    final $$CuentaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.name,
        referencedTable: $db.cuenta,
        getReferencedColumn: (t) => t.entidad,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CuentaTableFilterComposer(
              $db: $db,
              $table: $db.cuenta,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> depositoRefs(
      Expression<bool> Function($$DepositoTableFilterComposer f) f) {
    final $$DepositoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.name,
        referencedTable: $db.deposito,
        getReferencedColumn: (t) => t.entidad,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepositoTableFilterComposer(
              $db: $db,
              $table: $db.deposito,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> fondoRefs(
      Expression<bool> Function($$FondoTableFilterComposer f) f) {
    final $$FondoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.name,
        referencedTable: $db.fondo,
        getReferencedColumn: (t) => t.entidad,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FondoTableFilterComposer(
              $db: $db,
              $table: $db.fondo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EntidadTableOrderingComposer
    extends Composer<_$AppDatabase, $EntidadTable> {
  $$EntidadTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bic => $composableBuilder(
      column: $table.bic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get web => $composableBuilder(
      column: $table.web, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logo => $composableBuilder(
      column: $table.logo, builder: (column) => ColumnOrderings(column));
}

class $$EntidadTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntidadTable> {
  $$EntidadTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bic =>
      $composableBuilder(column: $table.bic, builder: (column) => column);

  GeneratedColumn<String> get web =>
      $composableBuilder(column: $table.web, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get logo =>
      $composableBuilder(column: $table.logo, builder: (column) => column);

  Expression<T> cuentaRefs<T extends Object>(
      Expression<T> Function($$CuentaTableAnnotationComposer a) f) {
    final $$CuentaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.name,
        referencedTable: $db.cuenta,
        getReferencedColumn: (t) => t.entidad,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CuentaTableAnnotationComposer(
              $db: $db,
              $table: $db.cuenta,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> depositoRefs<T extends Object>(
      Expression<T> Function($$DepositoTableAnnotationComposer a) f) {
    final $$DepositoTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.name,
        referencedTable: $db.deposito,
        getReferencedColumn: (t) => t.entidad,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepositoTableAnnotationComposer(
              $db: $db,
              $table: $db.deposito,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> fondoRefs<T extends Object>(
      Expression<T> Function($$FondoTableAnnotationComposer a) f) {
    final $$FondoTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.name,
        referencedTable: $db.fondo,
        getReferencedColumn: (t) => t.entidad,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FondoTableAnnotationComposer(
              $db: $db,
              $table: $db.fondo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EntidadTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntidadTable,
    EntidadData,
    $$EntidadTableFilterComposer,
    $$EntidadTableOrderingComposer,
    $$EntidadTableAnnotationComposer,
    $$EntidadTableCreateCompanionBuilder,
    $$EntidadTableUpdateCompanionBuilder,
    (EntidadData, $$EntidadTableReferences),
    EntidadData,
    PrefetchHooks Function(
        {bool cuentaRefs, bool depositoRefs, bool fondoRefs})> {
  $$EntidadTableTableManager(_$AppDatabase db, $EntidadTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntidadTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntidadTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntidadTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> bic = const Value.absent(),
            Value<String?> web = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String> logo = const Value.absent(),
          }) =>
              EntidadCompanion(
            id: id,
            name: name,
            bic: bic,
            web: web,
            phone: phone,
            email: email,
            logo: logo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> bic = const Value.absent(),
            Value<String?> web = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            required String logo,
          }) =>
              EntidadCompanion.insert(
            id: id,
            name: name,
            bic: bic,
            web: web,
            phone: phone,
            email: email,
            logo: logo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EntidadTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {cuentaRefs = false, depositoRefs = false, fondoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cuentaRefs) db.cuenta,
                if (depositoRefs) db.deposito,
                if (fondoRefs) db.fondo
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cuentaRefs)
                    await $_getPrefetchedData<EntidadData, $EntidadTable,
                            CuentaData>(
                        currentTable: table,
                        referencedTable:
                            $$EntidadTableReferences._cuentaRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntidadTableReferences(db, table, p0).cuentaRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.entidad == item.name),
                        typedResults: items),
                  if (depositoRefs)
                    await $_getPrefetchedData<EntidadData, $EntidadTable,
                            DepositoData>(
                        currentTable: table,
                        referencedTable:
                            $$EntidadTableReferences._depositoRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntidadTableReferences(db, table, p0)
                                .depositoRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.entidad == item.name),
                        typedResults: items),
                  if (fondoRefs)
                    await $_getPrefetchedData<EntidadData, $EntidadTable,
                            FondoData>(
                        currentTable: table,
                        referencedTable:
                            $$EntidadTableReferences._fondoRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntidadTableReferences(db, table, p0).fondoRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.entidad == item.name),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EntidadTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntidadTable,
    EntidadData,
    $$EntidadTableFilterComposer,
    $$EntidadTableOrderingComposer,
    $$EntidadTableAnnotationComposer,
    $$EntidadTableCreateCompanionBuilder,
    $$EntidadTableUpdateCompanionBuilder,
    (EntidadData, $$EntidadTableReferences),
    EntidadData,
    PrefetchHooks Function(
        {bool cuentaRefs, bool depositoRefs, bool fondoRefs})>;
typedef $$CuentaTableCreateCompanionBuilder = CuentaCompanion Function({
  Value<int> id,
  required String name,
  required String iban,
  required double tae,
  required Titular titular,
  required String entidad,
});
typedef $$CuentaTableUpdateCompanionBuilder = CuentaCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> iban,
  Value<double> tae,
  Value<Titular> titular,
  Value<String> entidad,
});

final class $$CuentaTableReferences
    extends BaseReferences<_$AppDatabase, $CuentaTable, CuentaData> {
  $$CuentaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntidadTable _entidadTable(_$AppDatabase db) => db.entidad
      .createAlias($_aliasNameGenerator(db.cuenta.entidad, db.entidad.name));

  $$EntidadTableProcessedTableManager get entidad {
    final $_column = $_itemColumn<String>('entidad')!;

    final manager = $$EntidadTableTableManager($_db, $_db.entidad)
        .filter((f) => f.name.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entidadTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SaldosCuentaTable, List<SaldosCuentaData>>
      _saldosCuentaRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.saldosCuenta,
              aliasName:
                  $_aliasNameGenerator(db.cuenta.id, db.saldosCuenta.cuenta));

  $$SaldosCuentaTableProcessedTableManager get saldosCuentaRefs {
    final manager = $$SaldosCuentaTableTableManager($_db, $_db.saldosCuenta)
        .filter((f) => f.cuenta.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saldosCuentaRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CuentaTableFilterComposer
    extends Composer<_$AppDatabase, $CuentaTable> {
  $$CuentaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iban => $composableBuilder(
      column: $table.iban, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tae => $composableBuilder(
      column: $table.tae, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Titular, Titular, String> get titular =>
      $composableBuilder(
          column: $table.titular,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$EntidadTableFilterComposer get entidad {
    final $$EntidadTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entidad,
        referencedTable: $db.entidad,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntidadTableFilterComposer(
              $db: $db,
              $table: $db.entidad,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> saldosCuentaRefs(
      Expression<bool> Function($$SaldosCuentaTableFilterComposer f) f) {
    final $$SaldosCuentaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saldosCuenta,
        getReferencedColumn: (t) => t.cuenta,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaldosCuentaTableFilterComposer(
              $db: $db,
              $table: $db.saldosCuenta,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CuentaTableOrderingComposer
    extends Composer<_$AppDatabase, $CuentaTable> {
  $$CuentaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iban => $composableBuilder(
      column: $table.iban, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tae => $composableBuilder(
      column: $table.tae, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titular => $composableBuilder(
      column: $table.titular, builder: (column) => ColumnOrderings(column));

  $$EntidadTableOrderingComposer get entidad {
    final $$EntidadTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entidad,
        referencedTable: $db.entidad,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntidadTableOrderingComposer(
              $db: $db,
              $table: $db.entidad,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CuentaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CuentaTable> {
  $$CuentaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iban =>
      $composableBuilder(column: $table.iban, builder: (column) => column);

  GeneratedColumn<double> get tae =>
      $composableBuilder(column: $table.tae, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Titular, String> get titular =>
      $composableBuilder(column: $table.titular, builder: (column) => column);

  $$EntidadTableAnnotationComposer get entidad {
    final $$EntidadTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entidad,
        referencedTable: $db.entidad,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntidadTableAnnotationComposer(
              $db: $db,
              $table: $db.entidad,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> saldosCuentaRefs<T extends Object>(
      Expression<T> Function($$SaldosCuentaTableAnnotationComposer a) f) {
    final $$SaldosCuentaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saldosCuenta,
        getReferencedColumn: (t) => t.cuenta,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaldosCuentaTableAnnotationComposer(
              $db: $db,
              $table: $db.saldosCuenta,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CuentaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CuentaTable,
    CuentaData,
    $$CuentaTableFilterComposer,
    $$CuentaTableOrderingComposer,
    $$CuentaTableAnnotationComposer,
    $$CuentaTableCreateCompanionBuilder,
    $$CuentaTableUpdateCompanionBuilder,
    (CuentaData, $$CuentaTableReferences),
    CuentaData,
    PrefetchHooks Function({bool entidad, bool saldosCuentaRefs})> {
  $$CuentaTableTableManager(_$AppDatabase db, $CuentaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CuentaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CuentaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CuentaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> iban = const Value.absent(),
            Value<double> tae = const Value.absent(),
            Value<Titular> titular = const Value.absent(),
            Value<String> entidad = const Value.absent(),
          }) =>
              CuentaCompanion(
            id: id,
            name: name,
            iban: iban,
            tae: tae,
            titular: titular,
            entidad: entidad,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String iban,
            required double tae,
            required Titular titular,
            required String entidad,
          }) =>
              CuentaCompanion.insert(
            id: id,
            name: name,
            iban: iban,
            tae: tae,
            titular: titular,
            entidad: entidad,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CuentaTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({entidad = false, saldosCuentaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (saldosCuentaRefs) db.saldosCuenta],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (entidad) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entidad,
                    referencedTable: $$CuentaTableReferences._entidadTable(db),
                    referencedColumn:
                        $$CuentaTableReferences._entidadTable(db).name,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saldosCuentaRefs)
                    await $_getPrefetchedData<CuentaData, $CuentaTable,
                            SaldosCuentaData>(
                        currentTable: table,
                        referencedTable:
                            $$CuentaTableReferences._saldosCuentaRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CuentaTableReferences(db, table, p0)
                                .saldosCuentaRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cuenta == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CuentaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CuentaTable,
    CuentaData,
    $$CuentaTableFilterComposer,
    $$CuentaTableOrderingComposer,
    $$CuentaTableAnnotationComposer,
    $$CuentaTableCreateCompanionBuilder,
    $$CuentaTableUpdateCompanionBuilder,
    (CuentaData, $$CuentaTableReferences),
    CuentaData,
    PrefetchHooks Function({bool entidad, bool saldosCuentaRefs})>;
typedef $$SaldosCuentaTableCreateCompanionBuilder = SaldosCuentaCompanion
    Function({
  Value<int> id,
  Value<int?> cuenta,
  required DateTime fecha,
  required double saldo,
});
typedef $$SaldosCuentaTableUpdateCompanionBuilder = SaldosCuentaCompanion
    Function({
  Value<int> id,
  Value<int?> cuenta,
  Value<DateTime> fecha,
  Value<double> saldo,
});

final class $$SaldosCuentaTableReferences extends BaseReferences<_$AppDatabase,
    $SaldosCuentaTable, SaldosCuentaData> {
  $$SaldosCuentaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CuentaTable _cuentaTable(_$AppDatabase db) => db.cuenta
      .createAlias($_aliasNameGenerator(db.saldosCuenta.cuenta, db.cuenta.id));

  $$CuentaTableProcessedTableManager? get cuenta {
    final $_column = $_itemColumn<int>('cuenta');
    if ($_column == null) return null;
    final manager = $$CuentaTableTableManager($_db, $_db.cuenta)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cuentaTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SaldosCuentaTableFilterComposer
    extends Composer<_$AppDatabase, $SaldosCuentaTable> {
  $$SaldosCuentaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get saldo => $composableBuilder(
      column: $table.saldo, builder: (column) => ColumnFilters(column));

  $$CuentaTableFilterComposer get cuenta {
    final $$CuentaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cuenta,
        referencedTable: $db.cuenta,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CuentaTableFilterComposer(
              $db: $db,
              $table: $db.cuenta,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaldosCuentaTableOrderingComposer
    extends Composer<_$AppDatabase, $SaldosCuentaTable> {
  $$SaldosCuentaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get saldo => $composableBuilder(
      column: $table.saldo, builder: (column) => ColumnOrderings(column));

  $$CuentaTableOrderingComposer get cuenta {
    final $$CuentaTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cuenta,
        referencedTable: $db.cuenta,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CuentaTableOrderingComposer(
              $db: $db,
              $table: $db.cuenta,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaldosCuentaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaldosCuentaTable> {
  $$SaldosCuentaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get saldo =>
      $composableBuilder(column: $table.saldo, builder: (column) => column);

  $$CuentaTableAnnotationComposer get cuenta {
    final $$CuentaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cuenta,
        referencedTable: $db.cuenta,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CuentaTableAnnotationComposer(
              $db: $db,
              $table: $db.cuenta,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaldosCuentaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaldosCuentaTable,
    SaldosCuentaData,
    $$SaldosCuentaTableFilterComposer,
    $$SaldosCuentaTableOrderingComposer,
    $$SaldosCuentaTableAnnotationComposer,
    $$SaldosCuentaTableCreateCompanionBuilder,
    $$SaldosCuentaTableUpdateCompanionBuilder,
    (SaldosCuentaData, $$SaldosCuentaTableReferences),
    SaldosCuentaData,
    PrefetchHooks Function({bool cuenta})> {
  $$SaldosCuentaTableTableManager(_$AppDatabase db, $SaldosCuentaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaldosCuentaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaldosCuentaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaldosCuentaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> cuenta = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<double> saldo = const Value.absent(),
          }) =>
              SaldosCuentaCompanion(
            id: id,
            cuenta: cuenta,
            fecha: fecha,
            saldo: saldo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> cuenta = const Value.absent(),
            required DateTime fecha,
            required double saldo,
          }) =>
              SaldosCuentaCompanion.insert(
            id: id,
            cuenta: cuenta,
            fecha: fecha,
            saldo: saldo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SaldosCuentaTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({cuenta = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cuenta) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cuenta,
                    referencedTable:
                        $$SaldosCuentaTableReferences._cuentaTable(db),
                    referencedColumn:
                        $$SaldosCuentaTableReferences._cuentaTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SaldosCuentaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SaldosCuentaTable,
    SaldosCuentaData,
    $$SaldosCuentaTableFilterComposer,
    $$SaldosCuentaTableOrderingComposer,
    $$SaldosCuentaTableAnnotationComposer,
    $$SaldosCuentaTableCreateCompanionBuilder,
    $$SaldosCuentaTableUpdateCompanionBuilder,
    (SaldosCuentaData, $$SaldosCuentaTableReferences),
    SaldosCuentaData,
    PrefetchHooks Function({bool cuenta})>;
typedef $$DepositoTableCreateCompanionBuilder = DepositoCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> codigo,
  required double imposicion,
  required bool renovacion,
  required DateTime inicio,
  required DateTime vencimiento,
  required double tae,
  required Titular titular,
  required String entidad,
});
typedef $$DepositoTableUpdateCompanionBuilder = DepositoCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> codigo,
  Value<double> imposicion,
  Value<bool> renovacion,
  Value<DateTime> inicio,
  Value<DateTime> vencimiento,
  Value<double> tae,
  Value<Titular> titular,
  Value<String> entidad,
});

final class $$DepositoTableReferences
    extends BaseReferences<_$AppDatabase, $DepositoTable, DepositoData> {
  $$DepositoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntidadTable _entidadTable(_$AppDatabase db) => db.entidad
      .createAlias($_aliasNameGenerator(db.deposito.entidad, db.entidad.name));

  $$EntidadTableProcessedTableManager get entidad {
    final $_column = $_itemColumn<String>('entidad')!;

    final manager = $$EntidadTableTableManager($_db, $_db.entidad)
        .filter((f) => f.name.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entidadTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DepositoTableFilterComposer
    extends Composer<_$AppDatabase, $DepositoTable> {
  $$DepositoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get imposicion => $composableBuilder(
      column: $table.imposicion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get renovacion => $composableBuilder(
      column: $table.renovacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get inicio => $composableBuilder(
      column: $table.inicio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get vencimiento => $composableBuilder(
      column: $table.vencimiento, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tae => $composableBuilder(
      column: $table.tae, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Titular, Titular, String> get titular =>
      $composableBuilder(
          column: $table.titular,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$EntidadTableFilterComposer get entidad {
    final $$EntidadTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entidad,
        referencedTable: $db.entidad,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntidadTableFilterComposer(
              $db: $db,
              $table: $db.entidad,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DepositoTableOrderingComposer
    extends Composer<_$AppDatabase, $DepositoTable> {
  $$DepositoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get imposicion => $composableBuilder(
      column: $table.imposicion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get renovacion => $composableBuilder(
      column: $table.renovacion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get inicio => $composableBuilder(
      column: $table.inicio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get vencimiento => $composableBuilder(
      column: $table.vencimiento, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tae => $composableBuilder(
      column: $table.tae, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titular => $composableBuilder(
      column: $table.titular, builder: (column) => ColumnOrderings(column));

  $$EntidadTableOrderingComposer get entidad {
    final $$EntidadTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entidad,
        referencedTable: $db.entidad,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntidadTableOrderingComposer(
              $db: $db,
              $table: $db.entidad,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DepositoTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepositoTable> {
  $$DepositoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<double> get imposicion => $composableBuilder(
      column: $table.imposicion, builder: (column) => column);

  GeneratedColumn<bool> get renovacion => $composableBuilder(
      column: $table.renovacion, builder: (column) => column);

  GeneratedColumn<DateTime> get inicio =>
      $composableBuilder(column: $table.inicio, builder: (column) => column);

  GeneratedColumn<DateTime> get vencimiento => $composableBuilder(
      column: $table.vencimiento, builder: (column) => column);

  GeneratedColumn<double> get tae =>
      $composableBuilder(column: $table.tae, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Titular, String> get titular =>
      $composableBuilder(column: $table.titular, builder: (column) => column);

  $$EntidadTableAnnotationComposer get entidad {
    final $$EntidadTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entidad,
        referencedTable: $db.entidad,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntidadTableAnnotationComposer(
              $db: $db,
              $table: $db.entidad,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DepositoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DepositoTable,
    DepositoData,
    $$DepositoTableFilterComposer,
    $$DepositoTableOrderingComposer,
    $$DepositoTableAnnotationComposer,
    $$DepositoTableCreateCompanionBuilder,
    $$DepositoTableUpdateCompanionBuilder,
    (DepositoData, $$DepositoTableReferences),
    DepositoData,
    PrefetchHooks Function({bool entidad})> {
  $$DepositoTableTableManager(_$AppDatabase db, $DepositoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepositoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepositoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepositoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> codigo = const Value.absent(),
            Value<double> imposicion = const Value.absent(),
            Value<bool> renovacion = const Value.absent(),
            Value<DateTime> inicio = const Value.absent(),
            Value<DateTime> vencimiento = const Value.absent(),
            Value<double> tae = const Value.absent(),
            Value<Titular> titular = const Value.absent(),
            Value<String> entidad = const Value.absent(),
          }) =>
              DepositoCompanion(
            id: id,
            name: name,
            codigo: codigo,
            imposicion: imposicion,
            renovacion: renovacion,
            inicio: inicio,
            vencimiento: vencimiento,
            tae: tae,
            titular: titular,
            entidad: entidad,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> codigo = const Value.absent(),
            required double imposicion,
            required bool renovacion,
            required DateTime inicio,
            required DateTime vencimiento,
            required double tae,
            required Titular titular,
            required String entidad,
          }) =>
              DepositoCompanion.insert(
            id: id,
            name: name,
            codigo: codigo,
            imposicion: imposicion,
            renovacion: renovacion,
            inicio: inicio,
            vencimiento: vencimiento,
            tae: tae,
            titular: titular,
            entidad: entidad,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DepositoTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({entidad = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (entidad) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entidad,
                    referencedTable:
                        $$DepositoTableReferences._entidadTable(db),
                    referencedColumn:
                        $$DepositoTableReferences._entidadTable(db).name,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DepositoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DepositoTable,
    DepositoData,
    $$DepositoTableFilterComposer,
    $$DepositoTableOrderingComposer,
    $$DepositoTableAnnotationComposer,
    $$DepositoTableCreateCompanionBuilder,
    $$DepositoTableUpdateCompanionBuilder,
    (DepositoData, $$DepositoTableReferences),
    DepositoData,
    PrefetchHooks Function({bool entidad})>;
typedef $$FondoTableCreateCompanionBuilder = FondoCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> isin,
  required double participaciones,
  required double valorInicial,
  required DateTime fechaInicial,
  required Titular titular,
  required String entidad,
});
typedef $$FondoTableUpdateCompanionBuilder = FondoCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> isin,
  Value<double> participaciones,
  Value<double> valorInicial,
  Value<DateTime> fechaInicial,
  Value<Titular> titular,
  Value<String> entidad,
});

final class $$FondoTableReferences
    extends BaseReferences<_$AppDatabase, $FondoTable, FondoData> {
  $$FondoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntidadTable _entidadTable(_$AppDatabase db) => db.entidad
      .createAlias($_aliasNameGenerator(db.fondo.entidad, db.entidad.name));

  $$EntidadTableProcessedTableManager get entidad {
    final $_column = $_itemColumn<String>('entidad')!;

    final manager = $$EntidadTableTableManager($_db, $_db.entidad)
        .filter((f) => f.name.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entidadTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ValoresFondoTable, List<ValoresFondoData>>
      _valoresFondoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.valoresFondo,
          aliasName: $_aliasNameGenerator(db.fondo.id, db.valoresFondo.fondo));

  $$ValoresFondoTableProcessedTableManager get valoresFondoRefs {
    final manager = $$ValoresFondoTableTableManager($_db, $_db.valoresFondo)
        .filter((f) => f.fondo.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_valoresFondoRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FondoTableFilterComposer extends Composer<_$AppDatabase, $FondoTable> {
  $$FondoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get isin => $composableBuilder(
      column: $table.isin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get participaciones => $composableBuilder(
      column: $table.participaciones,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valorInicial => $composableBuilder(
      column: $table.valorInicial, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaInicial => $composableBuilder(
      column: $table.fechaInicial, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Titular, Titular, String> get titular =>
      $composableBuilder(
          column: $table.titular,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$EntidadTableFilterComposer get entidad {
    final $$EntidadTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entidad,
        referencedTable: $db.entidad,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntidadTableFilterComposer(
              $db: $db,
              $table: $db.entidad,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> valoresFondoRefs(
      Expression<bool> Function($$ValoresFondoTableFilterComposer f) f) {
    final $$ValoresFondoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.valoresFondo,
        getReferencedColumn: (t) => t.fondo,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ValoresFondoTableFilterComposer(
              $db: $db,
              $table: $db.valoresFondo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FondoTableOrderingComposer
    extends Composer<_$AppDatabase, $FondoTable> {
  $$FondoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get isin => $composableBuilder(
      column: $table.isin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get participaciones => $composableBuilder(
      column: $table.participaciones,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valorInicial => $composableBuilder(
      column: $table.valorInicial,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaInicial => $composableBuilder(
      column: $table.fechaInicial,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titular => $composableBuilder(
      column: $table.titular, builder: (column) => ColumnOrderings(column));

  $$EntidadTableOrderingComposer get entidad {
    final $$EntidadTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entidad,
        referencedTable: $db.entidad,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntidadTableOrderingComposer(
              $db: $db,
              $table: $db.entidad,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FondoTableAnnotationComposer
    extends Composer<_$AppDatabase, $FondoTable> {
  $$FondoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get isin =>
      $composableBuilder(column: $table.isin, builder: (column) => column);

  GeneratedColumn<double> get participaciones => $composableBuilder(
      column: $table.participaciones, builder: (column) => column);

  GeneratedColumn<double> get valorInicial => $composableBuilder(
      column: $table.valorInicial, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInicial => $composableBuilder(
      column: $table.fechaInicial, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Titular, String> get titular =>
      $composableBuilder(column: $table.titular, builder: (column) => column);

  $$EntidadTableAnnotationComposer get entidad {
    final $$EntidadTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entidad,
        referencedTable: $db.entidad,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntidadTableAnnotationComposer(
              $db: $db,
              $table: $db.entidad,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> valoresFondoRefs<T extends Object>(
      Expression<T> Function($$ValoresFondoTableAnnotationComposer a) f) {
    final $$ValoresFondoTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.valoresFondo,
        getReferencedColumn: (t) => t.fondo,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ValoresFondoTableAnnotationComposer(
              $db: $db,
              $table: $db.valoresFondo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FondoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FondoTable,
    FondoData,
    $$FondoTableFilterComposer,
    $$FondoTableOrderingComposer,
    $$FondoTableAnnotationComposer,
    $$FondoTableCreateCompanionBuilder,
    $$FondoTableUpdateCompanionBuilder,
    (FondoData, $$FondoTableReferences),
    FondoData,
    PrefetchHooks Function({bool entidad, bool valoresFondoRefs})> {
  $$FondoTableTableManager(_$AppDatabase db, $FondoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FondoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FondoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FondoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> isin = const Value.absent(),
            Value<double> participaciones = const Value.absent(),
            Value<double> valorInicial = const Value.absent(),
            Value<DateTime> fechaInicial = const Value.absent(),
            Value<Titular> titular = const Value.absent(),
            Value<String> entidad = const Value.absent(),
          }) =>
              FondoCompanion(
            id: id,
            name: name,
            isin: isin,
            participaciones: participaciones,
            valorInicial: valorInicial,
            fechaInicial: fechaInicial,
            titular: titular,
            entidad: entidad,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> isin = const Value.absent(),
            required double participaciones,
            required double valorInicial,
            required DateTime fechaInicial,
            required Titular titular,
            required String entidad,
          }) =>
              FondoCompanion.insert(
            id: id,
            name: name,
            isin: isin,
            participaciones: participaciones,
            valorInicial: valorInicial,
            fechaInicial: fechaInicial,
            titular: titular,
            entidad: entidad,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$FondoTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({entidad = false, valoresFondoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (valoresFondoRefs) db.valoresFondo],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (entidad) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entidad,
                    referencedTable: $$FondoTableReferences._entidadTable(db),
                    referencedColumn:
                        $$FondoTableReferences._entidadTable(db).name,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (valoresFondoRefs)
                    await $_getPrefetchedData<FondoData, $FondoTable,
                            ValoresFondoData>(
                        currentTable: table,
                        referencedTable:
                            $$FondoTableReferences._valoresFondoRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FondoTableReferences(db, table, p0)
                                .valoresFondoRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.fondo == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FondoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FondoTable,
    FondoData,
    $$FondoTableFilterComposer,
    $$FondoTableOrderingComposer,
    $$FondoTableAnnotationComposer,
    $$FondoTableCreateCompanionBuilder,
    $$FondoTableUpdateCompanionBuilder,
    (FondoData, $$FondoTableReferences),
    FondoData,
    PrefetchHooks Function({bool entidad, bool valoresFondoRefs})>;
typedef $$ValoresFondoTableCreateCompanionBuilder = ValoresFondoCompanion
    Function({
  Value<int> id,
  Value<int?> fondo,
  required DateTime fecha,
  required double valor,
  Value<TipoOp?> tipo,
  Value<double?> participaciones,
});
typedef $$ValoresFondoTableUpdateCompanionBuilder = ValoresFondoCompanion
    Function({
  Value<int> id,
  Value<int?> fondo,
  Value<DateTime> fecha,
  Value<double> valor,
  Value<TipoOp?> tipo,
  Value<double?> participaciones,
});

final class $$ValoresFondoTableReferences extends BaseReferences<_$AppDatabase,
    $ValoresFondoTable, ValoresFondoData> {
  $$ValoresFondoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FondoTable _fondoTable(_$AppDatabase db) => db.fondo
      .createAlias($_aliasNameGenerator(db.valoresFondo.fondo, db.fondo.id));

  $$FondoTableProcessedTableManager? get fondo {
    final $_column = $_itemColumn<int>('fondo');
    if ($_column == null) return null;
    final manager = $$FondoTableTableManager($_db, $_db.fondo)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fondoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ValoresFondoTableFilterComposer
    extends Composer<_$AppDatabase, $ValoresFondoTable> {
  $$ValoresFondoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TipoOp?, TipoOp, String> get tipo =>
      $composableBuilder(
          column: $table.tipo,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get participaciones => $composableBuilder(
      column: $table.participaciones,
      builder: (column) => ColumnFilters(column));

  $$FondoTableFilterComposer get fondo {
    final $$FondoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fondo,
        referencedTable: $db.fondo,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FondoTableFilterComposer(
              $db: $db,
              $table: $db.fondo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ValoresFondoTableOrderingComposer
    extends Composer<_$AppDatabase, $ValoresFondoTable> {
  $$ValoresFondoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get participaciones => $composableBuilder(
      column: $table.participaciones,
      builder: (column) => ColumnOrderings(column));

  $$FondoTableOrderingComposer get fondo {
    final $$FondoTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fondo,
        referencedTable: $db.fondo,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FondoTableOrderingComposer(
              $db: $db,
              $table: $db.fondo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ValoresFondoTableAnnotationComposer
    extends Composer<_$AppDatabase, $ValoresFondoTable> {
  $$ValoresFondoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoOp?, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get participaciones => $composableBuilder(
      column: $table.participaciones, builder: (column) => column);

  $$FondoTableAnnotationComposer get fondo {
    final $$FondoTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fondo,
        referencedTable: $db.fondo,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FondoTableAnnotationComposer(
              $db: $db,
              $table: $db.fondo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ValoresFondoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ValoresFondoTable,
    ValoresFondoData,
    $$ValoresFondoTableFilterComposer,
    $$ValoresFondoTableOrderingComposer,
    $$ValoresFondoTableAnnotationComposer,
    $$ValoresFondoTableCreateCompanionBuilder,
    $$ValoresFondoTableUpdateCompanionBuilder,
    (ValoresFondoData, $$ValoresFondoTableReferences),
    ValoresFondoData,
    PrefetchHooks Function({bool fondo})> {
  $$ValoresFondoTableTableManager(_$AppDatabase db, $ValoresFondoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ValoresFondoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ValoresFondoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ValoresFondoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> fondo = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<double> valor = const Value.absent(),
            Value<TipoOp?> tipo = const Value.absent(),
            Value<double?> participaciones = const Value.absent(),
          }) =>
              ValoresFondoCompanion(
            id: id,
            fondo: fondo,
            fecha: fecha,
            valor: valor,
            tipo: tipo,
            participaciones: participaciones,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> fondo = const Value.absent(),
            required DateTime fecha,
            required double valor,
            Value<TipoOp?> tipo = const Value.absent(),
            Value<double?> participaciones = const Value.absent(),
          }) =>
              ValoresFondoCompanion.insert(
            id: id,
            fondo: fondo,
            fecha: fecha,
            valor: valor,
            tipo: tipo,
            participaciones: participaciones,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ValoresFondoTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({fondo = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (fondo) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.fondo,
                    referencedTable:
                        $$ValoresFondoTableReferences._fondoTable(db),
                    referencedColumn:
                        $$ValoresFondoTableReferences._fondoTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ValoresFondoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ValoresFondoTable,
    ValoresFondoData,
    $$ValoresFondoTableFilterComposer,
    $$ValoresFondoTableOrderingComposer,
    $$ValoresFondoTableAnnotationComposer,
    $$ValoresFondoTableCreateCompanionBuilder,
    $$ValoresFondoTableUpdateCompanionBuilder,
    (ValoresFondoData, $$ValoresFondoTableReferences),
    ValoresFondoData,
    PrefetchHooks Function({bool fondo})>;
typedef $$HistoricoTableCreateCompanionBuilder = HistoricoCompanion Function({
  Value<int> id,
  required DateTime fecha,
  required double totalCuentas,
  required double totalDepositos,
  required double totalFondos,
});
typedef $$HistoricoTableUpdateCompanionBuilder = HistoricoCompanion Function({
  Value<int> id,
  Value<DateTime> fecha,
  Value<double> totalCuentas,
  Value<double> totalDepositos,
  Value<double> totalFondos,
});

class $$HistoricoTableFilterComposer
    extends Composer<_$AppDatabase, $HistoricoTable> {
  $$HistoricoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCuentas => $composableBuilder(
      column: $table.totalCuentas, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalDepositos => $composableBuilder(
      column: $table.totalDepositos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalFondos => $composableBuilder(
      column: $table.totalFondos, builder: (column) => ColumnFilters(column));
}

class $$HistoricoTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoricoTable> {
  $$HistoricoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCuentas => $composableBuilder(
      column: $table.totalCuentas,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalDepositos => $composableBuilder(
      column: $table.totalDepositos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalFondos => $composableBuilder(
      column: $table.totalFondos, builder: (column) => ColumnOrderings(column));
}

class $$HistoricoTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoricoTable> {
  $$HistoricoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get totalCuentas => $composableBuilder(
      column: $table.totalCuentas, builder: (column) => column);

  GeneratedColumn<double> get totalDepositos => $composableBuilder(
      column: $table.totalDepositos, builder: (column) => column);

  GeneratedColumn<double> get totalFondos => $composableBuilder(
      column: $table.totalFondos, builder: (column) => column);
}

class $$HistoricoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoricoTable,
    HistoricoData,
    $$HistoricoTableFilterComposer,
    $$HistoricoTableOrderingComposer,
    $$HistoricoTableAnnotationComposer,
    $$HistoricoTableCreateCompanionBuilder,
    $$HistoricoTableUpdateCompanionBuilder,
    (
      HistoricoData,
      BaseReferences<_$AppDatabase, $HistoricoTable, HistoricoData>
    ),
    HistoricoData,
    PrefetchHooks Function()> {
  $$HistoricoTableTableManager(_$AppDatabase db, $HistoricoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoricoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoricoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoricoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<double> totalCuentas = const Value.absent(),
            Value<double> totalDepositos = const Value.absent(),
            Value<double> totalFondos = const Value.absent(),
          }) =>
              HistoricoCompanion(
            id: id,
            fecha: fecha,
            totalCuentas: totalCuentas,
            totalDepositos: totalDepositos,
            totalFondos: totalFondos,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime fecha,
            required double totalCuentas,
            required double totalDepositos,
            required double totalFondos,
          }) =>
              HistoricoCompanion.insert(
            id: id,
            fecha: fecha,
            totalCuentas: totalCuentas,
            totalDepositos: totalDepositos,
            totalFondos: totalFondos,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HistoricoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HistoricoTable,
    HistoricoData,
    $$HistoricoTableFilterComposer,
    $$HistoricoTableOrderingComposer,
    $$HistoricoTableAnnotationComposer,
    $$HistoricoTableCreateCompanionBuilder,
    $$HistoricoTableUpdateCompanionBuilder,
    (
      HistoricoData,
      BaseReferences<_$AppDatabase, $HistoricoTable, HistoricoData>
    ),
    HistoricoData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EntidadTableTableManager get entidad =>
      $$EntidadTableTableManager(_db, _db.entidad);
  $$CuentaTableTableManager get cuenta =>
      $$CuentaTableTableManager(_db, _db.cuenta);
  $$SaldosCuentaTableTableManager get saldosCuenta =>
      $$SaldosCuentaTableTableManager(_db, _db.saldosCuenta);
  $$DepositoTableTableManager get deposito =>
      $$DepositoTableTableManager(_db, _db.deposito);
  $$FondoTableTableManager get fondo =>
      $$FondoTableTableManager(_db, _db.fondo);
  $$ValoresFondoTableTableManager get valoresFondo =>
      $$ValoresFondoTableTableManager(_db, _db.valoresFondo);
  $$HistoricoTableTableManager get historico =>
      $$HistoricoTableTableManager(_db, _db.historico);
}
