import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/support_ticket/controller/support_ticket_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateTicketView extends HookConsumerWidget {
  const CreateTicketView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDash = ref.watch(userDashProvider);
    final ticketData = ref.watch(ticketCreationProvider);
    final ticketCtrl =
        useCallback(() => ref.read(ticketCreationProvider.notifier));

    final nameCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final subjectCtrl = useTextEditingController();
    final messageCtrl = useTextEditingController();

    useEffect(() {
      if (userDash == null) return;
      nameCtrl.text = userDash.user.name;
      emailCtrl.text = userDash.user.email;
      return null;
    }, const []);
    final tr = context.tr;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.create_ticket,
        ),
      ),
      body: Padding(
        padding: defaultPaddingAll,
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                physics: defaultScrollPhysics,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: tr.full_name,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: tr.email,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: subjectCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: tr.subject,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: messageCtrl,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: tr.message,
                        alignLabelWithHint: true,
                      ),
                    ),
                    const Divider(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr.files,
                          style: context.textTheme.titleLarge,
                        ),
                        InkWell(
                          borderRadius: defaultRadius,
                          onTap: () {
                            ticketCtrl().pickFiles();
                          },
                          child: Container(
                            padding: defaultPaddingAll,
                            decoration: BoxDecoration(
                              borderRadius: defaultRadius,
                              color: context.colors.primary.withOpacity(0.05),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  color: context.colors.primary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  tr.select,
                                  style: context.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.primary,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ticketData.files.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Corners.med),
                            side: BorderSide(
                              color: context.colors.secondaryContainer,
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.file_present_rounded,
                              size: 30,
                              color: context.colors.secondaryContainer,
                            ),
                            title: Text(
                              ticketData.files[index].path.split('/').last,
                            ),
                            trailing: IconButton(
                              style: IconButton.styleFrom(
                                foregroundColor: context.colors.error,
                              ),
                              onPressed: () => ticketCtrl().removeFile(index),
                              icon: const Icon(Icons.clear_rounded),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SubmitButton(
              onPressed: () async {
                ticketCtrl().setName(nameCtrl.text);
                ticketCtrl().setEmail(emailCtrl.text);
                ticketCtrl().setSubject(subjectCtrl.text);
                ticketCtrl().setMassage(messageCtrl.text);
                final id = await ticketCtrl().createTicket();
                if (id != null && context.mounted) {
                  RouteNames.ticketDetails
                      .goNamed(context, pathParams: {'id': id});
                }
              },
              child: Text(tr.create_ticket),
            ),
          ],
        ),
      ),
    );
  }
}
