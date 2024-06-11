GeneralInfo general;
class GeneralInfo {
    string userName;
    string version = Meta::ExecutingPlugin().Version;
    string creationDate = GetApp().OSUTCDate;

    string className = "placeholder class name";
    string description = "placeholder class description";

    GeneralInfo() {
        auto app = cast<CTrackMania>(GetApp()); 
        auto net = cast<CGameNetwork>(app.Network); 
        auto playerInfo = cast<CTrackManiaPlayerInfo>(net.PlayerInfos[0]);
        
        userName = playerInfo.Name;
    }
}

UiInfo ui;
class UiInfo {
    string filePath = IO::FromStorageFolder("CRP/");

    bool showAllItems = true;
    uint hiddenCount = 0;
    
    int truncateStartTime = 0;
    bool showTruncateConfirmation = false;
    int confirmationDuration = 10000;

    string latestChange = "placeholder latest change";

    array<dictionary> inventoryData;

    UiInfo() {
        LoadInventoryData();
    }

    void CheckChanges(CGameCtnEditorFree@ e) {
        string selectedNodeName = e.PluginMapType.Inventory.CurrentSelectedNode.Name;

        if (selectedNodeName != "") {
            latestChange = selectedNodeName;
        }
    }

    void LoadInventoryData() {
        string jsonContent = _IO::ReadFileToEnd(IO::FromStorageFolder("DownloadedData/Inventory.json"));
        if (jsonContent != "" && latestChange != "placeholder latest change") {
            Json::Value root = Json::Parse(jsonContent);
            for (uint i = 0; i < root.Length; i++) {
                dictionary item;
                item["name"] = root[i]["name"];
                item["keywords"] = array<string>();
                for (uint j = 0; j < root[i]["keywords"].Length; j++) {
                    cast<array<string>>(item["keywords"]).InsertLast(root[i]["keywords"][j]);
                }
                inventoryData.InsertLast(item);
            }
        }
    }

    array<string> GetArticlesForLatestChange() {
        array<string> articles;
        for (uint i = 0; i < inventoryData.Length; i++) {
            if (string(inventoryData[i]["name"]) == latestChange) {
                articles = cast<array<string>>(inventoryData[i]["keywords"]);
                break;
            }
        }
        return articles;
    }
}

array<ComponentInfo> components;
class ComponentInfo {
    int index;
    
    vec3 position;
    vec3 rotation; // Yaw, Pitch, Roll

    array<string> componentInputArray;
    string componentOutput;

    bool hidden = false;
    bool isComponentKnown = false;

    MethodType methodType;
    ComponentType componentType;

    // Default constructor
    ComponentInfo() {
        index = 0;
        position = vec3(0, 0, 0);
        rotation = vec3(0, 0, 0);
    }

    // Parameterized constructor
    ComponentInfo(uint _index, const vec3 &in _pos = vec3 ( ), const vec3 &in _rot = vec3 ( )) {
        index = _index;
        position = _pos;
        rotation = _rot;
    }

    bool IsComponentInputKnown() {
        for (uint i = 0; i < g_knownComponents.Length; i++) {
            if (componentInputArray.Find(g_knownComponents[i]) != -1) {
                isComponentKnown = true;
                return true;
            }
        }
        isComponentKnown = false;
        return false;
    }
}

void AddNewComponent() {
    uint newIndex = components.Length;
    components.InsertLast(ComponentInfo(newIndex));
}

void RemoveComponent(uint index) {
    components.RemoveAt(index);
    for (uint i = index; i < components.Length; i++) {
        components[i].index = i;
    }
}
