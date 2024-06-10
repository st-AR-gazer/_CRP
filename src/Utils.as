string MethodTypeToString(MethodType method) {
    if (method == MethodType::REPLACE) return "replace";
    if (method == MethodType::DELETE) return "delete";
    if (method == MethodType::PLACE) return "place";
    if (method == MethodType::PLACERELATIVE) return "placerelative";
    return "";
}