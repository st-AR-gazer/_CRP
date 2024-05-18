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
        blockCombo["source"] = Json::Array();
        for (uint j = 0; j < blockInputsArray[i].Length; j++) {
            blockCombo["source"].Add(blockInputsArray[i][j]);
        }
        if (methodTypes[i] == MethodType::REPLACE || methodTypes[i] == MethodType::ADD) {
            blockCombo["new"] = blockOutputs[i];
        }
        if (methodTypes[i] == MethodType::ADD || methodTypes[i] == MethodType::MOVE) {
            vec3 coords = coordsXYZArray[i];
            vec3 rotation = rotationYPRArray[i];
            blockCombo["coords"] = Json::Object();
            blockCombo["coords"]["x"] = coords.x;
            blockCombo["coords"]["y"] = coords.y;
            blockCombo["coords"]["z"] = coords.z;
            blockCombo["rotation"] = Json::Object();
            blockCombo["rotation"]["y"] = rotation.y;
            blockCombo["rotation"]["p"] = rotation.z;
            blockCombo["rotation"]["r"] = rotation.x;
        }
        settings[g_className]["map"].Add(blockCombo);
    }

    return settings;
}
