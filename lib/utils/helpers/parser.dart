T requiredField<T>(dynamic value, String key) {
  if (value == null) {
    throw Exception("❌ Missing required field: $key");
  }
  return value as T;
}
