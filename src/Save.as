Json::Value CreateFile() {
    Json::Value settings = Json::Object();
    settings[g_className] = Json::Object();

    // metadata
    settings[g_className]["metadata"] = Json::Object();
    settings[g_className]["metadata"]["version"] = g_version;
    settings[g_className]["metadata"]["author"] = g_currUserName;
    settings[g_className]["metadata"]["creationDate"] = g_creationDate;
    settings[g_className]["metadata"]["description"] = g_description;

    // map
    settings[g_className]["map"] = Json::Array();
    for (uint i = 0; i < g_blockInputsArray.Length; i++) {
        Json::Value blockCombo = Json::Object();
        blockCombo["method"] = MethodTypeToString(g_methodTypes[i]);
        blockCombo["source"] = Json::Array();
        for (uint j = 0; j < g_blockInputsArray[i].Length; j++) {
            blockCombo["source"].Add(g_blockInputsArray[i][j]);
        }
        if (g_methodTypes[i] == MethodType::REPLACE || g_methodTypes[i] == MethodType::ADD) {
            blockCombo["new"] = g_blockOutputs[i];
        }
        if (g_methodTypes[i] == MethodType::ADD || g_methodTypes[i] == MethodType::MOVE) {
            vec3 coords = g_coordsXYZArray[i];
            vec3 rotation = g_rotationYPRArray[i];
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
