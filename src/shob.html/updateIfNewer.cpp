
#include "updateIfNewer.h"
#include <fstream>

namespace shob::html
{
    using namespace shob::general;

    MultipleStrings updateIfDifferent::readFile(const std::string& path)
    {
        MultipleStrings content;

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

    void updateIfDifferent::writeToFile(const std::string& path, const MultipleStrings& data)
    {
        auto fileOut = std::ofstream(path);
        for (const auto& row : data.data)
        {
            fileOut << row << std::endl;
        }
    }

    /// copies path1 to path2, but only if their content is different
    /// @param path1 source file
    /// @param path2 destination file
    void updateIfDifferent::update(const std::string& path1, const std::string& path2)
    {
        auto previousVersion = readFile(path1);
        auto newVersion = readFile(path2);
        if (!previousVersion.areEqual(newVersion))
        {
            writeToFile(path2, previousVersion);
        }
    }

    void updateIfDifferent::update(const std::string& path, const MultipleStrings& content)
    {
        auto previousVersion = readFile(path);

        if ( !previousVersion.areEqual(content))
        {
            writeToFile(path, content);
        }

    }
}

