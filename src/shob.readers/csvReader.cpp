
#include "csvReader.h"
#include <fstream>
#include <sstream>

namespace shob::readers
{
    // trim from end of string (right)
    std::string csvReader::rtrim(const std::string& s, const char* t)
    {
        std::string r = s;
        r.erase(r.find_last_not_of(t) + 1);
        return r;
    }

    // trim from beginning of string (left)
    std::string csvReader::ltrim(const std::string& s, const char* t)
    {
        std::string r = s;
        r.erase(0, r.find_first_not_of(t));
        return r;
    }

    // trim from both ends of string (right then left)
    std::string csvReader::trim(const std::string& s, const char* t)
    {
        auto trimmed = rtrim(s, t);
        return ltrim(trimmed, t);
    }


    // for string delimiter
    csvColContent csvReader::split(const std::string& s, const std::string& delimiter)
    {
        size_t pos_start = 0, pos_end, delim_len = delimiter.length();
        std::string token;
        csvColContent res;

        constexpr char doubleQuote = '"';
        const std::string q = std::string(1, doubleQuote);
        if (delimiter != q)
        {
            if (s.find(doubleQuote) != std::string::npos)
            {
                auto splittedOnQuotes = split(s, q);
                auto splitted = split(splittedOnQuotes.column[0], delimiter);
                splitted.column.back() = splittedOnQuotes.column[1];
                return splitted;
            }
        }

        while ((pos_end = s.find(delimiter, pos_start)) != std::string::npos) {
            token = s.substr(pos_start, pos_end - pos_start);
            pos_start = pos_end + delim_len;
            res.column.push_back(trim(token, " "));
        }

        res.column.push_back(s.substr(pos_start));
        return res;
    }

    csvContent csvReader::readCsvFile(const std::string& filename)
    {
        csvContent result;

        std::ifstream myFile(filename);
        std::string line;
        bool isFirst = true;
        while(std::getline(myFile, line))
        {
            if (!line.empty() && line[line.length() - 1] == '\r') {
                line.erase(line.length() - 1);
            }
            auto parts = split(line, ",");
            if (isFirst)
            {
                result.header = parts;
                isFirst = false;
            }
            else
            {
                result.body.push_back(parts);
            }
        }

        return result;
    }

    size_t csvContent::findColumn(const std::string& columnName) const
    {
        for (size_t i = 0; i < header.column.size(); i++)
        {
            if (header.column[i] == columnName) return i;
        }
        return 999;
    }

    std::vector<std::string> csvContent::findColumnNamesTeams() const
    {
        auto names = std::vector<std::string>();
        std::vector<std::string> possibilities = { "team1", "team2", "club1", "club2", "land1", "land2" };
        for (const auto& name : possibilities)
        {
            if (findColumn(name) < 999) names.push_back(name);
        }
        return names;
    }

}

