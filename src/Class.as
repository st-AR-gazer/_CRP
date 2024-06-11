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

    void CheckChanges(CGameCtnEditorFree@ e) {
        string selectedNodeName = e.PluginMapType.Inventory.CurrentSelectedNode.Name;

        if (selectedNodeName != "") {
            latestChange = selectedNodeName;
        }
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

    bool IsCompenentInputKnown() {
        for (uint i = 0; i < g_knownComponents.Length; i++) {
            if (componentInputArray.Find(g_knownComponents[i]) != -1) {
                return true;
            }
        }
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
