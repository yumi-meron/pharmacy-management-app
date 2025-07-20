import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';
import 'package:pharmacist_mobile/domain/usecases/medicine/get_medicine_details.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository repository;
  final GetMedicineDetails getMedicineDetails;

  MedicineBloc(
    MedicineRepository medicineRepository, {
    required this.repository,
    required this.getMedicineDetails,
  }) : super(MedicineInitial()) {
    on<SearchMedicines>(_onSearchMedicines);
    on<GetMedicineDetailsEvent>(_onGetMedicineDetailsEvent);
    on<FetchAllMedicines>(_onFetchAllMedicines);
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

  Future<void> _onFetchAllMedicines(
      FetchAllMedicines event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    final result = await repository.getAllMedicines();
    result.fold(
      (failure) => emit(MedicineError(_mapFailureToMessage(failure))),
      (medicines) => emit(MedicineLoaded(medicines)),
    );
  }

  Future<void> _onGetMedicineDetailsEvent(
      GetMedicineDetailsEvent event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    final result = await getMedicineDetails(event.id);
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
