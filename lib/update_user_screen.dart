import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';
import 'user_provider.dart';

class UpdateUserScreen extends ConsumerStatefulWidget {
  final UserModel user;
  UpdateUserScreen({required this.user});

  @override
  ConsumerState<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends ConsumerState<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String email;
  late int age;

  @override
  void initState() {
    super.initState();
    name = widget.user.name;
    email = widget.user.email;
    age = widget.user.age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update User')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => name = value ?? '',
              ),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value ?? '',
              ),
              TextFormField(
                initialValue: age.toString(),
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (value) => age = int.tryParse(value ?? '0') ?? 0,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState?.save();
                  final service = ref.read(userServiceProvider);
                  await service.updateUser(UserModel(
                    id: widget.user.id,
                    name: name,
                    email: email,
                    age: age,
                  ));
                  ref.invalidate(userListProvider);
                  Navigator.pop(context);
                },
                child: Text('Update'),
              )
            ],
          ),
        ),
      ),
    );
  }
}