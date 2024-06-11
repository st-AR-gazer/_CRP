array<string> knownBlocks;
array<string> knownItems;

array<string> g_knownComponents;

void LoadBlockAndItemLists() {
    knownBlocks = LoadJsonArray("src/data/BlockNames.json");
    knownItems = LoadJsonArray("src/data/ItemNames.json");

    for (uint i = 0; i < knownBlocks.Length; i++) {
        g_knownComponents.InsertLast(knownBlocks[i]);
    }
    for (uint i = 0; i < knownItems.Length; i++) {
        g_knownComponents.InsertLast(knownItems[i]);
    }
}

array<string> LoadJsonArray(const string &in filePath) {
    string fileContents = _IO::ReadSourceFileToEnd(filePath);

    array<string> elements;
    Json::Value root = Json::Parse(fileContents);
    
    if (root.GetType() == Json::Type::Array) {
        for (uint i = 0; i < root.Length; i++) {
            elements.InsertLast(root[i]);
        }
    } else {
        log("Error: Expected JSON array", LogLevel::Error, 29, "LoadJsonArray");
    }
    
    return elements;
}

ComponentType DetermineBlockType(const string &in name) {
    if (knownBlocks.Find(name) >= 0) return ComponentType::BLOCK;
    if (knownItems.Find(name) >= 0) return ComponentType::ITEM;
    return ComponentType::CUSTOM;
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