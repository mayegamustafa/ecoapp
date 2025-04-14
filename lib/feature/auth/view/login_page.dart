import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/auth/view/forget_pass_dialog.dart';
import 'package:e_com/feature/auth/view/registration_page.dart';
import 'package:e_com/feature/auth/view/social_login_buttons.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final config = ref.watch(settingsCtrlProvider);

    final emailCtrl = useTextEditingController();
    final passCtrl = useTextEditingController();
    final otpCtrl = useTextEditingController();
    final configLoaded = useState(false);

    final loadingManual = useState(false);

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final showOTPBox = useState(false);
    useEffect(
      () {
        emailCtrl.text = 'demo@cartuser.test';
        passCtrl.text = '123123';

        Future.delayed(0.ms, () async {
          await ref.read(settingsCtrlProvider.notifier).reloadSilently();
          configLoaded.value = true;
        });
        return null;
      },
      const [],
    );

    bool validateField() {
      final isValid = formKey.currentState?.saveAndValidate() ?? false;
      return isValid;
    }

    Future<void> doManualLogin() async {
      if (!validateField()) return;

      loadingManual.value = true;
      final value = await authCtrl().manualLogin(
        emailCtrl.text,
        passCtrl.text,
      );
      showOTPBox.value = value;
      loadingManual.value = false;
    }

    Future<void> verifyOtp() async {
      if (!validateField()) return;

      loadingManual.value = true;
      await authCtrl().verifyOTP(otpCtrl.text);
      showOTPBox.value = false;
      loadingManual.value = false;
      otpCtrl.clear();
    }

    final tr = context.tr;
    return config.when(
      error: ErrorView.withScaffold,
      loading: () => const SplashView(),
      data: (config) {
        final useEmailOTP = config.settings.emailOTP;
        final usePhoneOTP = config.settings.phoneOTP;
        final usePassword = config.settings.isPasswordEnabled;
        String fieldText = tr.email;
        IconData prefix = Icons.email_rounded;

        if (useEmailOTP && usePhoneOTP) {
          fieldText = '${tr.email} / ${tr.phone}';
        } else if (usePhoneOTP) {
          fieldText = tr.phone;
          prefix = Icons.phone_rounded;
        }

        return Scaffold(
          appBar: KAppBar(
            color: context.colors.primary,
            actions: [
              TextButton(
                onPressed: () {
                  RouteNames.home.goNamed(context);
                },
                child: Text(
                  tr.skip,
                  style: context.textTheme.titleLarge!
                      .copyWith(color: context.colors.onPrimary),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => ref.invalidate(settingsCtrlProvider),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 800,
                width: context.width,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: context.width,
                        height: 200,
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                        ),
                        padding: context.onMobile
                            ? defaultPadding
                            : const EdgeInsets.symmetric(horizontal: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tr.Welcome,
                              style: context.textTheme.headlineMedium?.copyWith(
                                color: context.colors.onPrimary,
                              ),
                            ),
                            Text(
                              tr.login_subtitle,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.colors.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                context.onMobile ? 0 : context.width / 5,
                          ),
                          child: Column(
                            children: [
                              Container(height: 150),
                              Container(
                                width: context.width * .9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: context.colors.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.colors.outline
                                          .withOpacity(0.4),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(20),
                                child: FormBuilder(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          tr.login,
                                          style: context.textTheme.titleLarge,
                                        ),
                                      ),
                                      const SizedBox(height: 30),

                                      //! Email field
                                      if (!showOTPBox.value) ...[
                                        Text(
                                          fieldText,
                                          style: context.textTheme.titleSmall,
                                        ),
                                        const SizedBox(height: 10),
                                        FormBuilderTextField(
                                          name: 'email',
                                          controller: emailCtrl,
                                          autofillHints: [
                                            if (useEmailOTP)
                                              ...AutoFillHintList.email,
                                            if (usePhoneOTP)
                                              ...AutoFillHintList.phone
                                          ],
                                          keyboardType:
                                              (!useEmailOTP && usePhoneOTP)
                                                  ? TextInputType.phone
                                                  : TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            if (!useEmailOTP && usePhoneOTP)
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                          ],
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(prefix),
                                            hintText: TR
                                                .of(context)
                                                .enterFieldName(fieldText),
                                          ),
                                          validator:
                                              FormBuilderValidators.compose(
                                            [
                                              FormBuilderValidators.required(),
                                              if (!usePhoneOTP && useEmailOTP)
                                                FormBuilderValidators.email(),
                                              if (!useEmailOTP && usePhoneOTP)
                                                FormBuilderValidators.numeric(),
                                            ],
                                          ),
                                        ),
                                      ],

                                      //! password field
                                      if (usePassword && !showOTPBox.value) ...[
                                        const SizedBox(height: 20),
                                        Text(
                                          tr.password,
                                          style: context.textTheme.titleSmall,
                                        ),
                                        const SizedBox(height: 10),
                                        PassField(
                                          ctrl: passCtrl,
                                          name: 'password',
                                        )
                                      ],

                                      //! OTP box
                                      if (showOTPBox.value) ...[
                                        const SizedBox(height: 20),
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
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  ForgetPassDialog(
                                                email: emailCtrl.text,
                                              ),
                                            );
                                          },
                                          child: Text(
                                            tr.forgetPass,
                                          ),
                                        ),
                                      ),

                                      //! submit button
                                      SubmitButton(
                                        isLoading: loadingManual.value ||
                                            !configLoaded.value,
                                        onPressed: configLoaded.value
                                            ? () async {
                                                hideSoftKeyboard();
                                                showOTPBox.value
                                                    ? verifyOtp()
                                                    : doManualLogin();
                                              }
                                            : null,
                                        child: Text(
                                          showOTPBox.value
                                              ? context.tr.verify_otp
                                              : tr.login,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: context.onMobile ? 50 : 100,
                              ),

                              //! social login
                              SocialLoginButtons(config),
                              const SizedBox(height: 20),

                              //! resister page
                              Text.rich(
                                TextSpan(
                                  text: tr.donot_have_account,
                                  children: [
                                    TextSpan(
                                      text: tr.create_account,
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                              color: context.colors.primary),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => RouteNames.register
                                            .goNamed(context),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    )
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
