array<string> knownBlocks;
array<string> knownItems;

array<string> LoadJsonArray(const string &in filePath) {
    string fileContents = _IO::ReadSourceFileToEnd(filePath);

    array<string> elements;
    Json::Value root = Json::Parse(fileContents);

    if (root.GetType() == Json::Type::Array) {
        for (uint i = 0; i < root.Length; i++) {
            elements.InsertLast(root[i]);
        }
    } else {
        log("Error: Expected JSON array", LogLevel::Error, 66, "LoadJsonArray");
    }

    return elements;
}

void InitializeBlockAndItemValidation() {
    array<string> _knownBlocks = LoadJsonArray("src/data/BlockNames.json");
    array<string> _knownItems = LoadJsonArray("src/data/ItemNames.json");


    for (uint i = 0; i < _knownBlocks.Length; i++) {
        knownBlocks[i] = _knownBlocks[i];
    }

    for (uint i = 0; i < _knownItems.Length; i++) {
        knownItems[i] = _knownItems[i];
    }
}