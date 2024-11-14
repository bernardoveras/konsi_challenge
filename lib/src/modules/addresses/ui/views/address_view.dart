import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../shared/di/di.dart';
import '../../../../shared/input_formatters/input_formatters.dart';
import '../../../../shared/ui/extensions/extensions.dart';
import '../../../../shared/ui/services/snackbar/snackbar.dart';
import '../../../../shared/ui/widgets/widgets.dart';
import '../../../../shared/utils/utils.dart';
import '../../../../shared/validators/validators.dart';
import '../../domain/dtos/address_book_dto.dart';
import '../parameters/address_view_parameter.dart';
import '../stores/address_store.dart';

class AddressView extends StatefulWidget {
  final AddressViewParameter? parameter;
  final bool editMode;

  const AddressView({
    super.key,
    this.parameter,
    this.editMode = false,
  });

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  late final AddressStore store;

  final formKey = GlobalKey<FormState>();

  final postalCodeController = TextEditingController();
  final addressController = TextEditingController();
  final numberController = TextEditingController();
  final complementController = TextEditingController();

  Future<void> onSearchAddressByPostalCode(String postalCode) async {
    try {
      hideKeyboard(context);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => const LoadingModal(
          description: 'Buscando endereço...',
        ),
      ).ignore();

      final result = await store.getAddressByPostalCode(postalCode);

      if (!mounted) return;

      final displayed = result.displaySnackbarWhenError(context);

      if (displayed) return;

      final address = result.getOrThrow();

      postalCodeController.text = address.postalCode ?? '';
      addressController.text = address.fullAddress();
      numberController.text = address.number ?? '';
      complementController.clear();
    } finally {
      if (mounted) {
        context.pop();
      }
    }
  }

  Future<void> onTapOutsidePostalCode() async {
    final postalCode = postalCodeController.text;

    final postalCodeIsValid = CepValidator.validate(postalCode);

    if (!postalCodeIsValid) return;

    await onSearchAddressByPostalCode(postalCode);
  }

  bool formIsValid() => formKey.currentState?.validate() == true;

  Future<void> onSubmit() async {
    AddressBookDto? popResult;

    hideKeyboard(context);

    if (!formIsValid()) {
      SnackbarService.showError(
        context,
        message: 'Corrija o formulário antes de prosseguir.',
      );
      return;
    }

    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => const LoadingModal(
          description: 'Salvando endereço na caderneta...',
        ),
      ).ignore();

      final address = AddressBookDto(
        id: widget.parameter?.id ?? const Uuid().v4(),
        postalCode: postalCodeController.text,
        address: addressController.text,
        number: numberController.text,
        complement: complementController.text,
      );

      final result = await store.saveAddress(address);

      if (!mounted) return;

      final displayed = result.displaySnackbarWhenError(context);

      if (displayed) return;

      popResult = address;

      SnackbarService.showSuccess(
        context,
        message:
            'Endereço ${widget.editMode ? 'atualizado' : 'salvo'} com sucesso',
      );

      context.pop(popResult);
    } finally {
      if (mounted) {
        context.pop(popResult);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    store = AddressStore(
      addressGeocodingService: Dependencies.resolve(),
      addressBookService: Dependencies.resolve(),
    );

    postalCodeController.text = widget.parameter?.postalCode ?? '';
    addressController.text = widget.parameter?.address ?? '';
    numberController.text = widget.parameter?.number ?? '';
    complementController.text = widget.parameter?.complement ?? '';
  }

  @override
  void dispose() {
    super.dispose();

    postalCodeController.dispose();
    addressController.dispose();
    numberController.dispose();
    complementController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RemoveDividerColorWrapper(
      child: Scaffold(
        key: widget.key,
        appBar: AppBar(
          title: const Text('Revisão'),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onSubmit,
                child: const Text('Confirmar'),
              ),
            ),
          ),
        ],
        body: ListenableBuilder(
          listenable: store,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Focus(
                      onFocusChange: (focused) {
                        if (!focused) onTapOutsidePostalCode();
                      },
                      child: TextFormField(
                        controller: postalCodeController,
                        validator: Validatorless.multiple([
                          Validatorless.required(
                            'Informe o CEP',
                          ),
                          CepValidatorless.validate('Informe um CEP válido'),
                        ]),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        enabled: !store.searchingAddress &&
                            !store.saving &&
                            !store.saving,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CepInputFormatter(),
                        ],
                        autofillHints: const [
                          AutofillHints.postalCode,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'CEP',
                          hintText: 'Digite o CEP',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: addressController,
                      validator: Validatorless.required(
                        'Informe o endereço',
                      ),
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !store.searchingAddress && !store.saving,
                      autofillHints: const [
                        AutofillHints.fullStreetAddress,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
                        hintText: 'Digite o endereço',
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: numberController,
                      textInputAction: TextInputAction.next,
                      enabled: !store.searchingAddress && !store.saving,
                      decoration: const InputDecoration(
                        labelText: 'Número',
                        hintText: 'Digite o número',
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: complementController,
                      textInputAction: TextInputAction.done,
                      enabled: !store.searchingAddress && !store.saving,
                      onFieldSubmitted: (_) => onSubmit(),
                      autofillHints: const [
                        AutofillHints.streetAddressLine1,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Complemento',
                        hintText: 'Digite o complemento',
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
