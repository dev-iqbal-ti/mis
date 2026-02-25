import 'package:dronees/models/vehicle.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';

class VehicleSelectorFormField extends FormField<Vehicle> {
  VehicleSelectorFormField({
    super.key,
    required List<Vehicle> vehicles,

    /// Pre-select a vehicle — pass controller.selectedVehicle.value
    super.initialValue,

    /// Fires immediately when user picks — update your reactive variable here
    ValueChanged<Vehicle>? onVehicleSelected,

    /// Called on form.save()
    super.onSaved,

    /// Mirrors TextFormField — use AutovalidateMode.onUserInteraction
    super.autovalidateMode,

    /// Override the default "required" rule
    String? Function(Vehicle?)? validator,

    String label = 'Vehicle',
    String placeholder = 'Select a vehicle',
    bool enabled = true,
  }) : super(
         validator:
             validator ?? (v) => v == null ? 'Please select a vehicle' : null,
         builder: (FormFieldState<Vehicle> state) {
           return _VehicleSelectorFieldBody(
             state: state,
             vehicles: vehicles,
             label: label,
             placeholder: placeholder,
             enabled: enabled,
             onVehicleSelected: onVehicleSelected,
           );
         },
       );
}

// ─────────────────────────────────────────────────────────────────────────────
//  Field body
// ─────────────────────────────────────────────────────────────────────────────
class _VehicleSelectorFieldBody extends StatelessWidget {
  final FormFieldState<Vehicle> state;
  final List<Vehicle> vehicles;
  final String label;
  final String placeholder;
  final bool enabled;
  final ValueChanged<Vehicle>? onVehicleSelected;

  const _VehicleSelectorFieldBody({
    required this.state,
    required this.vehicles,
    required this.label,
    required this.placeholder,
    required this.enabled,
    required this.onVehicleSelected,
  });

  Vehicle? get _value => state.value;
  bool get _hasError => state.hasError;

  IconData _vehicleIcon(String type) {
    switch (type.toLowerCase()) {
      case 'truck':
        return Icons.local_shipping_rounded;
      case 'bus':
        return Icons.directions_bus_rounded;
      case 'bike':
      case 'motorcycle':
        return Icons.two_wheeler_rounded;
      case 'van':
        return Icons.airport_shuttle_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF22C55E);
      case 'inactive':
        return const Color(0xFFEF4444);
      case 'maintenance':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  void _openSheet(BuildContext context) {
    if (!enabled) return;
    CustomBlurBottomSheet.show(
      context,
      widget: _VehiclePickerSheet(
        vehicles: vehicles,
        selectedVehicle: _value,
        onVehicleSelected: (v) {
          Navigator.pop(context);
          state.didChange(v); // ← notifies Form
          onVehicleSelected?.call(v); // ← updates GetX Rx variable
        },
        vehicleIcon: _vehicleIcon,
        statusColor: _statusColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = _value != null;

    final Color borderColor = _hasError
        ? TColors.error
        : hasValue
        ? TColors.primary
        : const Color(0xFFE2E8F0);

    final Color iconBg = _hasError
        ? TColors.error.withOpacity(0.08)
        : hasValue
        ? TColors.primary.withOpacity(0.08)
        : const Color(0xFFF1F5F9);

    final Color iconColor = _hasError
        ? TColors.error
        : hasValue
        ? TColors.primary
        : const Color(0xFF94A3B8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ──────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ),

        // ── Selector tile ───────────────────────────────────────────────────
        GestureDetector(
          onTap: () => _openSheet(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: enabled ? Colors.white : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: (hasValue || _hasError) ? 1.2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _hasError
                      ? TColors.error
                      : hasValue
                      ? const Color(0xFF6366F1).withOpacity(0.07)
                      : const Color(0xFF94A3B8).withOpacity(0.05),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                // Icon bubble
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    hasValue
                        ? _vehicleIcon(_value!.vehicleType)
                        : _hasError
                        ? Icons.error_outline_rounded
                        : Icons.directions_car_outlined,
                    color: iconColor,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 13),

                // Text info
                Expanded(
                  child: hasValue
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_value!.brand} ${_value!.model}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Text(
                                    _value!.vehicleNumber,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475569),
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: _statusColor(_value!.status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _value!.status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: _statusColor(_value!.status),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Text(
                          placeholder,
                          style: TextStyle(
                            fontSize: 14,
                            color: _hasError
                                ? const Color(0xFFEF4444).withOpacity(0.6)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                ),

                // Chevron
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: hasValue
                      ? const Color(0xFF6366F1)
                      : _hasError
                      ? TColors.error
                      : const Color(0xFFCBD5E1),
                  size: 22,
                ),
              ],
            ),
          ),
        ),

        // ── Error message — matches TextFormField style exactly ─────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.topLeft,
          child: _hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 14),
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        state.errorText!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: TColors.error,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bottom Sheet Content
// ─────────────────────────────────────────────────────────────────────────────
class _VehiclePickerSheet extends StatefulWidget {
  final List<Vehicle> vehicles;
  final Vehicle? selectedVehicle;
  final ValueChanged<Vehicle> onVehicleSelected;
  final IconData Function(String) vehicleIcon;
  final Color Function(String) statusColor;

  const _VehiclePickerSheet({
    required this.vehicles,
    required this.selectedVehicle,
    required this.onVehicleSelected,
    required this.vehicleIcon,
    required this.statusColor,
  });

  @override
  State<_VehiclePickerSheet> createState() => _VehiclePickerSheetState();
}

class _VehiclePickerSheetState extends State<_VehiclePickerSheet> {
  String _search = '';

  List<Vehicle> get _filtered => widget.vehicles
      .where(
        (v) =>
            v.vehicleNumber.toLowerCase().contains(_search.toLowerCase()) ||
            v.brand.toLowerCase().contains(_search.toLowerCase()) ||
            v.model.toLowerCase().contains(_search.toLowerCase()) ||
            v.vehicleType.toLowerCase().contains(_search.toLowerCase()),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.garage_rounded,
                    color: Color(0xFF6366F1),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Vehicle',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Choose from your fleet',
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: 'Search by plate, brand or model...',
                hintStyle: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF6366F1),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            color: Color(0xFFCBD5E1),
                            size: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No vehicles found',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final v = filtered[i];
                      final isSelected = widget.selectedVehicle?.id == v.id;
                      return _VehicleTile(
                        vehicle: v,
                        isSelected: isSelected,
                        iconData: widget.vehicleIcon(v.vehicleType),
                        statusColor: widget.statusColor(v.status),
                        onTap: () => widget.onVehicleSelected(v),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Vehicle Tile
// ─────────────────────────────────────────────────────────────────────────────
class _VehicleTile extends StatelessWidget {
  final Vehicle vehicle;
  final bool isSelected;
  final IconData iconData;
  final Color statusColor;
  final VoidCallback onTap;

  const _VehicleTile({
    required this.vehicle,
    required this.isSelected,
    required this.iconData,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withOpacity(0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6366F1)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6366F1).withOpacity(0.1)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                iconData,
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF64748B),
                size: 21,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.brand} ${vehicle.model}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF4338CA)
                          : const Color(0xFF0F172A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          vehicle.vehicleNumber,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        vehicle.fuelType,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isSelected)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  )
                else
                  const SizedBox(height: 22),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vehicle.status,
                      style: TextStyle(
                        fontSize: 10,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
