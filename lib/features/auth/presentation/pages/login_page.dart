import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/auth/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_innospace/features/auth/presentation/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - Manager')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == Status.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Error de Login')));
          }
          if (state.status == Status.success) {
            Navigator.of(context).pushReplacementNamed('/main');
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) =>
                      context.read<LoginBloc>().add(LoginEmailChanged(value)),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (value) =>
                      context.read<LoginBloc>().add(LoginPasswordChanged(value)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      context.read<LoginBloc>().add(LoginSubmitted()),
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegisterPage(), 
                    ));
                  },
                  child: const Text('¿No tienes cuenta? Regístrate'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}