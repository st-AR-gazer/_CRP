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
    if (knownBlocks.Find(name) >= 0) return BlockType::BLOCK;
    if (knownItems.Find(name) >= 0) return BlockType::ITEM;
    return BlockType::CUSTOM;
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