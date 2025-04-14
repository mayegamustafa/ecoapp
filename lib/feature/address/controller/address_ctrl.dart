import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/address/repository/address_repo.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addressListProvider = Provider.autoDispose<List<BillingAddress>>((ref) {
  final addresses =
      ref.watch(userDashProvider.select((v) => v?.user.billingAddress));

  return addresses ?? [];
});

final addressCtrlProvider = AutoDisposeNotifierProviderFamily<
    AddressCtrlNotifier,
    BillingAddress,
    BillingAddress?>(AddressCtrlNotifier.new);

class AddressCtrlNotifier
    extends AutoDisposeFamilyNotifier<BillingAddress, BillingAddress?> {
  @override
  BillingAddress build(BillingAddress? arg) {
    return arg ?? BillingAddress.empty;
  }

  AddressRepo get _repo => ref.read(addressRepoProvider);

  void setCountry(Country? country) {
    state = state.copyWith(country: () => country);
  }

  void setState(CountryState? cState) {
    state = state.copyWith(state: () => cState);
  }

  void setCity(StateCity? city) {
    state = state.copyWith(city: () => city);
  }

  Future<void> submitAddress(Map<String, dynamic> formData) async {
    final res = state.id == null
        ? await _repo.createAddress(formData)
        : await _repo.updateAddress(formData, state.id!);

    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        await ref.read(userDashCtrlProvider.notifier).reload();
        if (state.id == null) {
          Toaster.showSuccess('Address Saved Successfully');
        } else {
          Toaster.showSuccess('Address Updated Successfully');
        }
      },
    );
    return;
  }

  Future<void> deleteAddress() async {
    final id = state.id;

    final res = await _repo.deleteAddress('$id');
    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        await ref.read(userDashCtrlProvider.notifier).reload();
        Toaster.showSuccess('Address Deleted Successfully');
      },
    );
    return;
  }
}
