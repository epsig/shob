
#include "updateIfNewer.h"
#include <fstream>

namespace shob::html
{
    using namespace shob::general;

    multipleStrings updateIfDifferent::readFile(const std::string& path)
    {
        multipleStrings content;

        std::ifstream myFile(path);
        std::string line;
        while (std::getline(myFile, line))
        {
            if (!line.empty() && line[line.length() - 1] == '\r') {
                line.erase(line.length() - 1);
            }
            content.data.push_back(line);
        }
        return content;
    }

    void updateIfDifferent::writeToFile(const std::string& path, const multipleStrings& data)
    {
        auto fileOut = std::ofstream(path);
        for (const auto& row : data.data)
        {
            fileOut << row << std::endl;
        }
    }

    void updateIfDifferent::update(const std::string& path1, const std::string& path2)
    {
        auto previousVersion = readFile(path1);
        auto newVersion = readFile(path2);
        if (!previousVersion.areEqual(newVersion))
        {
            writeToFile(path1, newVersion);
        }
    }

    void updateIfDifferent::update(const std::string& path, const multipleStrings& content)
    {
        auto previousVersion = readFile(path);

        if ( !previousVersion.areEqual(content))
        {
            writeToFile(path, content);
        }

    }
}

