import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'user_model.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final uuid = Uuid();

  Future<void> createUser(String name, String email, int age) async {
    final user = UserModel(
      id: uuid.v4(),
      name: name,
      email: email,
      age: age,
    );
    await usersCollection.doc(user.id).set(user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    await usersCollection.doc(user.id).update(user.toMap());
  }

  Future<List<UserModel>> getAllUsers() async {
    final query = await usersCollection.get();
    return query.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteUser(String id) async {
    await usersCollection.doc(id).delete();
  }
}