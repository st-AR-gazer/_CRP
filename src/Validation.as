// Block / Item Validation
array<array<BlockType>> g_inputTypes;
array<BlockType> g_outputTypes;
bool g_enableValidation = true;

void InitializeValidation() {
    g_inputTypes.Resize(g_blockInputsArray.Length);
    g_outputTypes.Resize(g_blockOutputs.Length);

    for (uint i = 0; i < g_blockInputsArray.Length; i++) {
        g_inputTypes[i].Resize(g_blockInputsArray[i].Length);
        for (uint j = 0; j < g_blockInputsArray[i].Length; j++) {
            g_inputTypes[i][j] = DetermineBlockType(g_blockInputsArray[i][j]);
        }
        g_outputTypes[i] = DetermineBlockType(g_blockOutputs[i]);
    }
}

void UpdateBlockTypes(uint index) {
    g_inputTypes[index].Resize(g_blockInputsArray[index].Length);
    for (uint j = 0; j < g_blockInputsArray[index].Length; j++) {
        g_inputTypes[index][j] = DetermineBlockType(g_blockInputsArray[index][j]);
    }
    g_outputTypes[index] = DetermineBlockType(g_blockOutputs[index]);
}

bool ValidateIndexTypes(uint index) {
    if (g_blockInputsArray[index].Length == 0) return true; // valid if no inputs
    BlockType expectedType = g_inputTypes[index].Length == 0 ? g_outputTypes[index] : g_inputTypes[index][0];

    for (uint j = 0; j < g_inputTypes[index].Length; j++) {
        if (g_inputTypes[index][j] != expectedType) {
            return false;
        }
    }

    return g_outputTypes[index] == expectedType;
}

string validationStatus;

void UpdateUIWithValidationResult(uint index, bool isValid) {
    validationStatus = isValid ? "\\$0f0✔ Valid" : "\\$f00✗ Invalid";
}

BlockType DetermineBlockType(const string &in itemName) {
    if (knownBlocksDict.Exists(itemName)) {
        return BlockType::BLOCK;
    } else if (knownItemsDict.Exists(itemName)) {
        return BlockType::ITEM;
    } else {
        return BlockType::CUSTOM;
    }
}

/*BlockType DetermineBlockType(const string &in name) {
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
}*/

// ClassName Validation

array<string> g_allowedCharacters;

bool IsValidClassName(const string &in className) {
    for (int i = 0; i < className.Length; i++) {
        string char = className.SubStr(i, 1);
        if (g_allowedCharacters.Find(char) < 0) {
            return false;
        }
    }
    return true;
}

void InitializeAllowedCharacters() {
    g_allowedCharacters.InsertLast("A");
    g_allowedCharacters.InsertLast("B");
    g_allowedCharacters.InsertLast("C");
    g_allowedCharacters.InsertLast("D");
    g_allowedCharacters.InsertLast("E");
    g_allowedCharacters.InsertLast("F");
    g_allowedCharacters.InsertLast("G");
    g_allowedCharacters.InsertLast("H");
    g_allowedCharacters.InsertLast("I");
    g_allowedCharacters.InsertLast("J");
    g_allowedCharacters.InsertLast("K");
    g_allowedCharacters.InsertLast("L");
    g_allowedCharacters.InsertLast("M");
    g_allowedCharacters.InsertLast("N");
    g_allowedCharacters.InsertLast("O");
    g_allowedCharacters.InsertLast("P");
    g_allowedCharacters.InsertLast("Q");
    g_allowedCharacters.InsertLast("R");
    g_allowedCharacters.InsertLast("S");
    g_allowedCharacters.InsertLast("T");
    g_allowedCharacters.InsertLast("U");
    g_allowedCharacters.InsertLast("V");
    g_allowedCharacters.InsertLast("W");
    g_allowedCharacters.InsertLast("X");
    g_allowedCharacters.InsertLast("Y");
    g_allowedCharacters.InsertLast("Z");
    g_allowedCharacters.InsertLast("a");
    g_allowedCharacters.InsertLast("b");
    g_allowedCharacters.InsertLast("c");
    g_allowedCharacters.InsertLast("d");
    g_allowedCharacters.InsertLast("e");
    g_allowedCharacters.InsertLast("f");
    g_allowedCharacters.InsertLast("g");
    g_allowedCharacters.InsertLast("h");
    g_allowedCharacters.InsertLast("i");
    g_allowedCharacters.InsertLast("j");
    g_allowedCharacters.InsertLast("k");
    g_allowedCharacters.InsertLast("l");
    g_allowedCharacters.InsertLast("m");
    g_allowedCharacters.InsertLast("n");
    g_allowedCharacters.InsertLast("o");
    g_allowedCharacters.InsertLast("p");
    g_allowedCharacters.InsertLast("q");
    g_allowedCharacters.InsertLast("r");
    g_allowedCharacters.InsertLast("s");
    g_allowedCharacters.InsertLast("t");
    g_allowedCharacters.InsertLast("u");
    g_allowedCharacters.InsertLast("v");
    g_allowedCharacters.InsertLast("w");
    g_allowedCharacters.InsertLast("x");
    g_allowedCharacters.InsertLast("y");
    g_allowedCharacters.InsertLast("z");
    g_allowedCharacters.InsertLast("_");
}