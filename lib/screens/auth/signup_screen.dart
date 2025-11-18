import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:man/services/auth_provider.dart';
import 'package:man/screens/auth/login_screen.dart';
import 'package:man/screens/auth/otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _buildLogo(),
                const SizedBox(height: 24),
                const Text('Join Mandir Mitra', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                const Text('Create your account to get started.', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                _buildNameField(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 16),
                _buildTermsCheckbox(),
                const SizedBox(height: 24),
                _buildSignupButton(),
                const SizedBox(height: 24),
                _buildDivider(),
                const SizedBox(height: 24),
                _buildGoogleButton(),
                const SizedBox(height: 12),
                _buildFacebookButton(),
                const SizedBox(height: 24),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFFFE5D0),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.temple_hindu_outlined, size: 50, color: Color(0xFFFF8C42)),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Full Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2D3748))),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            hintStyle: const TextStyle(color: Color(0xFFCBD5E0)),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.person_outline, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : v.length < 2 ? 'Name must be at least 2 characters' : null,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2D3748))),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            hintStyle: const TextStyle(color: Color(0xFFCBD5E0)),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.email_outlined, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please enter your email';
            final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
            if (!emailRegex.hasMatch(v)) return 'Please enter a valid email';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Phone Number', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2D3748))),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            hintStyle: const TextStyle(color: Color(0xFFCBD5E0)),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please enter your phone number';
            if (v.length != 10) return 'Please enter a valid 10-digit phone number';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2D3748))),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Create a password',
            hintStyle: const TextStyle(color: Color(0xFFCBD5E0)),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF6B7280)),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Please enter a password' : v.length < 6 ? 'Password must be at least 6 characters' : null,
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Confirm Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2D3748))),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            hintStyle: const TextStyle(color: Color(0xFFCBD5E0)),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.lock_outline : Icons.lock_open_outlined, color: const Color(0xFF6B7280)),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Please confirm your password' : v != _passwordController.text ? 'Passwords do not match' : null,
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: _acceptTerms, onChanged: (v) => setState(() => _acceptTerms = v ?? false), activeColor: const Color(0xFFFF8C42)),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _acceptTerms = !_acceptTerms),
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  children: [
                    TextSpan(text: 'I agree to the '),
                    TextSpan(text: 'Terms & Conditions', style: TextStyle(color: Color(0xFFFF8C42), fontWeight: FontWeight.w500)),
                    TextSpan(text: ' and '),
                    TextSpan(text: 'Privacy Policy', style: TextStyle(color: Color(0xFFFF8C42), fontWeight: FontWeight.w500)),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isEnabled = _acceptTerms && !authProvider.isLoading;
        return ElevatedButton(
          onPressed: isEnabled ? _handleSignup : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8C42),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            disabledBackgroundColor: const Color(0xFFE2E8F0),
            elevation: 0,
          ),
          child: authProvider.isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        );
      },
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFE2E8F0))),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Or sign up with', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14))),
        Expanded(child: Divider(color: Color(0xFFE2E8F0))),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google sign-up coming soon'))),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.g_mobiledata, size: 20)),
                const SizedBox(width: 12),
                const Text('Continue with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2D3748))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFacebookButton() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Facebook sign-up coming soon'))),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFF1877F2), borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.facebook, size: 20, color: Colors.white)),
                const SizedBox(width: 12),
                const Text('Continue with Facebook', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2D3748))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? ', style: TextStyle(color: Color(0xFF6B7280))),
        TextButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
          child: const Text('Log In', style: TextStyle(color: Color(0xFFFF8C42), fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signup(
        _nameController.text.trim(),
        _emailController.text.trim(),
        '+91${_phoneController.text.trim()}',
        _passwordController.text.trim(),
      );
      if (success && mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OTPScreen(phoneNumber: _emailController.text.trim())));
      }
    }
  }
}
