import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';
import 'user_service.dart';

final userServiceProvider = Provider((ref) => UserService());

final userListProvider = FutureProvider<List<UserModel>>((ref) {
  final service = ref.watch(userServiceProvider);
  return service.getAllUsers();
});