uint g_hiddenCount = 0;
bool showTruncateConfirmation = false;
int truncateStartTime = 0;
const int confirmationDuration = 10000;

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

    if (UI::Begin(Colorize(Icons::Connectdevelop + Icons::Random + "CRP (Auto Alteration) Helper", {"0063eC", "33FFFF"}), S_showInterface, UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize)) {

        // Static Information
        UI::Text("Static Information");
        UI::Text("Current User: " + g_currUserName);
        UI::Text("Version: " + g_version);
        UI::Text("Creation Date: " + g_creationDate);
        UI::Separator();

        // Class Information
        UI::Text("Class Information");
        _UI::SimpleTooltip("The name of the class/file that will be generated, please note that the name has restrictions, but the description does not.");
        g_className = UI::InputText("Class/File Name: ", g_className);
        g_description = UI::InputText("Description: ", g_description);
        UI::Separator();

        // Current Block/Item Information
        UI::Text("Current Block/Item Information");
        UI::Text("Latest Change: " + Colorize(g_latestChange, {"fff7b3", "d1f799"}));
        UI::Separator();

        // List of Combos
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
                if (UI::ButtonColored("Are you sure? Click 'HERE' to confirm (" + timeLeft + "s left)", 1.0f, 0.0f, 0.0f)) {
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
            UI::SameLine();

            // Validate the current index
            bool isValid = ValidateIndexTypes(i);
            UI::Text(validationStatus);

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
                    CheckAndUpdateBlockType(i, g_latestChange);
                    bool isValid = ValidateIndexTypes(i);
                    UpdateUIWithValidationResult(i, isValid);
                }
            }
            UI::SameLine();
            if (UI::ButtonColored("Add Output to Index " + (i + 1), h, 0.6f, 0.6f)) {
                g_blockOutputs[i] = g_latestChange;
                CheckAndUpdateBlockType(i, g_latestChange, true);
                bool isValid = ValidateIndexTypes(i);
                UpdateUIWithValidationResult(i, isValid);
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
                continue;
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

        // Save Options
        RenderSaveOptions();

        UI::End();
    }
}


void RenderReplaceUI(uint index) {
    for (uint j = 0; j < g_blockInputsArray[index].Length; j++) {
        string previousValue = g_blockInputsArray[index][j];
        g_blockInputsArray[index][j] = UI::InputText("Input " + (index + 1) + "_" + (j + 1), g_blockInputsArray[index][j]);
        if (previousValue != g_blockInputsArray[index][j]) {
            CheckAndUpdateBlockType(index, g_blockInputsArray[index][j]);
            bool isValid = ValidateIndexTypes(index);
            UpdateUIWithValidationResult(index, isValid);
        }
        UI::SameLine();
        if (UI::ButtonColored("Delete##Input" + (index + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
            g_blockInputsArray[index].RemoveAt(j);
            UpdateBlockTypes(index);
            bool isValid = ValidateIndexTypes(index);
            UpdateUIWithValidationResult(index, isValid);
            j--;
        }
    }
    UI::Separator();
    string previousOutput = g_blockOutputs[index];
    g_blockOutputs[index] = UI::InputText("New Output " + (index + 1), g_blockOutputs[index]);
    if (previousOutput != g_blockOutputs[index]) {
        CheckAndUpdateBlockType(index, g_blockOutputs[index], true);
        bool isValid = ValidateIndexTypes(index);
        UpdateUIWithValidationResult(index, isValid);
    }
}

void RenderDeleteUI(uint index) {
    for (uint j = 0; j < g_blockInputsArray[index].Length; j++) {
        string previousValue = g_blockInputsArray[index][j];
        g_blockInputsArray[index][j] = UI::InputText("Input " + (index + 1) + "_" + (j + 1), g_blockInputsArray[index][j]);
        if (previousValue != g_blockInputsArray[index][j]) {
            CheckAndUpdateBlockType(index, g_blockInputsArray[index][j]);
            bool isValid = ValidateIndexTypes(index);
            UpdateUIWithValidationResult(index, isValid);
        }
        UI::SameLine();
        if (UI::ButtonColored("Delete##Input" + (index + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
            g_blockInputsArray[index].RemoveAt(j);
            j--;
            UpdateBlockTypes(index);
            bool isValid = ValidateIndexTypes(index);
            UpdateUIWithValidationResult(index, isValid);
        }
    }
}

void RenderPlaceUI(uint index) {
    string previousOutput = g_blockOutputs[index];
    g_blockOutputs[index] = UI::InputText("New Output " + (index + 1), g_blockOutputs[index]);
    if (previousOutput != g_blockOutputs[index]) {
        CheckAndUpdateBlockType(index, g_blockOutputs[index]);
        bool isValid = ValidateIndexTypes(index);
        UpdateUIWithValidationResult(index, isValid);
    }
    g_coordsXYZArray[index] = UI::InputFloat3("Position " + (index + 1), g_coordsXYZArray[index]);
    g_rotationYPRArray[index] = UI::InputFloat3("Rotation " + (index + 1), g_rotationYPRArray[index]);
}

void RenderPlaceRelativeUI(uint index) {
    for (uint j = 0; j < g_blockInputsArray[index].Length; j++) {
        string previousValue = g_blockInputsArray[index][j];
        g_blockInputsArray[index][j] = UI::InputText("Input " + (index + 1) + "_" + (j + 1), g_blockInputsArray[index][j]);
        if (previousValue != g_blockInputsArray[index][j]) {
            CheckAndUpdateBlockType(index, g_blockInputsArray[index][j]);
            bool isValid = ValidateIndexTypes(index);
            UpdateUIWithValidationResult(index, isValid);
        }
        UI::SameLine();
        if (UI::ButtonColored("Delete##Input" + (index + 1) + "_" + (j + 1), 0.0f, 0.6f, 0.6f)) {
            g_blockInputsArray[index].RemoveAt(j);
            j--;
            UpdateBlockTypes(index);
            bool isValid = ValidateIndexTypes(index);
            UpdateUIWithValidationResult(index, isValid);
        }
    }
    string previousOutput = g_blockOutputs[index];
    g_blockOutputs[index] = UI::InputText("New Output " + (index + 1), g_blockOutputs[index]);
    if (previousOutput != g_blockOutputs[index]) {
        CheckAndUpdateBlockType(index, g_blockOutputs[index]);
        bool isValid = ValidateIndexTypes(index);
        UpdateUIWithValidationResult(index, isValid);
    }
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

    bool showAuto = g_blockTypes[index] == BlockType::AUTO;

    if (showAuto) {
        if (UI::RadioButton("Auto##" + (index + 1), g_blockTypes[index] == BlockType::AUTO)) {
            g_blockTypes[index] = BlockType::AUTO;
        }
        UI::SameLine();
    }
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
    bool isClassNameValid = IsValidClassName(g_className);
    if (!isClassNameValid) {
        _UI::SimpleTooltip("Class name can only contain alphabetic characters (A-Z, a-z), and '_' (underscore) characters. It cannot start with a number.");
    }
    string filePath = "";
    if (_UI::DisabledButton(!isClassNameValid, "Save")) {
        string classContent = GenerateCSharpClass();
        if (classContent != "") {
            string folderPath = IO::FromStorageFolder("CRP/");
            filePath = folderPath + g_className + ".cs";
            if (!IO::FolderExists(IO::FromStorageFolder("CRP/"))) {
                IO::CreateFolder(IO::FromStorageFolder("CRP/"));
            }
            _IO::SaveToFile(filePath, classContent);
        }
    }
    UI::SameLine();
    if (filePath != "") {
        if (UI::Button("Open Folder")) {
            _IO::OpenFolder(IO::FromStorageFolder("CRP/"));
        }
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