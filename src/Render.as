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

void RenderMenu() {
    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z CRP (Auto Alteration) Helper", "", S_showInterface)) {
        S_showInterface = !S_showInterface;
    }
}

void RenderInterface() {
    if (!S_showInterface) return;

    if (UI::Begin("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z CRP (Auto Alteration) Helper", S_showInterface, UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize)) {
        
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
        UI::Text("Current Block: " + g_currentBlock);
        UI::Text("Current Item: " + g_currentItem);
        UI::Text("Latest Change: " + g_latestChange);
        UI::Separator();

        UI::Text("List of combos to replace/delete/add/move:");
        
        if (UI::ButtonColored("Truncate All", 0.0f, 0.6f, 0.6f)) { DeleteAll(); }
        UI::SameLine();
        uint hiddenCount = 0;
        if (UI::Button(showAllItems ? "Hide Indexes" : "Show Indexes")) { showAllItems = !showAllItems; }
        
        UI::Text("Hidden Items: " + g_hiddenCount);
        UI::Separator();

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

            if (g_blockInputsArray[i].Length > 0) {
                for (uint j = 0; j < g_blockInputsArray[i].Length; j++) {
                    g_blockInputsArray[i][j] = UI::InputText("Input " + (i + 1) + "_" + (j + 1), g_blockInputsArray[i][j]);
                    UI::SameLine();
                    if (UI::ButtonColored("Delete##Input" + (i + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
                        g_blockInputsArray[i].RemoveAt(j);
                        j--;
                    }
                }
            } else {
                UI::Text("No Inputs");
            }

            UI::Separator();

            g_blockOutputs[i] = UI::InputText("New Output " + (i + 1), g_blockOutputs[i]);

            UI::SameLine();
            if (UI::RadioButton("Replace##" + (i + 1), g_methodTypes[i] == MethodType::REPLACE)) {
                g_methodTypes[i] = MethodType::REPLACE;
            }
            UI::SameLine();
            if (UI::RadioButton("Delete##" + (i + 1), g_methodTypes[i] == MethodType::DELETE)) {
                g_methodTypes[i] = MethodType::DELETE;
            }
            UI::SameLine();
            if (UI::RadioButton("Place##" + (i + 1), g_methodTypes[i] == MethodType::PLACE)) {
                g_methodTypes[i] = MethodType::PLACE;
            }
            UI::SameLine();
            if (UI::RadioButton("PlaceRelative##" + (i + 1), g_methodTypes[i] == MethodType::PLACERELATIVE)) {
                g_methodTypes[i] = MethodType::PLACERELATIVE;
            }

            UI::Text("Block Type: ");
            if (UI::RadioButton("Auto##" + (i + 1), g_blockTypes[i] == BlockType::AUTO)) {
                g_blockTypes[i] = BlockType::AUTO;
            }
            UI::SameLine();
            if (UI::RadioButton("Block##" + (i + 1), g_blockTypes[i] == BlockType::BLOCK)) {
                g_blockTypes[i] = BlockType::BLOCK;
            }
            UI::SameLine();
            if (UI::RadioButton("Item##" + (i + 1), g_blockTypes[i] == BlockType::ITEM)) {
                g_blockTypes[i] = BlockType::ITEM;
            }
            UI::SameLine();
            if (UI::RadioButton("Custom##" + (i + 1), g_blockTypes[i] == BlockType::CUSTOM)) {
                g_blockTypes[i] = BlockType::CUSTOM;
            }

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
        }

        if (UI::Button("Add New Block/Item Combo")) {
            g_blockInputsArray.InsertLast(array<string>());
            g_blockOutputs.InsertLast("");
            g_methodTypes.InsertLast(MethodType::REPLACE);
            g_coordsXYZArray.InsertLast(vec3());
            g_rotationYPRArray.InsertLast(vec3());
            g_blockTypes.InsertLast(BlockType::AUTO);
        }

        UI::Separator();

        RenderSaveOptions();

        UI::End();
    }
}

void RenderSaveOptions() {
    if (UI::Button("Save")) {
        GenerateCSharpClass();
    }
    if (filePath != "") {
        if (UI::Button("Open Folder")) { _IO::OpenFolder(IO::FromStorageFolder("")); }
        UI::Text("File saved at: " + filePath);
    }
}
