string MethodTypeToString(MethodType method) {
    if (method == MethodType::REPLACE) return "replace";
    if (method == MethodType::DELETE) return "delete";
    if (method == MethodType::PLACE) return "add";
    if (method == MethodType::PLACERELATIVE) return "move";
    return "";
}

void OpenFolder(const string &in path) {
    if (IO::FolderExists(path)) {
        OpenExplorerPath(path);
    }
}

bool g_trunchateAll = false;
void DeleteAll() {
    g_blockInputsArray.Resize(0);
    g_blockOutputs.Resize(0);
    g_methodTypes.Resize(0);
    g_coordsXYZArray.Resize(0);
    g_rotationYPRArray.Resize(0);
    g_trunchateAll = false;
    g_hiddenCount = 0;
}