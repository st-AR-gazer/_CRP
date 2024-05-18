string filePath = "";

void Render() {
    if (g_currentItem == "New Item") {
        g_currentItem = "placeholder item name";
    }
    if (g_currentBlock == "New Block") {
        g_currentBlock = "placeholder block name";
    }

    if (!S_showInterface) return;

    if (UI::Begin("CRP (Auto Alteration) Helper", S_showInterface, UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize)) {

        UI::Text(ColorizeString("Static Information"));
        UI::Text("Current User: " + g_currUserName);
        UI::Text("Version: " + g_version);
        UI::Text("Creation Date: " + g_creationDate);

        UI::Separator();
        UI::Separator();
        UI::Separator();

        UI::Text(ColorizeString("Class Information"));
        g_className = UI::InputText("Class/File Name: ", g_className);
        g_description = UI::InputText("Description: ", g_description);

        UI::Separator();
        UI::Separator();
        UI::Separator();

        UI::Text(ColorizeString("Current Block/Item Information"));
        UI::Text((g_latestChange == g_currentBlock ? ColorizeString("Current Block: " + g_currentBlock + " <--") : "Current Block: " + g_currentBlock));
        UI::Text((g_latestChange == g_currentItem ? ColorizeString("Current Item: " + g_currentItem + " <--") : "Current Item: " + g_currentItem));
        UI::Text(ColorizeString("Latest Change: " + g_latestChange));

        UI::Separator();
        UI::Separator();
        UI::Separator();

        UI::Text(ColorizeString("List of combos to replace/delete/add/move:"));
        for (uint i = 0; i < blockInputsArray.Length; i++) {
            UI::Text("Combo " + (i + 1));
            UI::SameLine();
            UI::Text("Method: " + MethodTypeToString(methodTypes[i]));
            UI::SameLine();

            UI::Text("Block Inputs:");
            if (blockInputsArray[i].Length > 0) {
                for (uint j = 0; j < blockInputsArray[i].Length; j++) {
                    blockInputsArray[i][j] = UI::InputText("Input " + (i + 1) + "_" + (j + 1), blockInputsArray[i][j]);
                    UI::SameLine();
                    if (UI::Button("Delete##Input" + (i + 1) + "_" + (j + 1))) {
                        blockInputsArray[i].RemoveAt(j);
                        j--;
                    }
                }
            } else {
                UI::Text("No Inputs");
            }

            blockOutputs[i] = UI::InputText("Block Output " + (i + 1), blockOutputs[i]);

            UI::SameLine();
            if (UI::RadioButton("Replace##" + (i + 1), methodTypes[i] == MethodType::REPLACE)) {
                methodTypes[i] = MethodType::REPLACE;
            }
            UI::SameLine();
            if (UI::RadioButton("Delete##" + (i + 1), methodTypes[i] == MethodType::DELETE)) {
                methodTypes[i] = MethodType::DELETE;
            }
            UI::SameLine();
            if (UI::RadioButton("Add##" + (i + 1), methodTypes[i] == MethodType::ADD)) {
                methodTypes[i] = MethodType::ADD;
            }
            UI::SameLine();
            if (UI::RadioButton("Move##" + (i + 1), methodTypes[i] == MethodType::MOVE)) {
                methodTypes[i] = MethodType::MOVE;
            }

            if (methodTypes[i] == MethodType::ADD || methodTypes[i] == MethodType::MOVE) {
                coordsXYZArray[i] = UI::InputFloat3("Coords XYZ " + (i + 1), coordsXYZArray[i]);
                rotationYPRArray[i] = UI::InputFloat3("Rotation YPR " + (i + 1), rotationYPRArray[i]);
            }

            if (UI::Button("Add Input to Combo " + (i + 1))) {
                bool exists = false;
                for (uint k = 0; k < blockInputsArray[i].Length; k++) {
                    if (blockInputsArray[i][k] == g_latestChange) {
                        exists = true;
                        break;
                    }
                }
                if (!exists && g_latestChange != "") {
                    blockInputsArray[i].InsertLast(g_latestChange);
                }
            }

            UI::SameLine();
            if (UI::Button("Delete Combo " + (i + 1))) {
                blockInputsArray.RemoveAt(i);
                blockOutputs.RemoveAt(i);
                methodTypes.RemoveAt(i);
                coordsXYZArray.RemoveAt(i);
                rotationYPRArray.RemoveAt(i);
                i--;
            }

            UI::Separator();
        }

        if (UI::Button("Add New Block/Item Combo")) {
            blockInputsArray.InsertLast(array<string>());
            blockOutputs.InsertLast("");
            methodTypes.InsertLast(MethodType::REPLACE);
            coordsXYZArray.InsertLast(vec3());
            rotationYPRArray.InsertLast(vec3());
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
