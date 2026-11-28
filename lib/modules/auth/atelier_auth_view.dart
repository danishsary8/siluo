import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/atelier_back_button.dart';

enum AuthMode { signIn, register }

/// Sign in / create account, in the app's editorial style.
///
/// Pops with `true` once the shopper is signed in, so callers can continue
/// what they were doing (see `AuthGate`).
class AtelierAuthView extends StatefulWidget {
  const AtelierAuthView({super.key, this.initialMode = AuthMode.signIn, this.reason});

  final AuthMode initialMode;

  /// Short line explaining why sign-in is needed, e.g. "Sign in to check out".
  final String? reason;

  @override
  State<AtelierAuthView> createState() => _AtelierAuthViewState();
}

class _AtelierAuthViewState extends State<AtelierAuthView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  late AuthMode _mode = widget.initialMode;
  bool _obscure = true;
  bool _busy = false;
  bool _submitted = false;
  String? _error;

  bool get _isRegister => _mode == AuthMode.register;

  @override
  void initState() {
    super.initState();
    _password.addListener(() {
      if (_isRegister) setState(() {});
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _switchMode(AuthMode m) {
    if (m == _mode) return;
    HapticService.selection();
    setState(() {
      _mode = m;
      _error = null;
      _submitted = false;
    });
  }

  Future<void> _submit() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitted = true;
      _error = null;
    });
    if (!(_formKey.currentState?.validate() ?? false)) {
      HapticService.heavy();
      return;
    }
    setState(() => _busy = true);
    final auth = AuthController.to;
    final error = _isRegister
        ? await auth.register(name: _name.text, email: _email.text, password: _password.text)
        : await auth.signIn(email: _email.text, password: _password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      HapticService.heavy();
      setState(() => _error = error);
      return;
    }
    TextInput.finishAutofillContext();
    _password.clear();
    final user = auth.user.value!;
    Navigator.of(context).pop(true);
    Get.rawSnackbar(
      messageText: Text(
        _isRegister ? 'Welcome to SILOU, ${user.firstName}!' : 'Welcome back, ${user.firstName}',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      icon: const Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.white),
      backgroundColor: AppColors.ctaDark,
      borderRadius: 18,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _comingSoon(String provider) {
    HapticService.light();
    Get.rawSnackbar(
      message: '$provider sign-in arrives with our next update. Use email for now.',
      backgroundColor: AppColors.ctaDark,
      borderRadius: 18,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      duration: const Duration(seconds: 2),
    );
  }

  void _forgotPassword() {
    HapticService.light();
    final emailError = AuthController.validateEmail(_email.text);
    Get.rawSnackbar(
      message: emailError == null
          ? 'If an account exists for ${AuthController.clean(_email.text).toLowerCase()}, a reset link is on its way.'
          : 'Enter your email above first, then tap “Forgot password?”',
      backgroundColor: AppColors.ctaDark,
      borderRadius: 18,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMuted;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    const AtelierBackButton(icon: CupertinoIcons.xmark),
                    const Spacer(),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'SILOU',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2.5, color: text),
                        ),
                        const TextSpan(
                          text: '.',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.silouPrimary),
                        ),
                      ]),
                    ),
                    const Spacer(),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (widget.reason != null) ...[
                                _ReasonChip(text: widget.reason!),
                                const SizedBox(height: 16),
                              ],
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                layoutBuilder: (current, previous) => Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [...previous, if (current != null) current],
                                ),
                                child: Text(
                                  _isRegister ? 'Create your account' : 'Welcome back',
                                  key: ValueKey(_mode),
                                  style: AppTypography.displayHero(color: text),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _isRegister
                                    ? 'Join SILOU to save your bag, wishlist and sizes across visits.'
                                    : 'Sign in to track orders, sync your wishlist and check out faster.',
                                style: AppTypography.body(color: muted),
                              ),
                              const SizedBox(height: 22),
                              _ModeToggle(mode: _mode, onChanged: _switchMode, isDark: isDark),
                              const SizedBox(height: 22),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutCubic,
                                child: _isRegister
                                    ? Padding(
                                        padding: const EdgeInsets.only(bottom: 14),
                                        child: _Field(
                                          controller: _name,
                                          label: 'Full name',
                                          icon: CupertinoIcons.person,
                                          autofill: const [AutofillHints.name],
                                          keyboard: TextInputType.name,
                                          capitalization: TextCapitalization.words,
                                          maxLength: 40,
                                          validator: AuthController.validateName,
                                          onSubmitted: (_) => _emailFocus.requestFocus(),
                                        ),
                                      )
                                    : const SizedBox(width: double.infinity),
                              ),
                              _Field(
                                controller: _email,
                                focusNode: _emailFocus,
                                label: 'Email',
                                icon: CupertinoIcons.mail,
                                autofill: const [AutofillHints.email],
                                keyboard: TextInputType.emailAddress,
                                maxLength: 254,
                                validator: AuthController.validateEmail,
                                onSubmitted: (_) => _passwordFocus.requestFocus(),
                              ),
                              const SizedBox(height: 14),
                              _Field(
                                controller: _password,
                                focusNode: _passwordFocus,
                                label: 'Password',
                                icon: CupertinoIcons.lock,
                                obscure: _obscure,
                                autofill: [_isRegister ? AutofillHints.newPassword : AutofillHints.password],
                                keyboard: TextInputType.visiblePassword,
                                maxLength: 128,
                                action: TextInputAction.done,
                                validator: (v) => AuthController.validatePassword(v, strict: _isRegister),
                                onSubmitted: (_) => _submit(),
                                suffix: IconButton(
                                  tooltip: _obscure ? 'Show password' : 'Hide password',
                                  icon: Icon(_obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, size: 20, color: muted),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                              ),
                              if (_isRegister) ...[
                                const SizedBox(height: 10),
                                _StrengthMeter(strength: AuthController.passwordStrength(_password.text), muted: muted),
                              ] else
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _forgotPassword,
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.w700, fontSize: 13),
                                    ),
                                  ),
                                ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 180),
                                child: _error == null
                                    ? const SizedBox(width: double.infinity)
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: AppColors.saleRed.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: AppColors.saleRed.withValues(alpha: 0.3)),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(CupertinoIcons.exclamationmark_circle, size: 18, color: AppColors.saleRed),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(_error!, style: const TextStyle(color: AppColors.saleRed, fontSize: 13, fontWeight: FontWeight.w600)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 54,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.silouPrimary,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: AppColors.silouPrimary.withValues(alpha: 0.6),
                                    elevation: 0,
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: _busy ? null : _submit,
                                  child: _busy
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                        )
                                      : Text(
                                          _isRegister ? 'CREATE ACCOUNT' : 'SIGN IN',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.0, color: Colors.white),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text('or continue with', style: TextStyle(fontSize: 12, color: muted)),
                                  ),
                                  Expanded(child: Divider(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: _SocialButton(icon: Icons.apple, label: 'Apple', isDark: isDark, onTap: () => _comingSoon('Apple'))),
                                  const SizedBox(width: 12),
                                  Expanded(child: _SocialButton(icon: Icons.g_mobiledata, label: 'Google', isDark: isDark, onTap: () => _comingSoon('Google'))),
                                ],
                              ),
                              const SizedBox(height: 22),
                              Center(
                                child: TextButton(
                                  onPressed: () => AtelierBackButton.goBack(context),
                                  child: Text(
                                    'Continue as guest',
                                    style: TextStyle(color: muted, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: muted),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.lock_shield, size: 13, color: muted),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'Your password is never stored on this device.',
                                      style: TextStyle(fontSize: 11, color: muted),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.champagneGold.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.5), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.lock_fill, size: 12, color: AppColors.champagneGold),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.champagneGold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged, required this.isDark});
  final AuthMode mode;
  final ValueChanged<AuthMode> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Widget tab(AuthMode m, String label) {
      final active = m == mode;
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(m),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? (isDark ? Colors.white : AppColors.ctaDark) : Colors.transparent,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
                color: active
                    ? (isDark ? AppColors.canvasDark : Colors.white)
                    : (isDark ? AppColors.textMutedDark : AppColors.textMuted),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
      ),
      child: Row(children: [tab(AuthMode.signIn, 'Sign in'), tab(AuthMode.register, 'Create account')]),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.focusNode,
    this.obscure = false,
    this.autofill = const [],
    this.keyboard,
    this.capitalization = TextCapitalization.none,
    this.action = TextInputAction.next,
    this.maxLength,
    this.onSubmitted,
    this.suffix,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final IconData icon;
  final bool obscure;
  final Iterable<String> autofill;
  final TextInputType? keyboard;
  final TextCapitalization capitalization;
  final TextInputAction action;
  final int? maxLength;
  final FormFieldValidator<String> validator;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMuted;
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c, width: w),
        );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      autocorrect: false,
      enableSuggestions: !obscure,
      autofillHints: autofill,
      keyboardType: keyboard,
      textCapitalization: capitalization,
      textInputAction: action,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      inputFormatters: [if (maxLength != null) LengthLimitingTextInputFormatter(maxLength)],
      style: TextStyle(
        fontSize: 16, // 16px keeps iOS Safari from zooming into the field.
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: muted, fontWeight: FontWeight.w500),
        floatingLabelStyle: const TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.w700),
        prefixIcon: Icon(icon, size: 20, color: muted),
        suffixIcon: suffix,
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        enabledBorder: border(isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
        focusedBorder: border(AppColors.champagneGold, 1.6),
        errorBorder: border(AppColors.saleRed.withValues(alpha: 0.7)),
        focusedErrorBorder: border(AppColors.saleRed, 1.6),
        errorStyle: const TextStyle(color: AppColors.saleRed, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _StrengthMeter extends StatelessWidget {
  const _StrengthMeter({required this.strength, required this.muted});
  final int strength;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    const labels = ['8+ characters, letters & numbers', 'Weak', 'Okay', 'Good', 'Strong'];
    const colors = [Colors.transparent, AppColors.saleRed, AppColors.silouFlash, AppColors.champagneGold, AppColors.inStockGreen];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        for (var i = 1; i <= 4; i++) ...[
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              decoration: BoxDecoration(
                color: i <= strength ? colors[strength] : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
        const SizedBox(width: 4),
        SizedBox(
          width: strength == 0 ? 190 : 52,
          child: Text(
            labels[strength],
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: strength == 0 ? muted : colors[strength]),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label, required this.isDark, required this.onTap});
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 22),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          side: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
