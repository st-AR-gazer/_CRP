string filePath = "";
bool showAllItems = true;
uint g_hiddenCount = 0;

enum BlockType {
    AUTO,
    BLOCK,
    ITEM,
    CUSTOM
}

array<BlockType> g_blockTypes;
bool showTruncateConfirmation = false;
int truncateStartTime = 0;
const int confirmationDuration = 10000; // 10 seconds

void RenderMenu() {
    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z CRP (Auto Alteration) Helper", "", S_showInterface)) {
        S_showInterface = !S_showInterface;
    }
}

void RenderInterface() {
    if (!S_showInterface) return;

    if (UI::Begin(Colorize(Icons::Connectdevelop + Icons::Random + "CRP (Auto Alteration) Helper", {"0063eC", "33FFFF"}), S_showInterface, UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize)) {
        
        UI::Text("Static Information");
        UI::Text("Current User: " + g_currUserName);
        UI::Text("Version: " + g_version);
        UI::Text("Creation Date: " + g_creationDate);
        UI::Separator();

        UI::Text("Class Information");
        g_className = UI::InputText("Class/File Name: ", g_className);
        g_description = UI::InputText("Description: ", g_description);
        UI::Separator();

        UI::Text("Current Block/Item Information");
        UI::Text("Latest Change: " + Colorize(g_latestChange, {"fff7b3", "d1f799"}));
        UI::Separator();

        UI::Text("List of combos to replace/delete/add/move:");
        
        if (UI::ButtonColored("Truncate All", 0.0f, 0.6f, 0.6f)) {
            showTruncateConfirmation = true;
            truncateStartTime = Time::Now;
        }
        UI::SameLine();
        uint hiddenCount = 0;
        if (UI::Button(showAllItems ? "Hide Indexes" : "Show Indexes")) { showAllItems = !showAllItems; }
        
        UI::Text("Hidden Items: " + g_hiddenCount);
        UI::Separator();

        if (showTruncateConfirmation) {
            int timeLeft = (confirmationDuration - (Time::Now - truncateStartTime)) / 1000;
            if (timeLeft > 0) {
                if (UI::ButtonColored("Are you sure? Click to confirm (" + timeLeft + "s left)", 1.0f, 0.0f, 0.0f)) {
                    TruncateAll();
                    showTruncateConfirmation = false;
                }
            } else {
                showTruncateConfirmation = false;
            }
            UI::Separator();
        }

        for (uint i = 0; i < g_blockInputsArray.Length; i++) {
            if (!showAllItems && i < g_blockInputsArray.Length - 3) {
                hiddenCount++;
                g_hiddenCount = hiddenCount;
                continue;
            }

            UI::Text("Index " + (i + 1));
            UI::SameLine();
            UI::Text("Method: " + MethodTypeToString(g_methodTypes[i]));
            UI::SameLine();
            UI::Text("Block Inputs:");

            RenderBlockTypeUI(i);
            bool isLastIndex = (i == g_blockInputsArray.Length - 1);
            float h = isLastIndex ? 0.33f : 0.61f;

            if (UI::ButtonColored("Add Input to Index " + (i + 1), h, 0.6f, 0.6f)) {
                bool exists = false;
                for (uint k = 0; k < g_blockInputsArray[i].Length; k++) {
                    if (g_blockInputsArray[i][k] == g_latestChange) {
                        exists = true;
                        break;
                    }
                }
                if (!exists && g_latestChange != "") {
                    g_blockInputsArray[i].InsertLast(g_latestChange);
                }
            }
            UI::SameLine();
            if (UI::ButtonColored("Add Output to Index " + (i + 1), h, 0.6f, 0.6f)) {
                g_blockOutputs[i] = g_latestChange;
            }
            UI::SameLine();
            if (UI::ButtonColored("Delete Index " + (i + 1), 0.0f, 0.6f, 0.6f)) {
                g_blockInputsArray.RemoveAt(i);
                g_blockOutputs.RemoveAt(i);
                g_methodTypes.RemoveAt(i);
                g_coordsXYZArray.RemoveAt(i);
                g_rotationYPRArray.RemoveAt(i);
                g_blockTypes.RemoveAt(i);
                i--;
            }
            UI::Separator();

            switch (g_methodTypes[i]) {
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
            UI::Separator();
        }
        UI::Separator();

        if (UI::Button("Add New Block/Item Combo")) {
            g_blockInputsArray.InsertLast(array<string>());
            g_blockOutputs.InsertLast("");
            g_methodTypes.InsertLast(MethodType::REPLACE);
            g_coordsXYZArray.InsertLast(vec3());
            g_rotationYPRArray.InsertLast(vec3());
            g_blockTypes.InsertLast(BlockType::AUTO);
        }
        
        RenderSaveOptions();

        UI::End();
    }
}

void RenderReplaceUI(uint index) {
    for (uint j = 0; j < g_blockInputsArray[index].Length; j++) {
        g_blockInputsArray[index][j] = UI::InputText("Input " + (index + 1) + "_" + (j + 1), g_blockInputsArray[index][j]);
        UI::SameLine();
        if (UI::ButtonColored("Delete##Input" + (index + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
            g_blockInputsArray[index].RemoveAt(j);
            j--;
        }
    }
    g_blockOutputs[index] = UI::InputText("New Output " + (index + 1), g_blockOutputs[index]);
}

void RenderDeleteUI(uint index) {
    for (uint j = 0; j < g_blockInputsArray[index].Length; j++) {
        g_blockInputsArray[index][j] = UI::InputText("Input " + (index + 1) + "_" + (j + 1), g_blockInputsArray[index][j]);
        UI::SameLine();
        if (UI::ButtonColored("Delete##Input" + (index + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
            g_blockInputsArray[index].RemoveAt(j);
            j--;
        }
    }
}

void RenderPlaceUI(uint index) {
    g_blockOutputs[index] = UI::InputText("New Output " + (index + 1), g_blockOutputs[index]);
    g_coordsXYZArray[index] = UI::InputFloat3("Position " + (index + 1), g_coordsXYZArray[index]);
    g_rotationYPRArray[index] = UI::InputFloat3("Rotation " + (index + 1), g_rotationYPRArray[index]);
}

void RenderPlaceRelativeUI(uint index) {
    for (uint j = 0; j < g_blockInputsArray[index].Length; j++) {
        g_blockInputsArray[index][j] = UI::InputText("Input " + (index + 1) + "_" + (j + 1), g_blockInputsArray[index][j]);
        UI::SameLine();
        if (UI::ButtonColored("Delete##Input" + (index + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
            g_blockInputsArray[index].RemoveAt(j);
            j--;
        }
    }
    g_blockOutputs[index] = UI::InputText("New Output " + (index + 1), g_blockOutputs[index]);
}

void RenderBlockTypeUI(uint index) {
    if (UI::RadioButton("Replace##" + (index + 1), g_methodTypes[index] == MethodType::REPLACE)) {
        g_methodTypes[index] = MethodType::REPLACE;
    }
    UI::SameLine();
    if (UI::RadioButton("Delete##" + (index + 1), g_methodTypes[index] == MethodType::DELETE)) {
        g_methodTypes[index] = MethodType::DELETE;
    }
    UI::SameLine();
    if (UI::RadioButton("Place##" + (index + 1), g_methodTypes[index] == MethodType::PLACE)) {
        g_methodTypes[index] = MethodType::PLACE;
    }
    UI::SameLine();
    if (UI::RadioButton("PlaceRelative##" + (index + 1), g_methodTypes[index] == MethodType::PLACERELATIVE)) {
        g_methodTypes[index] = MethodType::PLACERELATIVE;
    }

    if (UI::RadioButton("Auto##" + (index + 1), g_blockTypes[index] == BlockType::AUTO)) {
        g_blockTypes[index] = BlockType::AUTO;
    }
    UI::SameLine();
    if (UI::RadioButton("Block##" + (index + 1), g_blockTypes[index] == BlockType::BLOCK)) {
        g_blockTypes[index] = BlockType::BLOCK;
    }
    UI::SameLine();
    if (UI::RadioButton("Item##" + (index + 1), g_blockTypes[index] == BlockType::ITEM)) {
        g_blockTypes[index] = BlockType::ITEM;
    }
    UI::SameLine();
    if (UI::RadioButton("Custom##" + (index + 1), g_blockTypes[index] == BlockType::CUSTOM)) {
        g_blockTypes[index] = BlockType::CUSTOM;
    }
}

void RenderSaveOptions() {
    if (UI::Button("Save")) {
        GenerateCSharpClass();
    }
    UI::SameLine();
    if (filePath != "") {
        if (UI::Button("Open Folder")) { _IO::OpenFolder(IO::FromStorageFolder("")); }
        UI::Text("File saved at: " + filePath);
    }
}

void TruncateAll() {
    g_blockInputsArray.Resize(0);
    g_blockOutputs.Resize(0);
    g_methodTypes.Resize(0);
    g_coordsXYZArray.Resize(0);
    g_rotationYPRArray.Resize(0);
    g_blockTypes.Resize(0);
}
