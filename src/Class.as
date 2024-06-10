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
    const int confirmationDuration = 10000;

    string latestChange = "placeholder latest change";
}

array<ComponentInfo> components;
class ComponentInfo {
    int id; // Used as an index for the component
    
    array<string> componentInputArray;
    string componentOutput;

    vec3 position;
    vec3 rotation; // Yaw, Pitch, Roll

    MethodType methodType;
    ComponentType componentType;

    ComponentInfo(uint _id = 0, const vec3 &in _pos = vec3(0, 0, 0), const vec3 &in _rot = vec3(0, 0, 0)) {
        id = _id;
        position = _pos;
        rotation = _rot;
    }
}