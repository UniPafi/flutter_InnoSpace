import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/auth/presentation/blocs/register/register_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro - Manager')),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status == Status.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Error de Registro')));
          }
          if (state.status == Status.success) {
            // Éxito, mostramos diálogo y volvemos a Login
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('¡Registro Exitoso!'),
                content: const Text('Tu cuenta de manager ha sido creada. Por favor, inicia sesión.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra diálogo
                      Navigator.of(context).pop(); // Vuelve a Login Page
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
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
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  onChanged: (value) =>
                      context.read<RegisterBloc>().add(RegisterNameChanged(value)),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) =>
                      context.read<RegisterBloc>().add(RegisterEmailChanged(value)),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (value) =>
                      context.read<RegisterBloc>().add(RegisterPasswordChanged(value)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      context.read<RegisterBloc>().add(RegisterSubmitted()),
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}