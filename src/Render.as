

void RenderMenu() {
    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z CRP (Auto Alteration) Helper", "", S_showInterface)) {
        S_showInterface = !S_showInterface;
    }
}

void RenderInterface() {
    if (!S_showInterface) return;

    if (UI::Begin(Colorize(Icons::Connectdevelop + Icons::Random + "CRP (Auto Alteration) Helper", {"0063eC", "33FFFF"}), S_showInterface, UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize)) {
        
        // Static Information
        UI::Text("Static Information");
        UI::Text("Current User: " + general.userName);
        UI::Text("Version: " + general.version);
        UI::Text("Creation Date: " + general.creationDate);
        UI::Separator();

        // Class Information
        UI::Text("Class Information");
        _UI::SimpleTooltip("The name of the class/file that will be generated, please note that the name has restrictions, but the description does not.");
        general.className = UI::InputText("Class/File Name: ", general.className);
        general.description = UI::InputText("Description: ", general.description);
        UI::Separator();

        // Current Block/Item Information
        UI::Text("Current Block/Item Information");
        UI::Text("Latest Change: " + Colorize(ui.latestChange, {"fff7b3", "d1f799"}));
        UI::Separator();

        // List of Combos
        UI::Text("List of combos to replace/delete/add/move:");

        if (UI::ButtonColored("Truncate All", 0.0f, 0.6f, 0.6f)) {
            ui.showTruncateConfirmation = true;
            ui.truncateStartTime = Time::Now;
        }
        UI::SameLine();
        uint hiddenCount = 0;
        if (UI::Button(ui.showAllItems ? "Hide Indexes" : "Show Indexes")) { ui.showAllItems = !ui.showAllItems; }
        
        UI::Text("Hidden Items: " + ui.hiddenCount);
        UI::Separator();

        if (ui.showTruncateConfirmation) {
            int timeLeft = (ui.confirmationDuration - (Time::Now - ui.truncateStartTime)) / 1000;
            if (timeLeft > 0) {
                if (UI::ButtonColored("Are you sure? Click 'HERE' to confirm (" + timeLeft + "s left)", 1.0f, 0.0f, 0.0f)) {
                    TruncateAll();
                    ui.showTruncateConfirmation = false;
                }
            } else {
                ui.showTruncateConfirmation = false;
            }
            UI::Separator();
        }

        for (uint i = 0; i < components.Length; i++) {
            if (!ui.showAllItems && i < components.Length - 3) {
                hiddenCount++;
                ui.hiddenCount = hiddenCount;
                continue;
            }

            UI::Text("Index " + (i + 1));
            UI::SameLine();
            UI::Text("Method: " + MethodTypeToString(components[i].methodType));
            UI::SameLine();
            UI::Text("Block Inputs:");

            RenderBlockTypeUI(i);
            bool isLastIndex = (i == components.Length - 1);
            float h = isLastIndex ? 0.33f : 0.61f;

            if (UI::ButtonColored("Add Input to Index " + (i + 1), h, 0.6f, 0.6f)) {
                bool exists = false;
                for (uint k = 0; k < components[i].componentInputArray.Length; k++) {
                    if (components[i].componentInputArray[k] == ui.latestChange) {
                        exists = true;
                        break;
                    }
                }
                if (!exists && ui.latestChange != "") {
                    components[i].componentInputArray.InsertLast(ui.latestChange);
                }
            }
            UI::SameLine();
            if (MethodTypeToString(components[i].methodType) != "delete") {
                if (UI::ButtonColored("Add Output to Index " + (i + 1), h, 0.6f, 0.6f)) {
                    components[i].componentOutput = ui.latestChange;
                }
            }
              
            UI::SameLine();
            if (UI::ButtonColored("Delete Index " + (i + 1), 0.0f, 0.6f, 0.6f)) {
                components.RemoveAt(i);
                i--;
                continue;
            }
            UI::Separator();

            switch (components[i].methodType) {
                case MethodType::REPLACE:
                    RenderReplaceUI(i);
                    break;
                case MethodType::DELETE:
                    RenderDeleteUI(i);
                    break;
                case MethodType::PLACE:
                    RenderPlaceUI(i);
                    break;
                case MethodType::PLACERELATIVE:
                    RenderPlaceRelativeUI(i);
                    break;
            }
        }
        UI::Separator();

        if (UI::Button("Add New Block/Item Combo")) {
            components.InsertLast(ComponentInfo());
        }
        
        // Save Options
        RenderSaveOptions();

        UI::End();
    }
}

void RenderReplaceUI(uint index) {
    for (uint j = 0; j < components[index].componentInputArray.Length; j++) {
        components[index].componentInputArray[j] = UI::InputText("Input " + (index + 1) + "_" + (j + 1), components[index].componentInputArray[j]);
        UI::SameLine();
        if (UI::ButtonColored("Delete##Input" + (index + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
            components[index].componentInputArray.RemoveAt(j);
            j--;
        }
    }
    UI::Separator();
    components[index].componentOutput = UI::InputText("New Output " + (index + 1), components[index].componentOutput);
    UI::Separator();
}

void RenderDeleteUI(uint index) {
    for (uint j = 0; j < components[index].componentInputArray.Length; j++) {
        components[index].componentInputArray[j] = UI::InputText("Input " + (index + 1) + "_" + (j + 1), components[index].componentInputArray[j]);
        UI::SameLine();
        if (UI::ButtonColored("Delete##Input" + (index + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
            components[index].componentInputArray.RemoveAt(j);
            j--;
        }
    }
}

void RenderPlaceUI(uint index) {
    components[index].componentOutput = UI::InputText("New Output " + (index + 1), components[index].componentOutput);
    components[index].position = UI::InputFloat3("Position " + (index + 1), components[index].position);
    components[index].rotation = UI::InputFloat3("Rotation " + (index + 1), components[index].rotation);
}

void RenderPlaceRelativeUI(uint index) {
    for (uint j = 0; j < components[index].componentInputArray.Length; j++) {
        components[index].componentInputArray[j] = UI::InputText("Input " + (index + 1) + "_" + (j + 1), components[index].componentInputArray[j]);
        UI::SameLine();
        if (UI::ButtonColored("Delete##Input" + (index + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
            components[index].componentInputArray.RemoveAt(j);
            j--;
        }
    }
    components[index].componentOutput = UI::InputText("New Output " + (index + 1), components[index].componentOutput);
}

void RenderBlockTypeUI(uint index) {
    if (UI::RadioButton("Replace##" + (index + 1), components[index].methodType == MethodType::REPLACE)) {
        components[index].methodType = MethodType::REPLACE;
    }
    UI::SameLine();
    if (UI::RadioButton("Delete##" + (index + 1), components[index].methodType == MethodType::DELETE)) {
        components[index].methodType = MethodType::DELETE;
    }
    UI::SameLine();
    if (UI::RadioButton("Place##" + (index + 1), components[index].methodType == MethodType::PLACE)) {
        components[index].methodType = MethodType::PLACE;
    }
    UI::SameLine();
    if (UI::RadioButton("PlaceRelative##" + (index + 1), components[index].methodType == MethodType::PLACERELATIVE)) {
        components[index].methodType = MethodType::PLACERELATIVE;
    }

    bool showAuto = components[index].componentType == ComponentType::AUTO;

    if (showAuto) {
        if (UI::RadioButton("Auto##" + (index + 1), components[index].componentType == ComponentType::AUTO)) {
            components[index].componentType = ComponentType::AUTO;
        }
        UI::SameLine();
    }
    if (UI::RadioButton("Block##" + (index + 1), components[index].componentType == ComponentType::BLOCK)) {
        components[index].componentType = ComponentType::BLOCK;
    }
    UI::SameLine();
    if (UI::RadioButton("Item##" + (index + 1), components[index].componentType == ComponentType::ITEM)) {
        components[index].componentType = ComponentType::ITEM;
    }
    UI::SameLine();
    if (UI::RadioButton("Custom##" + (index + 1), components[index].componentType == ComponentType::CUSTOM)) {
        components[index].componentType = ComponentType::CUSTOM;
    }
}

void RenderSaveOptions() {
    bool isClassNameValid = IsValidClassName(general.className);
    if (!isClassNameValid) {
        UI::Text("Class name can only contain alphabetic characters and underscores.");
    }
    if (_UI::DisabledButton(!isClassNameValid, "Save")) {
        string classContent = GenerateCSharpClass();
        if (classContent != "") {
            string folderPath = IO::FromStorageFolder("CRP/");
            ui.filePath = folderPath + general.className + ".cs";
            if (!IO::FolderExists(IO::FromStorageFolder("CRP/"))) {
                IO::CreateFolder(IO::FromStorageFolder("CRP/"));
            }
            _IO::SaveToFile(IO::FromStorageFolder("CRP/" + general.className + ".cs"), classContent);
        }
    }
    UI::SameLine();
    if (ui.filePath != "") {
        if (UI::Button("Open Folder")) { _IO::OpenFolder(IO::FromStorageFolder("")); }
        UI::Text("File saved at: " + ui.filePath);
    }
}

void TruncateAll() {
    components.Resize(0);
}
