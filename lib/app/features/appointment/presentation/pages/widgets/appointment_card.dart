import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../patient/domain/entities/patient_entity.dart';
import '../../../domain/entities/appointment_entity.dart';

class AppointmentCard extends StatelessWidget {
  final PatientEntity patient;
  final AppointmentEntity appointment;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onTapEdit;
  final VoidCallback onTapDelete;

  const AppointmentCard({
    super.key,
    required this.patient,
    required this.appointment,
    required this.onTap,
    required this.onTapEdit,
    required this.onTapDelete,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        isSelected ? AppColors.primaryColor : AppColors.primaryLigth;
    final textCardColor =
        isSelected ? AppColors.whiteColor : AppColors.greyDark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cardColor,
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textCardColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: textCardColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        patient.address.city,
                        style: TextStyle(
                          color: textCardColor,
                        ),
                      ),
                    ],
                  ),
                  if (appointment.notes != null &&
                      appointment.notes!.isNotEmpty) ...[
                    // const SizedBox(height: 4),
                    Text(
                      'Obs: ${appointment.notes}',
                      style: TextStyle(
                        color: textCardColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: textCardColor,
              ),
              onSelected: (String value) {
                if (value == 'edit') {
                  onTapEdit();
                } else if (value == 'delete') {
                  onTapDelete();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Editar'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Excluir'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
