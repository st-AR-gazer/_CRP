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

array<array<BlockType>> g_inputTypes;
array<BlockType> g_outputTypes;

bool ValidateIndexTypes(uint index) {
    if (g_blockInputsArray[index] == array<string> ()) return true; // Valid if no inputs

    BlockType expectedType = g_inputTypes[index] == array<BlockType> () ? g_outputTypes[index] : g_inputTypes[index][0];

    for (uint j = 0; j < g_inputTypes[index].Length; j++) {
        if (g_inputTypes[index][j] != expectedType) {
            return false;
        }
    }

    return g_outputTypes[index] == expectedType;
}

void UpdateBlockTypes(uint index) {
    g_inputTypes[index].Resize(g_blockInputsArray[index].Length);
    for (uint j = 0; j < g_blockInputsArray[index].Length; j++) {
        g_inputTypes[index][j] = DetermineBlockType(g_blockInputsArray[index][j]);
    }
    g_outputTypes[index] = DetermineBlockType(g_blockOutputs[index]);
}

// TODO: IMPLEMENT COROUTINE SO THAT THE PREFORMACE IS NOT AFFECTED
