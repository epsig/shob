
#include "updateIfNewer.h"
#include <fstream>

namespace shob::html
{
    bool updateIfDifferent::areEqual(const std::vector<std::string>& prev, const std::vector<std::string>& current)
    {
        if (prev.size() != current.size()) return false;
        for (int i = 0; i < static_cast<int>(prev.size()); i++)
        {
            if (prev[i] != current[i]) return false;
        }
        return true;
    }

    std::vector<std::string> updateIfDifferent::readFile(const std::string& path)
    {
        std::vector<std::string> content;

        std::ifstream myFile(path);
        std::string line;
        while (std::getline(myFile, line))
        {
            if (!line.empty() && line[line.length() - 1] == '\r') {
                line.erase(line.length() - 1);
            }
            content.push_back(line);
        }
        return content;
    }

    void updateIfDifferent::writeToFile(const std::string& path, const std::vector<std::string>& data)
    {
        auto fileOut = std::ofstream(path);
        for (const auto& row : data)
        {
            fileOut << row << std::endl;
        }
    }

    void updateIfDifferent::update(const std::string& path1, const std::string& path2)
    {
        auto previousVersion = readFile(path1);
        auto newVersion = readFile(path2);
        if (!areEqual(previousVersion, newVersion))
        {
            writeToFile(path1, newVersion);
        }
    }

    void updateIfDifferent::update(const std::string& path, const rowContent& content)
    {
        auto previousVersion = readFile(path);

        if ( ! areEqual(previousVersion, content.data))
        {
            writeToFile(path, content.data);
        }

    }
}

