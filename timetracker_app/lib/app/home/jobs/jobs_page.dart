import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker_app/app/home/jobs/edit_job_page.dart';
import 'package:timetracker_app/app/home/jobs/job_list_tile.dart';
import 'package:timetracker_app/app/home/models/job.dart';
import 'package:timetracker_app/common_widgets/show_alert_dialog.dart';
import 'package:timetracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:timetracker_app/services/auth_base.dart';
import 'package:timetracker_app/services/database.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    bool? didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    );
    if (didRequestSignOut != null && didRequestSignOut) {
      _signOut(context);
    }
  }

  // Future<void> _createJob(BuildContext context) async {
  //   final database = Provider.of<Database>(context, listen: false);
  //   try {
  //     await database.setJob(Job(name: 'Learning', ratePerHour: 15));
  //   } on FirebaseException catch (e) {
  //     showExceptionAlertDialog(
  //       context,
  //       title: 'Operation failed',
  //       exception: e,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Text(
              'Sign out',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          )
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => EditJobPage.show(context)
          //_createJob(context),
          ),
    );
  }
}

Widget _buildContents(BuildContext context) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Job>>(
    stream: database.jobsStream(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final jobs = snapshot.data!;
        final listItems = jobs
            .map((job) => JobListTile(
                  job: job,
                  onTap: () => EditJobPage.show(context, job: job),
                ))
            .toList();
        return ListView(children: listItems);
      }
      if (snapshot.hasError) {
        return const Center(child: Text('Some error occurred'));
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}
