string filePath = "";
bool showAllItems = true;
uint g_hiddenCount = 0;

void RenderMenu() {
    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z CRP (Auto Alteration) Helper", "", S_showInterface)) {
        S_showInterface = !S_showInterface;
    }
}

void RenderInterface() {
    if (g_currentItem == "New Item") {
        g_currentItem = "placeholder item name";
    }
    if (g_currentBlock == "New Block") {
        g_currentBlock = "placeholder block name";
    }

    if (!S_showInterface) return;

    if (UI::Begin("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z CRP (Auto Alteration) Helper", S_showInterface, UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize)) {

        UI::Text(ColorizeString("Static Information"));
        UI::Text("Current User: " + g_currUserName);
        UI::Text("Version: " + g_version);
        UI::Text("Creation Date: " + g_creationDate);

        UI::Separator();
        UI::Separator();

        UI::Text(ColorizeString("Class Information"));
        g_className = UI::InputText("Class/File Name: ", g_className);
        g_description = UI::InputText("Description: ", g_description);

        UI::Separator();
        UI::Separator();

        UI::Text(ColorizeString("Current Block/Item Information"));
        UI::Text((g_latestChange == g_currentBlock ? ColorizeString("Current Block: " + g_currentBlock + " <--") : "Current Block: " + g_currentBlock));
        UI::Text((g_latestChange == g_currentItem ? ColorizeString("Current Item: " + g_currentItem + " <--") : "Current Item: " + g_currentItem));
        UI::Text(ColorizeString("Latest Change: " + g_latestChange));

        UI::Separator();
        UI::Separator();

        UI::Text(ColorizeString("List of combos to replace/delete/add/move:"));
        if (g_blockInputsArray.Length != 0) {
            if (UI::Button("Truncate All")) { DeleteAll(); }
        }

        uint hiddenCount = 0;
        if (g_hiddenCount > 0) {
            UI::Text("Hidden Items: " + g_hiddenCount);
            if (UI::Button("Reveal Hidden")) {
                showAllItems = !showAllItems;
            }
        }

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
            if (UI::RadioButton("Add##" + (i + 1), g_methodTypes[i] == MethodType::ADD)) {
                g_methodTypes[i] = MethodType::ADD;
            }
            UI::SameLine();
            if (UI::RadioButton("Move##" + (i + 1), g_methodTypes[i] == MethodType::MOVE)) {
                g_methodTypes[i] = MethodType::MOVE;
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
        }

        UI::Separator();

        if (UI::Button("Save")) {
            Json::Value settings = CreateFile();
            string fileName = g_className + ".json";
            filePath = IO::FromStorageFolder(fileName);

            IO::File file(filePath, IO::FileMode::Write);
            file.Write(Json::Write(settings));
            file.Close();
        }

        if (filePath != "") {
            if (UI::Button("Open Folder")) {
                OpenFolder(IO::FromStorageFolder(""));
            }
            UI::Text("File saved at: " + filePath);
        }

        UI::End();
    }
}
