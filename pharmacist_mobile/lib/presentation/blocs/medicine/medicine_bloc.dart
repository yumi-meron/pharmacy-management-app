import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository repository;

  MedicineBloc(this.repository) : super(MedicineInitial()) {
    on<SearchMedicines>(_onSearchMedicines);
    on<FetchMedicineDetails>(_onFetchMedicineDetails);
  }

  Future<void> _onSearchMedicines(SearchMedicines event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    try {
      final medicines = await repository.searchMedicines(event.query);
      emit(MedicineLoaded(medicines));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  Future<void> _onFetchMedicineDetails(FetchMedicineDetails event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    try {
      final medicine = await repository.getMedicineDetails(event.id);
      emit(MedicineDetailsLoaded(medicine));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }
}