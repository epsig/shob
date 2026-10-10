#include "FileIO.h"
#include <fstream>

namespace shob::general
{
    using namespace shob::general;

    MultipleStrings FileIO::readFile(const std::string& path)
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

    void FileIO::writeToFile(const std::string& path, const MultipleStrings& data)
    {
        auto fileOut = std::ofstream(path);
        for (const auto& row : data.data)
        {
            fileOut << row << std::endl;
        }
    }
}
