import 'package:finity/features/home/bloc/item_bloc/bloc/item_bloc.dart';
import 'package:finity/features/home/ui/pages/display_items_screen.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
// Import your BLoC files here

void showAddItemDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddItemDialog();
    },
  );
}

class ResponsiveCardLayout extends StatelessWidget {
  const ResponsiveCardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    void showAddItemDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddItemDialog();
        },
      );
    }

    // Get the total height of the screen
    final double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Add padding or other widgets here if needed
        SizedBox(
          height:
              screenHeight * 0.1, // Set the height to 10% of the screen height
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showAddItemDialog(context);
                  },
                  child: Card(
                    color: Colors.blue,
                    child: Center(
                      child: Text('Lend'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0), // Space between the two cards
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(DisplayItemsScreen.routeName);
                  },
                  child: Card(
                    color: Colors.blue,
                    child: Center(
                      child: Text('Borrow'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Add more widgets here if needed
      ],
    );
  }
}

class AddItemDialog extends StatefulWidget {
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _category = '';
  DateTime? _dueDate;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemSuccess) {
          Navigator.of(context).pop(); // Close the dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item added successfully')),
          );
        } else if (state is ItemError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add Item',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter item name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter item description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _description = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        hintText: 'Enter item category',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _category = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Due Date',
                        hintText: 'Select due date',
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _dueDate = pickedDate;
                          });
                        }
                      },
                      validator: (value) {
                        if (_dueDate == null) {
                          return 'Please select a due date';
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: _dueDate != null
                            ? _dueDate!.toLocal().toString().split(' ')[0]
                            : '',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          BlocProvider.of<ItemBloc>(context).add(
                            AddItemEvent(
                              userId: Provider.of<UserProvider>(context,
                                      listen: false)
                                  .user
                                  .id, // Replace with actual userId
                              itemName: _name,
                              description: _description,
                              itemCategory: _category,
                              dueDate: _dueDate ?? DateTime.now(),
                            ),
                          );
                        }
                      },
                      child: state is ItemLoading
                          ? CircularProgressIndicator()
                          : Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
