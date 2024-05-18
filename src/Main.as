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

void Update(float dt) {
    auto app = cast<CTrackMania>(GetApp());
    if (app is null) return;

    auto map = cast<CGameCtnChallenge>(app.RootMap);
    if (map is null) return;

    auto editor = cast<CGameCtnEditorFree>(app.Editor);
    if (editor is null) return;

    CGameCtnArticle@ article = cast<CGameCtnArticle>(editor.CurrentItemModel.ArticlePtr);
    if (article is null) return;

    auto net = cast<CGameNetwork>(app.Network);
    if (net is null) return;

    CTrackManiaPlayerInfo@ playerInfo = cast<CTrackManiaPlayerInfo>(net.PlayerInfos[0]);
    if (playerInfo is null) return;

    g_currUserName = playerInfo.Name;
    g_creationDate = app.OSUTCDate;

    string newBlock = editor.CurrentBlockInfo.Name;
    string newItem = article.Name;

    bool t_blockHasBeenChanged = false;
    bool t_itemHasBeenChanged = false;

    if (g_currentBlock != newBlock) {
        g_previousBlock = g_currentBlock;
        g_currentBlock = newBlock;

        t_blockHasBeenChanged = true;
    }

    if (g_currentItem != newItem) {
        g_previousItem = g_currentItem;
        g_currentItem = newItem;

        t_itemHasBeenChanged = true;
    }

    if (t_blockHasBeenChanged) {
        g_latestChange = g_currentBlock;

        t_blockHasBeenChanged = false;
    }
    
    if (t_itemHasBeenChanged) {
        g_latestChange = g_currentItem;

        t_itemHasBeenChanged = false;
    }
}

void Main() {
    log("Auto Alteration (Custom Replace Profiles) v" + g_version + " loaded.", LogLevel::Info, 68, "Main");
}
