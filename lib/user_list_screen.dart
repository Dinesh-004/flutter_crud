import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';
import 'user_model.dart';
import 'create_user_screen.dart';
import 'update_user_screen.dart';

class UserListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateUserScreen()),
              );
            },
          )
        ],
      ),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(users[index].name),
            subtitle: Text(users[index].email),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UpdateUserScreen(user: users[index]),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final service = ref.read(userServiceProvider);
                await service.deleteUser(users[index].id);
                ref.refresh(userListProvider);
              },
            ),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: \$e')),
      ),
    );
  }
}