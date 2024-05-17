Json::Value CreateFile() {
    Json::Value settings = Json::Object();
    settings[g_className] = Json::Object();
    settings[g_className]["version"] = g_version;
    settings[g_className]["description"] = g_description;

    // metadata
    settings[g_className]["metadata"] = Json::Object();
    settings[g_className]["metadata"]["author"] = g_currUserName;
    settings[g_className]["metadata"]["creationDate"] = g_creationDate;

    // map
    settings[g_className]["map"] = Json::Array();
    for (uint i = 0; i < blockInputsArray.Length; i++) {
        Json::Value blockCombo = Json::Object();
        blockCombo["method"] = MethodTypeToString(methodTypes[i]);
        blockCombo["blockInput"] = Json::Array();
        for (uint j = 0; j < blockInputsArray[i].Length; j++) {
            blockCombo["blockInput"].Add(blockInputsArray[i][j]);
        }
        blockCombo["blockOutput"] = blockOutputs[i];
        if (methodTypes[i] == MethodType::ADD) {
            blockCombo["coordsXYZ"] = coordsXYZArray[i];
            blockCombo["rotationYPR"] = rotationYPRArray[i];
        }
        settings[g_className]["map"].Add(blockCombo);
    }

    return settings;
}