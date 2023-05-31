import 'package:flutter/material.dart';
import 'package:todo_firebase/services/utility_services.dart';

class AddTask extends StatefulWidget {
  final String title_val;
  final String description_val;

  const AddTask(
      {Key? key, required this.title_val, required this.description_val})
      : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  FirebaseUtilityServices utility = FirebaseUtilityServices();

  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController describecontroller = TextEditingController();

  String _title = '';
  String _description = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: titlecontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Title';
                    }
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter Title",
                  )),
              const SizedBox(height: 10),
              TextFormField(
                  controller: describecontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Description';
                    }
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter Description",
                  )),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      final validate = _formKey.currentState!.validate();
                      if (validate) {
                        _formKey.currentState!.save();
                        await utility.addTask(_title.toString(),
                            _description.toString(), context);
                        titlecontroller.clear();
                        describecontroller.clear();
                      }
                    },
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.purple.shade400;
                      return Theme.of(context).primaryColor;
                    })),
                    child: const Text(
                      'Add task',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
