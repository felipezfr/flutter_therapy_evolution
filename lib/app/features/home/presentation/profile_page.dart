import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/session/logged_user.dart';
import 'package:flutter_therapy_evolution/app/core/entities/user_entity.dart';
import 'package:flutter_therapy_evolution/app/features/auth/data/repositories/auth_repository.dart';

import 'widgets/custom_bottom_navigator_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authRepository = Modular.get<IAuthRepository>();

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await authRepository.logout();
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: ListenableBuilder(
          listenable: LoggedUser.instance,
          builder: (context, child) {
            final UserEntity user = LoggedUser.loggedUser!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (user.profilePicture != null)
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(user.profilePicture!),
                    )
                  else
                    const CircleAvatar(
                      radius: 60,
                      child: Icon(Icons.person, size: 60),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    user.name,
                    style: AppStyle.textTitle,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            context,
                            Icons.email,
                            'Email',
                            user.email,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            context,
                            Icons.phone,
                            'Telefone',
                            user.phone,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            context,
                            Icons.badge,
                            'Número da Licença',
                            user.licenseNumber,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            context,
                            Icons.calendar_today,
                            'Membro desde',
                            _formatDate(user.createdAt),
                          ),
                          const Divider(),
                          _buildInfoRow(
                            context,
                            Icons.login,
                            'Último acesso',
                            _formatDate(user.lastLogin),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.logout,
                      color: AppColors.greyLigth,
                    ),
                    label: Text('Sair da conta'),
                    onPressed: _logoutDialog,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
