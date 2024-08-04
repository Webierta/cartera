import 'package:drift/drift.dart';

import '../services/app_database.dart';

List<EntidadCompanion> entidadesList = const [
  EntidadCompanion(
    name: Value('ING'),
    bic: Value('INGDESMMXXX'),
    web: Value('https://www.ing.es'),
    phone: Value('912 066 666'),
    email: Value(''),
    logo: Value('assets/ing.png'),
  ),
  EntidadCompanion(
    name: Value('FACTO'),
    bic: Value('CIPBITM2XXX'),
    web: Value('https://www.cuentafacto.es'),
    phone: Value('900 848 022'),
    email: Value('info@cuentafacto.es'),
    logo: Value('assets/facto.jpg'),
  ),
  EntidadCompanion(
    name: Value('EBN'),
    bic: Value('PROAESMMXXX'),
    web: Value('https://www.ebnbanco.com'),
    phone: Value('918 280 911'),
    email: Value('info@ebnbanco.com'),
    logo: Value('assets/ebn.png'),
  ),
  EntidadCompanion(
    name: Value('PIBANK'),
    bic: Value('PICHESMMXXX'),
    web: Value('https://www.pibank.es'),
    phone: Value('911 110 000'),
    email: Value(''),
    logo: Value('assets/pibank.jpg'),
  ),
  EntidadCompanion(
    name: Value('RAISIN'),
    bic: Value(''),
    web: Value('https://www.raisin.es'),
    phone: Value('910 381 562'),
    email: Value('servicio@raisin.es'),
    logo: Value('assets/raisin.png'),
  ),
  EntidadCompanion(
    name: Value('HAITONG'),
    bic: Value('ESSIESMMXXX'),
    web: Value('https://www.haitongib.com'),
    phone: Value('914 005 400'),
    email: Value('info.spainbranch@haitongib.com'),
    logo: Value('assets/haitong.jpg'),
  ),
  EntidadCompanion(
    name: Value('LEA'),
    bic: Value(''),
    web: Value('https://leabank.es'),
    phone: Value('900 423 464'),
    email: Value(''),
    logo: Value('assets/lea.jpg'),
  ),
  EntidadCompanion(
    name: Value('TESORO'),
    bic: Value(''),
    web: Value('https://www.tesoropublico.gob.es/'),
    phone: Value(''),
    email: Value('consdeuda@economia.gob.es'),
    logo: Value('assets/tesoro.png'),
  ),
  EntidadCompanion(
    name: Value('RENAULT BANK'),
    bic: Value(''),
    web: Value('https://renaultbank.es/'),
    phone: Value('912 713 060'),
    email: Value('atencion.clientes@renaultbank.com'),
    logo: Value('assets/renault.jpg'),
  ),
];
