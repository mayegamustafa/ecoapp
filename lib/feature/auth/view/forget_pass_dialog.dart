import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/auth/view/registration_page.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgetPassDialog extends HookConsumerWidget {
  const ForgetPassDialog({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final emailCtrl = useTextEditingController();
    final otpCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final confirmPassCtrl = useTextEditingController();

    final isLoading = useState(false);
    final showPassBoxes = useState(false);
    final showOTPBox = useState(false);

    final isWorking = showOTPBox.value || showPassBoxes.value;

    void toggleLoading(bool v) => isLoading.value = v;
    final tr = context.tr;
    useEffect(() {
      emailCtrl.text = email;
      return null;
    }, const []);

    String getButtonText() {
      if (showOTPBox.value) {
        return tr.verify_otp;
      }
      if (showPassBoxes.value) {
        return tr.resetPass;
      }
      return tr.sendOTP;
    }

    return AlertDialog(
      insetPadding: const EdgeInsets.all(30),
      title: Text(tr.resetPass),
      content: SingleChildScrollView(
        child: FormBuilder(
          key: formKey,
          child: SizedBox(
            width: context.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!showOTPBox.value && !showPassBoxes.value) ...[
                  Text(tr.sendToEmailText),
                  const SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'email',
                    controller: emailCtrl,
                    autofillHints: AutoFillHintList.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail_outline_rounded,
                      ),
                      hintText: context.tr.enterEmail,
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                  ),
                ],
                if (showOTPBox.value) ...[
                  Text(
                    tr.otp,
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'otp',
                    controller: otpCtrl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: context.tr.enterOtp,
                    ),
                  ),
                ],
                if (showPassBoxes.value) ...[
                  Text(
                    tr.password,
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  PassField(
                    name: 'password',
                    ctrl: passwordCtrl,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tr.confirm_password,
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  PassField(
                    name: 'password_confirmation',
                    ctrl: confirmPassCtrl,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (!isWorking) return context.nPop();

            final result = await showDialog(
              context: context,
              builder: (context) => const _Cancellation(),
            );
            if (context.mounted && result == true) context.nPop();
          },
          child: Text(tr.cancel),
        ),
        SubmitButton(
          height: 40,
          isLoading: isLoading.value,
          onPressed: () async {
            final state = formKey.currentState;
            final isValid = state?.saveAndValidate() ?? false;
            if (showOTPBox.value) {
              if (!isValid) return;
              toggleLoading(true);

              final isOtpOk = await authCtrl()
                  .passwordResetVerification(emailCtrl.text, otpCtrl.text);
              if (isOtpOk) {
                showPassBoxes.value = true;
                showOTPBox.value = false;
              }
            } else if (showPassBoxes.value) {
              if (!isValid) return;
              toggleLoading(true);

              final didSucceed = await authCtrl().resetPassword(
                emailCtrl.text,
                otpCtrl.text,
                passwordCtrl.text,
                confirmPassCtrl.text,
              );

              if (context.mounted && didSucceed) {
                toggleLoading(false);
                context.nPop();
              }
            } else {
              if (!isValid) return;
              toggleLoading(true);

              final didOtpSent =
                  await authCtrl().forgetPassword(emailCtrl.text);
              if (didOtpSent) showOTPBox.value = true;
            }
            toggleLoading(false);
          },
          child: Text(getButtonText()),
        ),
      ],
    );
  }
}

class _Cancellation extends StatelessWidget {
  const _Cancellation();

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return AlertDialog(
      title: Text(tr.are_you_sure),
      insetPadding: const EdgeInsets.all(15),
      content: Text(tr.confirmCancel),
      actions: [
        TextButton(
          onPressed: () => context.nPop(),
          child: Text(tr.no),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: context.colors.error.withOpacity(.1),
          ),
          onPressed: () => context.nPop(true),
          child: Text(tr.yes),
        ),
      ],
    );
  }
}
