string GenerateCSharpClass() {
    string classContent = GenerateMetadata();
    classContent += "class " + g_className + ": Alteration {\n";
    classContent += "    public override void run(Map map){\n";

    for (uint i = 0; i < g_blockInputsArray.Length; i++) {
        classContent += GenerateMethodContent(g_methodTypes[i], g_blockInputsArray[i], g_blockOutputs[i], g_blockTypes[i]);
    }

    classContent += "        map.placeStagedBlocks();\n";
    classContent += "    }\n";
    classContent += "}\n";

    return classContent;
}

string GenerateMethodContent(MethodType methodType, array<string> inputs, const string &in output, BlockType type) {
    string typeStr = BlockTypeToString(type);
    string methodContent = "";

    switch (methodType) {
        case MethodType::REPLACE:
            methodContent = GenerateReplace(inputs, output, typeStr);
            break;
        case MethodType::DELETE:
            methodContent = GenerateDelete(inputs);
            break;
        case MethodType::PLACE:
            methodContent = GeneratePlace(inputs[0], output, typeStr);
            break;
        case MethodType::PLACERELATIVE:
            methodContent = GeneratePlaceRelative(inputs, output, typeStr);
            break;
        default:
            return "";
    }

    if (type == BlockType::CUSTOM) {
        methodContent = "// Ambiguous type conflict detected. The following line(s) have been commented out:\n" + "// " + methodContent;
    }

    return methodContent;
}

string BlockTypeToString(BlockType type) {
    switch (type) {
        case BlockType::AUTO:
            return "auto";
        case BlockType::BLOCK:
            return "block";
        case BlockType::ITEM:
            return "item";
        case BlockType::CUSTOM:
            return "custom";
        default:
            return "unknown";
    }
}

string GenerateMetadata() {
    return "// Auto-generated by Alteration Helper\n"
           "// Version: " + g_version + "\n"
           "// Author: " + g_currUserName + "\n"
           "// Creation Date: " + g_creationDate + "\n"
           "// Description: " + g_description + "\n\n";
}

string GenerateReplace(array<string> blocks, const string &in newBlock, const string &in type) {
    string output = "";
    for (uint i = 0; i < blocks.Length; i++) {
        output += "        map.replace(\"" + blocks[i] + "\", \"" + newBlock + "\", BlockType." + type + ");\n";
    }
    return output;
}

string GenerateDelete(const array<string> &blocks) {
    string output = "";
    for (uint i = 0; i < blocks.Length; i++) {
        output += "        map.delete(\"" + blocks[i] + "\");\n";
    }
    return output;
}

string GeneratePlace(const string &in block, const string &in newBlock, const string &in type) {
    return "        map.place(\"" + block + "\", \"" + newBlock + "\", BlockType." + type + ");\n";
}

string GeneratePlaceRelative(array<string> blocks, const string &in newBlock, const string &in type) {
    string output = "";
    for (uint i = 0; i < blocks.Length; i++) {
        output += "        map.placeRelative(\"" + blocks[i] + "\", \"" + newBlock + "\", BlockType." + type + ");\n";
    }
    return output;
}