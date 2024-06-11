string g_manifestUrl;
string pluginStorageVersionPath = IO::FromStorageFolder("currentVersion.json");
string manifestUrl = "http://maniacdn.net/ar_/CRP/manifest/manifest.json";

int g_manifestVersion;
int g_currentVersion;

void FetchManifest() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    req.Start();

    while (!req.Finished()) { yield(); }

    if (req.ResponseCode() == 200) {
        ParseManifest(req.String());
    } else {
        log("Error fetching manifest: " + req.ResponseCode(), LogLevel::Error, 26, "FetchManifest");
    }
}

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) {
        log("Failed to parse JSON.", LogLevel::Error, 33, "ParseManifest");
        return;
    }

    g_manifestVersion = manifest["latestVersion"];
    UpdateCurrentVersionIfDifferent(g_manifestVersion);
}

void UpdateCurrentVersionIfDifferent(const int &in latestVersion) {
    int currentVersion = GetCurrentVersion();
    g_currentVersion = currentVersion;
    
    if (currentVersion != latestVersion) {
        DownloadDataFromCDN();
        UpdateVersionFile(latestVersion);
    }
}

int GetCurrentVersion() {
    string fileContents = _IO::ReadFileToEnd(pluginStorageVersionPath);
    
    Json::Value json = Json::Parse(fileContents);

    if (json.GetType() == Json::Type::Object) { return json["latestVersion"]; }

    log("JSON is not an object. JSON is: " + tostring(json.GetType()), LogLevel::Error, 72, "GetCurrentInstalledVersion");
    return -1;
}

void UpdateVersionFile(const int &in latestVersion) {
    Json::Value json = Json::Object();
    json["latestVersion"] = latestVersion;
    Json::ToFile(pluginStorageVersionPath, json);
}
