
#include "csvReader.h"
#include "../shob.general/StringUtils.h"

#include <fstream>
#include <sstream>

namespace shob::readers
{
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
            res.column.push_back(general::StringUtils::trim(token, " "));
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
                auto index = parts.column.back().find('#');
                if (index != std::string::npos)
                {
                    auto size_comment = parts.column.back().size();
                    parts.column.back().erase(index, size_comment);
                    parts.column.back() = general::StringUtils::trim(parts.column.back(), " ");
                }
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
        std::vector<std::string> possibilities = { "team1", "team2", "club1", "club2", "land1", "land2", "club_id", "land" };
        for (const auto& name : possibilities)
        {
            if (findColumn(name) < 999) names.push_back(name);
        }
        return names;
    }

    general::uniqueStrings csvContent::getParts() const
    {
        auto parts = general::uniqueStrings();
        for (const auto& row : body)
        {
            const auto& part = row.column[0];
            parts.insert(part);
        }
        return parts;
    }

}

