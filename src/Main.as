[Setting name="Show Interface"]
bool S_showInterface = true;

string g_currUserName = "placeholder username";
const string g_version = "0.1.0";
string g_creationDate = "2021-07-01";

string g_className = "placeholder class name";
string g_description = "placeholder class description";

string g_currentBlock = "placeholder block name";
string g_currentItem = "placeholder item name";

array<array<string>> blockInputsArray;
array<string> blockOutputs;
array<MethodType> methodTypes;
array<string> coordsXYZArray;
array<string> rotationYPRArray;

enum MethodType {
    REPLACE,
    DELETE,
    ADD
};


string g_previousBlock = g_currentBlock;
string g_previousItem = g_currentItem;

void Update(float dt) {
    auto app = cast<CTrackMania>(GetApp());
    if (app is null) return;

    auto map = cast<CGameCtnChallenge>(app.RootMap);
    if (app.RootMap is null) return;

    auto editor = cast<CGameCtnEditorFree>(app.Editor);
    if (app.Editor is null) return;

    auto net = cast<CGameNetwork>(app.Network);
    if (app.Network is null) return;

    CTrackManiaPlayerInfo@ playerInfo = cast<CTrackManiaPlayerInfo>(net.PlayerInfos[0]);
    if (playerInfo is null) return;

    g_currUserName = playerInfo.Name;
    g_creationDate = app.OSUTCDate;

    string newBlock = editor.CurrentBlockInfo.Name;
    string newItem = editor.CurrentItemModel.Name;

    if (newBlock != g_previousBlock) {
        g_currentBlock = newBlock;
        g_previousBlock = g_currentBlock;
    }

    if (newItem != g_previousItem) {
        g_currentItem = newItem;
        g_previousItem = g_currentItem;
    }
}

void Main() {
    log("Auto Alteration (Custom Rplace Profiles) v" + g_version + " loaded.", LogLevel::Info, 144, "Main");
}
