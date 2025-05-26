import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'home_screen.dart';

class LoginView extends StatefulWidget {
  final TabController? tabController;
  const LoginView({super.key, this.tabController});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  final AuthService _authService = AuthService();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      final result = await _authService.login(
        context,
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      setState(() => _isLoading = false);

      if (mounted) {
        final bool isSuccess = result['success'] as bool? ?? false;
        final String message = result['message'] as String? ?? (isSuccess ? 'Login berhasil!' : 'Login gagal.');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isSuccess ? Colors.green : Colors.red,
          ),
        );

        if (isSuccess) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Masukkan Email / Username'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                if (!value.contains('@')) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Masukkan Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                if (value.length < 6) return 'Password minimal 6 karakter';
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Lupa Password belum tersedia.')),
                  );
                },
                child: const Text('Lupa Password?'),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(onPressed: _login, child: const Text('Masuk')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(value: _rememberMe, onChanged: (value) => setState(() => _rememberMe = value), activeColor: Colors.blue[700]),
                const Text('Tetap Login'),
              ],
            ),
            const SizedBox(height: 20),
            const Center(child: Text("Masuk dengan", style: TextStyle(color: Colors.grey))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _socialLoginButton(Icons.facebook, Colors.blue.shade800),
                _socialLoginButton(Icons.g_mobiledata, Colors.red.shade700),
                _socialLoginButton(Icons.code, Colors.black87),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Belum Punya Akun?'),
                TextButton(onPressed: () => widget.tabController?.animateTo(1), child: const Text('Daftarkan')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialLoginButton(IconData icon, Color color) {
    return IconButton(
      icon: Icon(icon, size: 30, color: color),
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur login sosial belum diimplementasikan.')),
      ),
    );
  }
}