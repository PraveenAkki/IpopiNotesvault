import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return remoteDataSource.signUp(name: name, email: email, password: password);
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> logout() => remoteDataSource.logout();

  @override
  UserEntity? get currentUser => remoteDataSource.currentUser;
}