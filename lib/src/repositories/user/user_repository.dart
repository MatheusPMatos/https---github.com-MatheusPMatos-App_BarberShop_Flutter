import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../model/user_model.dart';

abstract interface class UserRepository {

Future<Either<AuthException, String>> login(String email, String password);

Future<Either<RepositoryException, UserModel>> me();

Future<Either<RepositoryException, Nil>> registerAdm(({
  String name,
  String email,
  String password
}) userData);

Future<Either<RepositoryException, List<UserModel>>> getEmployees (int barberchopid);

Future<Either<RepositoryException, Nil>> registerAdmAsEmployee (({
List<String> workdays,
List<int> workHours
}) userModel);

Future<Either<RepositoryException, Nil>> registerEmployee (({
int barbershopId,
String name,
String email,
String password,
List<String> workdays,
List<int> workHours
}) userModel);

}