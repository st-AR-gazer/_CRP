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

BlockType DetermineBlockType(const string &in name) {
    bool isBlock = knownBlocks.Find(name) >= 0;
    bool isItem = knownItems.Find(name) >= 0;

    if (isBlock && isItem) {
        return BlockType::CUSTOM;
    } else if (isBlock) {
        return BlockType::BLOCK;
    } else if (isItem) {
        return BlockType::ITEM;
    }
    return BlockType::AUTO;
}

bool CheckAndUpdateBlockType(uint index, const string &in input, bool isOutput = false) {
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
}

