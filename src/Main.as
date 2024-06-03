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

enum MethodType {
    REPLACE,
    DELETE,
    PLACE,
    PLACERELATIVE
}

string g_currentBlock = "placeholder block name";
string g_currentItem = "placeholder item name";
string g_latestChange = "placeholder latest change";

string g_previousBlock = g_currentBlock;
string g_previousItem = g_currentItem;


array<string> knownBlocks;
array<string> knownItems;

void Main() {
    LoadBlockAndItemLists();
    while (true) {
        CallFunc();
        yield();
    }
    log("Auto Alteration (Custom Replace Profiles) v " + g_version + " loaded.", LogLevel::Info, 68, "Main");
}

array<string> LoadJsonArray(const string &in filePath) {
    IO::FileSource f(filePath);
    string fileContents = f.ReadToEnd();

    array<string> elements;

    int start = fileContents.IndexOf("[") + 1;
    int end = fileContents.IndexOf("]");
    string arrayContent = fileContents.SubStr(start, end - start);
    array<string> rawElements = arrayContent.Split(",");
    
    for (uint i = 0; i < rawElements.Length; i++) {
        string element = rawElements[i].Trim();
        if (element.StartsWith("\"") && element.EndsWith("\"")) {
            element = element.SubStr(1, element.Length - 2);
        }
        elements.InsertLast(element);
    }

    return elements;
}

void LoadBlockAndItemLists() {
    knownBlocks = LoadJsonArray("src/data/BlockNames.json");
    knownItems = LoadJsonArray("src/data/ItemNames.json");
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
    if (editor is null) { g_currentBlock = ""; g_currentItem = ""; return; }
    
    CheckChanges(editor);
}

void CheckChanges(CGameCtnEditorFree@ e) {

    string selectedNodeName = e.PluginMapType.Inventory.CurrentSelectedNode.Name;

    if (selectedNodeName != "") {
        g_latestChange = selectedNodeName;
    }
}