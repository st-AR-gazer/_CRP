[Setting name="Show Interface"]
bool S_showInterface = true;

string g_currUserName = "placeholder username";
const string g_version = "0.1.0";
string g_creationDate = "2021-07-01";

string g_className = "placeholder class name";
string g_description = "placeholder class description";



array<array<string>> blockInputsArray;
array<string> blockOutputs;
array<MethodType> methodTypes;
array<vec3> coordsXYZArray;
array<vec3> rotationYPRArray;

enum MethodType {
    REPLACE,
    DELETE,
    ADD,
    MOVE
};

string g_currentBlock = "placeholder block name";
string g_currentItem = "placeholder item name";
string g_latestChange = "placeholder latest change";

string g_previousBlock = g_currentBlock;
string g_previousItem = g_currentItem;

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
    if (editor is null) return;
    
    BlockCheck(editor);
    ItemCheck(editor);
}

bool g_blockHasBeenChanged;

void BlockCheck(CGameCtnEditorFree@ e) {
    if (e.CurrentBlockInfo is null) return;
    string newBlock = e.CurrentBlockInfo.Name;

    // bool t_blockHasBeenChanged = false;

    if (g_currentBlock != newBlock) {
        g_previousBlock = g_currentBlock;
        g_currentBlock = newBlock;

        g_blockHasBeenChanged = true;
    }
}

void ItemCheck(CGameCtnEditorFree@ e) {
    auto cim = cast<CGameItemModel>(e.CurrentItemModel);
    if (cim is null) return;
    auto article = cast<CGameCtnArticle>(cim.ArticlePtr);
    if (article is null) return;

    bool t_itemHasBeenChanged = false;

    string newItem = article.Name;
    if (g_currentItem != newItem) {
        g_previousItem = g_currentItem;
        g_currentItem = newItem;

        t_itemHasBeenChanged = true;
    }

    if (g_blockHasBeenChanged) {
        g_latestChange = g_currentBlock;

        g_blockHasBeenChanged = false;
    }
    
    if (t_itemHasBeenChanged) {
        g_latestChange = g_currentItem;

        t_itemHasBeenChanged = false;
    }
}

void Main() {
    while (true) {
        CallFunc();
        yield();
    }
    log("Auto Alteration (Custom Replace Profiles) v" + g_version + " loaded.", LogLevel::Info, 68, "Main");
}
