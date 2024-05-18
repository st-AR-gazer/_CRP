string MethodTypeToString(MethodType method) {
    if (method == MethodType::REPLACE) return "replace";
    if (method == MethodType::DELETE) return "delete";
    if (method == MethodType::ADD) return "add";
    if (method == MethodType::MOVE) return "move";
    return "";
}

void OpenFolder(const string &in path) {
    if (IO::FolderExists(path)) {
        OpenExplorerPath(path);
    }
}
