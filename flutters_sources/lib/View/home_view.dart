import 'package:crud_with_php_and_mysql/ViewModel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..fetchUsers(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                Container(
                  height: 370,
                  color: Colors.grey.shade200,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(hintText: 'Name'),
                            controller: viewModel.nameController,
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(hintText: 'Last Name'),
                            controller: viewModel.lastNameController,
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(hintText: 'Age'),
                            controller: viewModel.ageController,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          SizedBox(height: 25),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (!viewModel.isUpdateMode)
                                  ElevatedButton(
                                    onPressed: viewModel.addUser,
                                    child: Text(
                                      '  Add User  ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                if (viewModel.isUpdateMode)
                                  ElevatedButton(
                                    onPressed:
                                        viewModel.selectedUserIndex != null &&
                                            viewModel.selectedUserIndex! <
                                                viewModel.users.length
                                        ? () => viewModel.updateUser(
                                            viewModel
                                                .users[viewModel
                                                    .selectedUserIndex!]
                                                .id
                                                .toString(),
                                          )
                                        : null,
                                    child: Text(
                                      '  Update User  ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                if (viewModel.isUpdateMode)
                                  TextButton(
                                    onPressed: () {
                                      viewModel.isUpdateMode = false;
                                      viewModel.selectedUserIndex = null;
                                      viewModel.nameController.clear();
                                      viewModel.lastNameController.clear();
                                      viewModel.ageController.clear();
                                      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                      viewModel.notifyListeners();
                                    },
                                    child: Text(
                                      '  Cancel  ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'User List',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.users.length,
                    itemBuilder: (context, index) {
                      final user = viewModel.users[index];
                      return ListTile(
                        splashColor: Colors.blue,
                        leading: CircleAvatar(
                          child: Text(user.name[0].toUpperCase()),
                        ),
                        title: Text('${user.name}  ${user.lastName}'),
                        subtitle: Text('Age: ${user.age}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  viewModel.prepareForUpdate(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete User'),
                                      content: Text(
                                        'Are you sure you want to delete ${user.name}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            viewModel.deleteUser(
                                              user.id.toString(),
                                            );
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
