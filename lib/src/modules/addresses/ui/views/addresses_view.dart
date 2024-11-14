import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/di/di.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/router/router.dart';
import '../../../../shared/ui/extensions/extensions.dart';
import '../../../../shared/utils/debouncer.dart';
import '../../../../shared/utils/utils.dart';
import '../../domain/dtos/address_book_dto.dart';
import '../parameters/address_view_parameter.dart';
import '../stores/addresses_store.dart';
import '../widgets/address_book_list_tile.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({
    super.key,
  });

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  late final AddressesStore store;

  final searchController = TextEditingController();

  final searchDebouncer = Debouncer(milliseconds: 500);

  Future<void> fetch() async {
    final result = await store.getAddresses(
      filter: searchController.text,
    );

    if (!mounted) return;

    result.displaySnackbarWhenError(context);
  }

  @override
  void initState() {
    super.initState();

    store = AddressesStore(
      addressBookService: Dependencies.resolve(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      body: ListenableBuilder(
        listenable: store,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.paddingOf(context).bottom + 20,
            ),
            child: Column(
              children: [
                SearchBar(
                  hintText: 'Buscar',
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.only(
                      left: 16,
                    ),
                  ),
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.search,
                  controller: searchController,
                  onChanged: (value) {
                    searchDebouncer.run(() {
                      if (store.searching) return;
                      if (value.length < 3) {
                        store.getAddresses();
                        return;
                      }
                      store.getAddresses(filter: value);
                    });
                  },
                  trailing: searchController.text.isNotEmpty
                      ? [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                hideKeyboard(context);
                                searchController.clear();
                                store.getAddresses(
                                  filter: searchController.text,
                                );
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.close,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ]
                      : null,
                  leading: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                store.searching
                    ? const Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : store.searchError.isNotBlank
                        ? Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Text(
                                  store.searchError!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : store.addresses.isEmpty
                            ? const Expanded(
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      'Nenhum endereço encontrado.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ListView.separated(
                                  itemCount: store.addresses.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final address = store.addresses[index];

                                    return AddressBookListTile(
                                      addressBook: address,
                                      onTap: () async {
                                        final parameter = AddressViewParameter(
                                          id: address.id,
                                          postalCode: address.postalCode,
                                          address: address.address,
                                          number: address.number,
                                          complement: address.complement,
                                        );

                                        final result = await context.push(
                                          Routes.editAddress(
                                            parameter: parameter,
                                          ),
                                        );

                                        if (result is! AddressBookDto) return;

                                        store.updateAddressBook(result);
                                      },
                                    );
                                  },
                                ),
                              ),
              ],
            ),
          );
        },
      ),
    );
  }
}
