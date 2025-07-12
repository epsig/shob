
#include "updateIfNewer.h"
#include <fstream>

namespace shob::html
{
    bool updateIfDifferent::areEqual(const std::vector<std::string>& prev, const rowContent& current)
    {
        if (prev.size() != current.data.size()) return false;
        for (int i = 0; i < static_cast<int>(prev.size()); i++)
        {
            if (prev[i] != current.data[i]) return false;
        }
        return true;
    }

    void updateIfDifferent::update(const std::string& path, const rowContent& content)
    {
        std::vector<std::string> previousVersion;

        std::ifstream myFile(path);
        std::string line;
        while (std::getline(myFile, line))
        {
            if (!line.empty() && line[line.length() - 1] == '\r') {
                line.erase(line.length() - 1);
            }
            previousVersion.push_back(line);
        }

        if ( ! areEqual(previousVersion, content))
        {
            auto fileOut = std::ofstream(path);
            for (const auto& row : content.data)
            {
                fileOut << row << std::endl;
            }
        }

    }
}

