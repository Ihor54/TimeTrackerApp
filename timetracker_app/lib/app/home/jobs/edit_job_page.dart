import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker_app/app/home/models/job.dart';
import 'package:timetracker_app/common_widgets/form_submit_btn.dart';
import 'package:timetracker_app/common_widgets/show_alert_dialog.dart';
import 'package:timetracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:timetracker_app/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context, {Job? job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditJobPage(
                database: database,
                job: job,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int _ratePerHour = 0;

  @override
  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: "Job name already exists",
            content: "Please choose a different job name",
            defaultActionText: "Ok",
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: "Operation failed", exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        title: Text(widget.job == null ? 'New job' : 'Edit job'),
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      _buildNameField(),
      const SizedBox(height: 16.0),
      _buildRatePerHourField(),
      const SizedBox(height: 16.0),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        child: FormSubmitButton(
          text: 'Save',
          onPressed: _submit,
        ),
      )
    ];
  }

  Widget _buildNameField() {
    return TextFormField(
      autocorrect: false,
      initialValue: _name,
      decoration: const InputDecoration(
        labelText: 'Job name',
        hintText: 'Job 1',
      ),
      validator: (value) =>
          value != null && value.isNotEmpty ? null : 'Value cannot be empty',
      onSaved: (value) => _name = value,
    );
  }

  Widget _buildRatePerHourField() {
    return TextFormField(
      initialValue: _ratePerHour.toString(),
      decoration: const InputDecoration(
        label: Text('Rate per hour'),
        hintText: '10',
      ),
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
      validator: (value) => value != null && int.tryParse(value) != null
          ? null
          : 'Value cannot be empty and should contain only number',
      onSaved: (value) => _ratePerHour = int.parse(value!),
    );
  }
}
