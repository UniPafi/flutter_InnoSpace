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
      // Hacemos que el body ocupe todo, incluyendo el área de status bar si se desea
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9575CD), // Morado suave
              Color(0xFF64B5F6), // Azul claro
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state.status == Status.error) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text(state.errorMessage ?? 'Error de Login'),
                      backgroundColor: Colors.red,
                    ));
                }
                if (state.status == Status.success) {
                  Navigator.of(context).pushReplacementNamed('/main');
                }
              },
              builder: (context, state) {
                if (state.status == Status.loading) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                }

                // Diseño de la Tarjeta Central
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6).withOpacity(0.95), // Fondo casi blanco/morado muy claro
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Títulos
                      const Text(
                        'Bienvenido de nuevo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF673AB7), // Morado oscuro
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Inicia sesión para continuar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Input Email
                      _buildTextField(
                        label: 'Correo electrónico',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => context
                            .read<LoginBloc>()
                            .add(LoginEmailChanged(value)),
                      ),
                      const SizedBox(height: 16),

                      // Input Password
                      _buildTextField(
                        label: 'Contraseña',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        onChanged: (value) => context
                            .read<LoginBloc>()
                            .add(LoginPasswordChanged(value)),
                      ),
                      const SizedBox(height: 32),

                      // Botón Iniciar Sesión
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              context.read<LoginBloc>().add(LoginSubmitted()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7E57C2), // Botón morado
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Link Registro
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '¿No tienes cuenta? ',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ));
                            },
                            child: const Text(
                              'Regístrate aquí',
                              style: TextStyle(
                                color: Color(0xFF7E57C2),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Método helper para los inputs estilizados
  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    required Function(String) onChanged,
  }) {
    return TextField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF9575CD)),
        filled: true,
        fillColor: Colors.white, // Fondo blanco para el input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Sin borde por defecto
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7E57C2), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}