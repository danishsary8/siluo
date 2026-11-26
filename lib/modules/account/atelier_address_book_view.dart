import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/account_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import 'widgets/account_ui.dart';

/// Saved addresses: pick a default, add, edit (sheet) and swipe to delete.
///
/// When opened with [selectMode] true (from checkout) tapping an address
/// makes it the default and pops back.
class AtelierAddressBookView extends StatelessWidget {
  const AtelierAddressBookView({super.key, this.selectMode = false});

  final bool selectMode;

  @override
  Widget build(BuildContext context) {
    final account = AccountController.to;
    return Scaffold(
      backgroundColor: AccountUi.canvas(context),
      appBar: AccountUi.appBar(context, selectMode ? 'Deliver To' : 'Saved Addresses'),
      body: Obx(() {
        final list = account.addresses;
        if (list.isEmpty) {
          return _EmptyAddresses(onAdd: () => AddressFormSheet.show(context));
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final a = list[i];
            final isDefault = a.id == account.defaultAddressId.value;
            return TweenAnimationBuilder<double>(
              key: ValueKey(a.id),
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + i * 80),
              curve: Curves.easeOutCubic,
              builder: (_, t, child) => Opacity(
                opacity: t,
                child: Transform.translate(offset: Offset(0, 16 * (1 - t)), child: child),
              ),
              child: Dismissible(
                key: ValueKey('dismiss-${a.id}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDelete(context, a),
                onDismissed: (_) {
                  account.deleteAddress(a.id);
                  AccountUi.toast('Address removed', a.label);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: AppColors.saleRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(CupertinoIcons.trash, color: Colors.white),
                ),
                child: _AddressCard(
                  address: a,
                  isDefault: isDefault,
                  selectMode: selectMode,
                  onTap: () {
                    account.setDefaultAddress(a.id);
                    if (selectMode) {
                      Get.back<void>();
                      AccountUi.toast('Delivery address updated', a.oneLine);
                    }
                  },
                  onEdit: () => AddressFormSheet.show(context, existing: a),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AccountPrimaryButton(
          label: 'Add new address',
          icon: CupertinoIcons.add,
          onPressed: () => AddressFormSheet.show(context),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, SavedAddress a) async {
    HapticService.medium();
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text('Remove "${a.label}"?'),
        content: Text(a.oneLine),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.isDefault,
    required this.selectMode,
    required this.onTap,
    required this.onEdit,
  });

  final SavedAddress address;
  final bool isDefault;
  final bool selectMode;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  IconData get _icon => switch (address.label.toLowerCase()) {
        'home' => CupertinoIcons.house_fill,
        'work' || 'studio' || 'office' => CupertinoIcons.briefcase_fill,
        _ => CupertinoIcons.location_solid,
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(18),
          decoration: AccountUi.card(context, highlighted: isDefault),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.champagneGold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_icon, color: AppColors.champagneGold, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AccountUi.text(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isDefault
                              ? Container(
                                  key: const ValueKey('d'),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.champagneGold,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'DEFAULT',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(key: ValueKey('n')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${address.fullName}\n${address.twoLines}\n${address.phone}',
                      style: TextStyle(fontSize: 13, height: 1.45, color: AccountUi.muted(context)),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    tooltip: 'Edit address',
                    onPressed: onEdit,
                    icon: Icon(CupertinoIcons.pencil, size: 18, color: AccountUi.muted(context)),
                  ),
                  Icon(
                    isDefault ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                    color: isDefault ? AppColors.champagneGold : AccountUi.border(context),
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyAddresses extends StatelessWidget {
  const _EmptyAddresses({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.map_pin_ellipse, size: 56, color: AppColors.champagneGold),
            const SizedBox(height: 18),
            Text(
              'No saved addresses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AccountUi.text(context)),
            ),
            const SizedBox(height: 8),
            Text(
              'Add an address for faster checkout.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AccountUi.muted(context)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet form to add or edit an address, with validation.
class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({super.key, this.existing});

  final SavedAddress? existing;

  static Future<void> show(BuildContext context, {SavedAddress? existing}) {
    HapticService.light();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddressFormSheet(existing: existing),
    );
  }

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _line1;
  late final TextEditingController _city;
  late final TextEditingController _postcode;
  late final TextEditingController _country;
  late final TextEditingController _phone;
  late String _label;

  static const _labels = ['Home', 'Studio', 'Work', 'Other'];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.fullName ?? 'Sary Danish');
    _line1 = TextEditingController(text: e?.line1);
    _city = TextEditingController(text: e?.city);
    _postcode = TextEditingController(text: e?.postcode);
    _country = TextEditingController(text: e?.country ?? 'France');
    _phone = TextEditingController(text: e?.phone);
    _label = e?.label ?? 'Home';
  }

  @override
  void dispose() {
    for (final c in [_name, _line1, _city, _postcode, _country, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      HapticService.heavy();
      return;
    }
    final address = SavedAddress(
      id: widget.existing?.id ?? 'a${DateTime.now().microsecondsSinceEpoch}',
      label: _label,
      fullName: _name.text.trim(),
      line1: _line1.text.trim(),
      city: _city.text.trim(),
      postcode: _postcode.text.trim(),
      country: _country.text.trim(),
      phone: _phone.text.trim(),
    );
    AccountController.to.saveAddress(address);
    Navigator.of(context).pop();
    AccountUi.toast(widget.existing == null ? 'Address added' : 'Address updated', address.oneLine);
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 40),
      decoration: BoxDecoration(
        color: AccountUi.canvas(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, inset + 20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AccountUi.border(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                widget.existing == null ? 'New address' : 'Edit address',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AccountUi.text(context)),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  for (final l in _labels)
                    ChoiceChip(
                      label: Text(l),
                      selected: _label == l,
                      selectedColor: AppColors.champagneGold,
                      labelStyle: TextStyle(
                        color: _label == l ? Colors.white : AccountUi.text(context),
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) {
                        HapticService.selection();
                        setState(() => _label = l);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 14),
              _field(_name, 'Full name', CupertinoIcons.person, validator: _required),
              _field(_line1, 'Street address', CupertinoIcons.location, validator: _required),
              Row(
                children: [
                  Expanded(child: _field(_city, 'City', CupertinoIcons.building_2_fill, validator: _required)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(_postcode, 'Postcode', CupertinoIcons.number,
                        validator: _required, keyboard: TextInputType.number),
                  ),
                ],
              ),
              _field(_country, 'Country', CupertinoIcons.globe, validator: _required),
              _field(
                _phone,
                'Phone',
                CupertinoIcons.phone,
                keyboard: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.replaceAll(RegExp(r'\D'), '').length < 7) ? 'Enter a valid phone' : null,
                last: true,
              ),
              const SizedBox(height: 12),
              AccountPrimaryButton(label: 'Save address', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    IconData icon, {
    String? Function(String?)? validator,
    TextInputType? keyboard,
    bool last = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        validator: validator,
        keyboardType: keyboard,
        textInputAction: last ? TextInputAction.done : TextInputAction.next,
        onFieldSubmitted: last ? (_) => _save() : null,
        style: TextStyle(color: AccountUi.text(context)),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 18),
          filled: true,
          fillColor: AccountUi.surface(context),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AccountUi.border(context)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AccountUi.border(context)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.champagneGold, width: 1.5),
          ),
        ),
      ),
    );
  }
}
