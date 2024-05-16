[Setting name="Show Interface"]
bool S_showInterface = true;

string g_currUserName = "placeholder username";
const string g_version = "0.1.0";
string g_creationDate = "2021-07-01";

string g_className = "placeholder class name";
string g_description = "placeholder class description";

array<array<string>> blockInputsArray;
array<string> blockOutputs;
array<string> methodTypes;
array<string> coordsXYZArray;
array<string> rotationYPRArray;

enum MethodType {
    REPLACE,
    DELETE,
    ADD
};

void RenderInterface() {
    if (!S_showInterface) return;

    if (UI::Begin("Random Map Picker", S_showInterface, UI::WindowFlags::AlwaysAutoResize)) {

        UI::Text("Static Information");
        UI::Separator();
        UI::Text("Current User: " + g_currUserName);
        UI::Text("Version: " + g_version);
        UI::Text("Creation Date: " + g_creationDate);
        UI::Separator();

        UI::Text("Dynamic Information");
        g_className = UI::InputText("Class/File Name: ", g_className);
        g_description = UI::InputText("Description: ", g_description);
        UI::Separator();

        UI::Text("Block Selection");

        Render_Block();

        if (UI::Button("Save")) {
            Json::Value settings = CreateFile();
            string fileName = g_className + ".json";
            string filePath = IO::FromDataFolder(fileName);

            IO::File file(filePath, IO::FileMode::Write);
            file.Write(tostring(settings));
            file.Close();
        }

        UI::End();
    }
}

void Render_Block() { 
    for (uint i = 0; i < blockInputsArray.Length; i++) {
        UI::Text("Block Combo " + (i + 1));
        for (uint j = 0; j < blockInputsArray[i].Length; j++) {
            blockInputsArray[i][j] = UI::InputText("Block Input " + (j + 1), blockInputsArray[i][j]);
        }
        blockOutputs[i] = UI::InputText("Block Output", blockOutputs[i]);
        methodTypes[i] = UI::InputText("Method (replace/delete/add)", methodTypes[i]);
        coordsXYZArray[i] = UI::InputText("Coords XYZ (if add)", coordsXYZArray[i]);
        rotationYPRArray[i] = UI::InputText("Rotation YPR (if add)", rotationYPRArray[i]);
    }

    if (UI::Button("Add New Block Combo")) {
        blockInputsArray.InsertLast(array<string>());
        blockOutputs.InsertLast("");
        methodTypes.InsertLast("");
        coordsXYZArray.InsertLast("");
        rotationYPRArray.InsertLast("");
    }
}

void Update(float dt) {
    auto app = cast<CTrackMania>(GetApp());
    if (app is null) return;

    auto map = cast<CGameCtnChallenge>(app.RootMap);
    if (app.RootMap is null) return;

    g_currUserName = app.LocalPlayer.Login;
    g_creationDate = Time::Format(Time::Now, "yyyy-MM-dd");
}

Json::Value CreateFile() {
    Json::Value settings = Json::Object();
    settings[g_className] = Json::Object();
    settings[g_className]["version"] = g_version;
    settings[g_className]["description"] = g_description;

    // metadata
    settings[g_className]["metadata"] = Json::Object();
    settings[g_className]["metadata"]["author"] = g_currUserName;
    settings[g_className]["metadata"]["creationDate"] = g_creationDate;

    // map
    settings[g_className]["map"] = Json::Array();
    for (uint i = 0; i < blockInputsArray.Length; i++) {
        Json::Value blockCombo = Json::Object();
        blockCombo["method"] = methodTypes[i];
        blockCombo["blockInput"] = Json::Array();
        for (uint j = 0; j < blockInputsArray[i].Length; j++) {
            blockCombo["blockInput"].Add(blockInputsArray[i][j]);
        }
        blockCombo["blockOutput"] = blockOutputs[i];
        if (methodTypes[i] == "add") {
            blockCombo["coordsXYZ"] = coordsXYZArray[i];
            blockCombo["rotationYPR"] = rotationYPRArray[i];
        }
        settings[g_className]["map"].Add(blockCombo);
    }

    return settings;
}

void Main() {
    log("Plugin started", LogLevel::Info, 123, "Main");    
}