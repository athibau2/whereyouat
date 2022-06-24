import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'google_maps_event.dart';
part 'google_maps_state.dart';

class GoogleMapsBloc extends Bloc<GoogleMapsEvent, GoogleMapsState> {
  GoogleMapsBloc() : super(GoogleMapsInitial()) {
    on<GoogleMapsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
