string MethodTypeToString(MethodType method) {
    if (method == MethodType::REPLACE) return "replace";
    if (method == MethodType::DELETE) return "delete";
    if (method == MethodType::PLACE) return "place";
    if (method == MethodType::PLACERELATIVE) return "placerelative";
    return "";
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

/* bool CheckAndUpdateBlockType(uint index, const string &in input, bool isOutput = false) {
    if (input == "") {
        g_blockTypes[index] = BlockType::AUTO;
        return true;
    } else {
        BlockType newType = DetermineBlockType(input);
        if (isOutput && g_blockTypes[index] != BlockType::AUTO && g_blockTypes[index] != newType) {
            g_blockTypes[index] = BlockType::CUSTOM;
            return false;
        } else {
            g_blockTypes[index] = newType;
            return true;
        }
    }
}*/

void CheckAndUpdateBlockType(uint index, const string &in itemName, bool isOutput = false) {
    BlockType newType = DetermineBlockType(itemName);
    if (newType == BlockType::BLOCK) {
        log("Block", LogLevel::Info, 33, "CheckAndUpdateBlockType");
    } else if (newType == BlockType::ITEM) {
        log("Item", LogLevel::Info, 33, "CheckAndUpdateBlockType");
    } else {
        log("Custom", LogLevel::Info, 33, "CheckAndUpdateBlockType");
    }

    if (isOutput) {
        g_outputTypes[index] = newType;
    } else {
        g_inputTypes[index] = array<BlockType>(g_blockInputsArray[index].Length, newType);
    }
}
