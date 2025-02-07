import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/organization/bloc/org_bloc.dart';
import 'package:help_match/features/organization/dto/job_add_dto.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';
import 'package:help_match/shared/widgets/snack_bar.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final String title = _titleController.text;
      final String description = _descriptionController.text;
      context.read<OrgBloc>().add(
            OrgJobAdded(
              JobDto(title: title, description: description),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrgBloc, OrgState>(
      listener: (context, state) {
        if (state is OrgJobAddSuccess) {
          showCustomSnackBar(
              context: context,
              message: "successfully add a new job",
              color: Colors.green);
        } else if (state is OrgJobAddFailure) {
          showCustomSnackBar(
              context: context,
              message: "successfully add a new job",
              color: Colors.red);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Job'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                GradientButton(
                    text: 'Add New Job',
                    onPressed: () {
                      _submitForm();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
