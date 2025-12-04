import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/auth/presentation/blocs/register/register_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body con el mismo gradiente
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
            child: BlocConsumer<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state.status == Status.error) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text(state.errorMessage ?? 'Error de Registro'),
                      backgroundColor: Colors.red,
                    ));
                }
                if (state.status == Status.success) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text('¡Registro Exitoso!'),
                      content: const Text(
                          'Tu cuenta de manager ha sido creada. Por favor, inicia sesión.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
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
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                }

                // Tarjeta central
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6).withOpacity(0.95),
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
                        'Crear cuenta',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF673AB7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Únete a la comunidad de InnoSpace',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Input Nombre
                      _buildTextField(
                        label: 'Nombre completo',
                        icon: Icons.person_outline,
                        onChanged: (value) => context
                            .read<RegisterBloc>()
                            .add(RegisterNameChanged(value)),
                      ),
                      const SizedBox(height: 16),

                      // Input Email
                      _buildTextField(
                        label: 'Correo electrónico',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => context
                            .read<RegisterBloc>()
                            .add(RegisterEmailChanged(value)),
                      ),
                      const SizedBox(height: 16),

                      // Input Password
                      _buildTextField(
                        label: 'Contraseña',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        onChanged: (value) => context
                            .read<RegisterBloc>()
                            .add(RegisterPasswordChanged(value)),
                      ),
                      const SizedBox(height: 24),

                      // Selector Tipo de Cuenta (Visual solamente, basado en imagen)
                      // Nota: La lógica actual hardcodea 'MANAGER', esto es solo visual
                      // para que coincida con la imagen proporcionada.
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Opción "Empresa" (seleccionada visualmente para Manager)
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7E57C2),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                                child: const Text(
                                  'Empresa (Manager)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Botón Registrarse
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context
                              .read<RegisterBloc>()
                              .add(RegisterSubmitted()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF64B5F6), // Azul claro/gradiente
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '¿Ya tienes cuenta? Inicia sesión aquí',
                          style: TextStyle(
                            color: Color(0xFF7E57C2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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