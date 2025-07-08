import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository repository;

  MedicineBloc(this.repository) : super(MedicineInitial()) {
    on<SearchMedicines>(_onSearchMedicines);
    on<FetchMedicineDetails>(_onFetchMedicineDetails);
  }

  Future<void> _onSearchMedicines(
      SearchMedicines event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    final result = await repository.searchMedicines(event.query);
    result.fold(
      (failure) => emit(MedicineError(_mapFailureToMessage(failure))),
      (medicines) => emit(MedicineLoaded(medicines)),
    );
  }

  Future<void> _onFetchMedicineDetails(
      FetchMedicineDetails event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    final result = await repository.getMedicineDetails(event.id);
    result.fold(
      (failure) => emit(MedicineError(_mapFailureToMessage(failure))),
      (medicine) => emit(MedicineDetailsLoaded(medicine)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return 'No internet connection';
    } else if (failure is ServerFailure) {
      return 'Server error: ${failure.message}';
    } else if (failure is DatabaseFailure) {
      return 'Database error';
    } else {
      return 'Unexpected error: ${failure.message}';
    }
  }
}
