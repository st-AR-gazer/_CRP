string baseDataUrl = "http://maniacdn.net/ar_/Custom-Replace-Profiles/Plugin/";
string localSaveLocation = IO::FromStorageFolder("Data/");

[Setting name="Should Download New Files"]
bool shouldDownloadNewFiles = true;

void DownloadDataFromCDN() {
    g_currentVersion = GetCurrentVersion();

    if (g_manifestVersion != g_currentVersion) {
        log("Manifest Version " + g_manifestVersion + " does not match local version " + g_currentVersion + ", updating the local file with the version specified in the manifest.", LogLevel::Info, 8, "DownloadDataFromCDN");
    } else { return; }

    if (!shouldDownloadNewFiles) return;
    
    DownloadData(baseDataUrl + "Inventory.json", "Inventory.json", localSaveLocation);
    log("Attempted to download the stripped Inventory JSON file", LogLevel::Info, 16, "DownloadDataFromCDN");
}

void DownloadData(const string &in url, const string &in fileName, const string &in localSaveLocation) {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) { yield(); }

    if (req.ResponseCode() == 200) {
        auto data = req.String();
        StoreDatafile(data, fileName, localSaveLocation);
    } else {
        log("Response code " + req.ResponseCode() + " Error | URL: " + url, LogLevel::Error, 38, "DownloadData");
    }
}

void StoreDatafile(const string &in data, const string &in fileName, const string &in filePath) {
    string fullFilePathName = filePath + fileName;

    _IO::SafeSaveToFile(fullFilePathName, data);

    log("Data written to file: " + fullFilePathName, LogLevel::Info, 54, "StoreDatafile");
}
