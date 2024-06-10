[Setting name="Show Interface"]
bool S_showInterface = true;

void Main() {
    InitializeAllowedCharacters();
    LoadBlockAndItemLists();

    while (true) {
        CallFunc();
        yield();
    }
    log("Auto Alteration (Custom Replace Profiles) v " +  + " loaded.", LogLevel::Info, 41, "Main");
}

void CallFunc() {
    auto app = cast<CTrackMania>(GetApp());
    if (app is null) return;
    auto editor = cast<CGameCtnEditorFree>(app.Editor);
    if (editor is null) { return; }
    CheckChanges(editor);

    auto net = cast<CGameNetwork>(app.Network);
    if (net is null) return;
    CTrackManiaPlayerInfo@ playerInfo = cast<CTrackManiaPlayerInfo>(net.PlayerInfos[0]);
    if (playerInfo is null) return;
    general.userName = playerInfo.Name;

    auto map = cast<CGameCtnChallenge>(app.RootMap);
    if (map is null) return;
}

void CheckChanges(CGameCtnEditorFree@ e) {
    string selectedNodeName = e.PluginMapType.Inventory.CurrentSelectedNode.Name;

    if (selectedNodeName != "") {
        ui.latestChange = selectedNodeName;
    }
}