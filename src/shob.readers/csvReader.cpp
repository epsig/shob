
#include "csvReader.h"
#include <fstream>
#include <sstream>

namespace shob::readers
{
    // for string delimiter
    std::vector<std::string> csvReader::split(const std::string& s, const std::string& delimiter)
    {
        size_t pos_start = 0, pos_end, delim_len = delimiter.length();
        std::string token;
        std::vector<std::string> res;

        while ((pos_end = s.find(delimiter, pos_start)) != std::string::npos) {
            token = s.substr(pos_start, pos_end - pos_start);
            pos_start = pos_end + delim_len;
            res.push_back(token);
        }

        res.push_back(s.substr(pos_start));
        return res;
    }

    std::vector<std::vector<std::string>> csvReader::readCsvFile(const std::string& filename)
    {
        auto result = std::vector<std::vector<std::string>>();

        std::ifstream myFile(filename);
        std::string line;
        while(std::getline(myFile, line))
        {
            if (!line.empty() && line[line.length() - 1] == '\r') {
                line.erase(line.length() - 1);
            }
            auto parts = split(line, ",");
            result.push_back(parts);
        }

        return result;
    }

    size_t csvReader::findColumn(const std::string& columnName, const std::vector<std::string>& header)
    {
        for (size_t i = 0; i < header.size(); i++)
        {
            if (header[i] == columnName) return i;
        }
        return 999;
    }

}

