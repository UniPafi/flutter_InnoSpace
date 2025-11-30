import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/auth/domain/models/manager_profile.dart';
import 'package:flutter_innospace/features/profile/presentation/blocs/profile/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final ManagerProfile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _companyNameController;
  late TextEditingController _focusAreaController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  final TextEditingController _techInputController = TextEditingController();

  List<String> _technologies = [];
  String? _base64Image;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController =
        TextEditingController(text: widget.profile.phoneNumber ?? '');
    _companyNameController =
        TextEditingController(text: widget.profile.companyName ?? '');
    _focusAreaController =
        TextEditingController(text: widget.profile.focusArea ?? '');
    _locationController =
        TextEditingController(text: widget.profile.location ?? '');
    _descriptionController =
        TextEditingController(text: widget.profile.description ?? '');
    _technologies = List.from(widget.profile.companyTechnologies);
    _base64Image = widget.profile.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _focusAreaController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _techInputController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = File(pickedFile.path);
          _base64Image = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  void _addTechnology() {
    final tech = _techInputController.text.trim();
    if (tech.isNotEmpty && !_technologies.contains(tech)) {
      setState(() {
        _technologies.add(tech);
        _techInputController.clear();
      });
    }
  }

  void _removeTechnology(String tech) {
    setState(() {
      _technologies.remove(tech);
    });
  }

  void _saveProfile() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es requerido')),
      );
      return;
    }

    final updatedProfile = ManagerProfile(
      id: widget.profile.id,
      userId: widget.profile.userId,
      name: _nameController.text.trim(),
      photoUrl: _base64Image,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      companyName: _companyNameController.text.trim().isEmpty
          ? null
          : _companyNameController.text.trim(),
      focusArea: _focusAreaController.text.trim().isEmpty
          ? null
          : _focusAreaController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      companyTechnologies: _technologies,
    );

    context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == Status.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil actualizado exitosamente')),
          );
          Navigator.pop(context, true);
        } else if (state.status == Status.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Perfil'),
          elevation: 0,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final isLoading = state.status == Status.loading;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Foto de perfil
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: _getImageProvider(),
                                  child:
                                      _base64Image == null && _imageFile == null
                                          ? Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.5),
                                            )
                                          : null,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Material(
                                elevation: 4,
                                shape: const CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: 22,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt,
                                        size: 20, color: Colors.white),
                                    onPressed: isLoading ? null : _pickImage,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Nombre
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nombre',
                        icon: Icons.person_outline,
                        required: true,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Teléfono
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Teléfono',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Empresa
                      _buildTextField(
                        controller: _companyNameController,
                        label: 'Nombre de la Empresa',
                        icon: Icons.business_outlined,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Área de enfoque
                      _buildTextField(
                        controller: _focusAreaController,
                        label: 'Área de Enfoque',
                        icon: Icons.category_outlined,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Ubicación
                      _buildTextField(
                        controller: _locationController,
                        label: 'Ubicación',
                        icon: Icons.location_on_outlined,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Descripción
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Descripción',
                        icon: Icons.description_outlined,
                        maxLines: 4,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Tecnologías
                      Text(
                        'Tecnologías',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 12),

                      // Input para agregar tecnologías
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _techInputController,
                              enabled: !isLoading,
                              decoration: InputDecoration(
                                hintText: 'Ej: Flutter, React, Node.js',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.code),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              onSubmitted: (_) => _addTechnology(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: isLoading ? null : _addTechnology,
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Chips de tecnologías
                      if (_technologies.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _technologies.map((tech) {
                            return Chip(
                              label: Text(tech),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: isLoading
                                  ? null
                                  : () => _removeTechnology(tech),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 32),

                      // Botón guardar
                      ElevatedButton.icon(
                        onPressed: isLoading ? null : _saveProfile,
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.save_rounded),
                        label: Text(
                            isLoading ? 'Guardando...' : 'Guardar Cambios'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        prefixIcon: Icon(icon),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else if (_base64Image != null && _base64Image!.isNotEmpty) {
      try {
        String base64String = _base64Image!;
        if (base64String.contains(',')) {
          base64String = base64String.split(',').last;
        }
        final bytes = base64Decode(base64String);
        return MemoryImage(bytes);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
