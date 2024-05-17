void Render() {

    if (g_currentItem == "New Item") {
        g_currentItem = "placeholder item name";
    }
    if (g_currentBlock == "New Block") {
        g_currentBlock = "placeholder block name";
    }

    if (!S_showInterface) return;

    if (UI::Begin("Random Map Picker", S_showInterface, UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize)) {

        UI::Text("Static Information");
        UI::Separator();
        UI::Separator();
        UI::Separator();
        UI::Text("Current User: " + g_currUserName);
        UI::Text("Version: " + g_version);
        UI::Text("Creation Date: " + g_creationDate);
        UI::Separator();
        UI::Separator();
        UI::Separator();

        UI::Text("Class Information");
        g_className = UI::InputText("Class/File Name: ", g_className);
        g_description = UI::InputText("Description: ", g_description);
        UI::Separator();
        UI::Separator();
        UI::Separator();

        UI::Text("Current Block/Item Information");

        UI::Text("Current Block: " + g_currentBlock);
        UI::Text("Current Item: " + g_currentItem);

        UI::Separator();

        UI::Text("Blocks in list");

        UI::Separator();
        UI::Separator();

        UI::Text("List of combos to replace/delete/add:");

        for (uint i = 0; i < blockInputsArray.Length; i++) {
            UI::Text("Combo " + (i + 1));
            UI::SameLine();
            UI::Text("Method: " + MethodTypeToString(methodTypes[i]));
            UI::SameLine();

            UI::Text("Block Inputs:");
            if (blockInputsArray[i].Length > 0) {
                for (uint j = 0; j < blockInputsArray[i].Length; j++) {
                    blockInputsArray[i][j] = UI::InputText("Input " + (j + 1), blockInputsArray[i][j]);
                }
            } else {
                UI::Text("No Inputs");
            }

            blockOutputs[i] = UI::InputText("Block Output", blockOutputs[i]);

            UI::SameLine();
            if (UI::RadioButton("Replace", methodTypes[i] == MethodType::REPLACE)) {
                methodTypes[i] = MethodType::REPLACE;
            }
            UI::SameLine();
            if (UI::RadioButton("Delete", methodTypes[i] == MethodType::DELETE)) {
                methodTypes[i] = MethodType::DELETE;
            }
            UI::SameLine();
            if (UI::RadioButton("Add", methodTypes[i] == MethodType::ADD)) {
                methodTypes[i] = MethodType::ADD;
            }

            if (methodTypes[i] == MethodType::ADD) {
                coordsXYZArray[i] = UI::InputText("Coords XYZ", coordsXYZArray[i]);
                rotationYPRArray[i] = UI::InputText("Rotation YPR", rotationYPRArray[i]);
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

        if (UI::Button("Add New Block Combo")) {
            blockInputsArray.InsertLast(array<string>());
            blockOutputs.InsertLast("");
            methodTypes.InsertLast(MethodType::REPLACE);
            coordsXYZArray.InsertLast("");
            rotationYPRArray.InsertLast("");
        }

        UI::Separator();

        if (UI::Button("Save")) {
            Json::Value settings = CreateFile();
            string fileName = g_className + ".json";
            string filePath = IO::FromDataFolder(fileName);

            IO::File file(filePath, IO::FileMode::Write);
            file.Write(tostring(settings));
            file.Close();
        }

        UI::End();
    }
}