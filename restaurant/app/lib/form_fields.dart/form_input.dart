abstract class FormInput<T, E> {
  const FormInput._(this.value, this.shouldValidate);

  const FormInput.pure(T value) : this._(value, false);
  const FormInput.dirty(T value) : this._(value, true);

  final T value;
  final bool shouldValidate;

  E? get error => shouldValidate ? validator(value) : null;

  bool get isValid => error == null;

  E? validator(T value);
}
