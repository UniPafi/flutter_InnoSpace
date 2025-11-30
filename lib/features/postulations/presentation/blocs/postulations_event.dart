abstract class PostulationsEvent {}

class LoadPostulationsEvent extends PostulationsEvent {
  final int managerId;

  LoadPostulationsEvent(this.managerId);
}
