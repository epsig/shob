#include "MergeJavaScript.h"
#include "../shob.general/FileIO.h"
#include "Versleutel.h"
#include <vector>

namespace shob::klaverjas
{
    using namespace shob::general;

    void MergeJavaScript::mergeFiles(const std::string& displayType)
    {
        auto outputFile = "../pages/include/kj_code_" + displayType + ".js";
        auto inputFiles = std::vector<std::string>{
            "web_kj_main.js", "tools.js", "OTimer.js", "OHelp.js", "OSetAnalyse.js",
            "OKaart.js", "OBasicRules.js", "OStack.js", "OStrategy.js", "OEnvironment.js", "OScore.js",
            "OSetAdmin.js","OMatchAdmin.js",  "OScreenAdmin.js"};
        if (displayType == "txt") {
            inputFiles.push_back("web_kj_color_italic.js");
        }
        else {
            inputFiles.push_back("web_kj_preload.js");
        }
        auto content = MultipleStrings();
        for (const auto& inputFile : inputFiles) {
            auto directory = "../code/Klaverjas/";
            if (inputFile == "tools.js") {
                directory = "../code/my_scripts/";
            }

            auto lines = FileIO::readFile(directory + inputFile);
            content.addContent(lines);
        }

        auto versleutel = Versleutel(9, "../code/Klaverjas/sleutels.txt");
        auto encryptedContent = versleutel.versleutelCode(content);

        FileIO::writeToFile(outputFile, encryptedContent);
    }
}

