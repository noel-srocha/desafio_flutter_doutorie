import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final cardWidth = isWide ? 420.0 : constraints.maxWidth * 0.9;
          return Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 4,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            size: isWide ? 120 : 96,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Login (email)',
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Informe o email'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _senhaCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                            ),
                            obscureText: true,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Informe a senha'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state.authenticated) {
                                // ignore: use_build_context_synchronously
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed('/livros');
                              } else if (state.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error!)),
                                );
                              }
                            },
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: state.loading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<AuthCubit>().login(
                                              _emailCtrl.text.trim(),
                                              _senhaCtrl.text,
                                            );
                                          }
                                        },
                                  child: state.loading
                                      ? const CircularProgressIndicator()
                                      : const Text('Entrar'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
