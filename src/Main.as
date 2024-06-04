[Setting name="Show Interface"]
bool S_showInterface = true;

string g_currUserName = "placeholder username";
const string g_version = "0.1.0";
string g_creationDate = "2021-07-01";

string g_className = "placeholder class name";
string g_description = "placeholder class description";

array<array<string>> g_blockInputsArray;
array<string> g_blockOutputs;
array<MethodType> g_methodTypes;
array<vec3> g_coordsXYZArray;
array<vec3> g_rotationYPRArray;

array<string> knownBlocks;
array<string> knownItems;

enum MethodType {
    REPLACE,
    DELETE,
    PLACE,
    PLACERELATIVE
}

string g_latestChange = "placeholder latest change";

void Main() {
    InitializeAllowedCharacters();
    LoadBlockAndItemLists();
    while (true) {
        CallFunc();
        yield();
    }
    log("Auto Alteration (Custom Replace Profiles) v " + g_version + " loaded.", LogLevel::Info, 41, "Main");
}

void LoadBlockAndItemLists() {
    knownBlocks = LoadJsonArray("src/data/BlockNames.json");
    knownItems = LoadJsonArray("src/data/ItemNames.json");
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
        log("Error: Expected JSON array", LogLevel::Error, 66, "LoadJsonArray");
    }
    
    return elements;
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


void CallFunc() {
    auto app = cast<CTrackMania>(GetApp());
    if (app is null) return;
    g_creationDate = app.OSUTCDate;
    auto map = cast<CGameCtnChallenge>(app.RootMap);
    if (map is null) return;
    auto net = cast<CGameNetwork>(app.Network);
    if (net is null) return;
    CTrackManiaPlayerInfo@ playerInfo = cast<CTrackManiaPlayerInfo>(net.PlayerInfos[0]);
    if (playerInfo is null) return;
    g_currUserName = playerInfo.Name;

    auto editor = cast<CGameCtnEditorFree>(app.Editor);
    if (editor is null) { return; }
    
    CheckChanges(editor);
}

void CheckChanges(CGameCtnEditorFree@ e) {
    string selectedNodeName = e.PluginMapType.Inventory.CurrentSelectedNode.Name;

    if (selectedNodeName != "") {
        g_latestChange = selectedNodeName;
    }
}

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