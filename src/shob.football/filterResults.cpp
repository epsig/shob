
#include "filterResults.h"

#include <iostream>

#include "../shob.general/dateFactory.h"

namespace shob::football
{
    using namespace readers;

    starEnum filterResults::getStar(const std::vector<std::string>& line, size_t index)
    {
        auto star = starEnum::unknownYet;
        if (index < line.size())
        {
            if ( ! line[index].empty())
            {
                const auto& number = line[index];
                if ( number == "-1" || general::dateFactory::allDigits(number))
                {
                    star = static_cast<starEnum>(std::stoi(number));
                }
                else
                {
                    std::cout << "warning found invalid star: " << number << std::endl;
                }
            }
        }
        return star;
    }

    footballCompetition filterResults::readFromCsvData(const csvContent & csvData, const filterInputList& filter)
    {
        auto comp = footballCompetition();

        const auto clubNames = csvData.findColumnNamesTeams();
        const auto team1Column = csvData.findColumn(clubNames[0]);
        const auto team2Column = csvData.findColumn(clubNames[1]);
        const auto ddColumn = csvData.findColumn("dd");
        const auto resultColumn = csvData.findColumn("result");
        const auto spectatorsColumn = csvData.findColumn("spectators");
        const auto starColumn = csvData.findColumn("star");

        const auto isFinal = filter.isFinale();
        for (const auto& col : csvData.body)
        {
            if (filter.checkLine(col))
            {
                const auto& line = col.column;
                int spectators = 0;
                if (spectatorsColumn < line.size())
                {
                    if (!line[spectatorsColumn].empty())
                    {
                        spectators = std::stoi(line[spectatorsColumn]);
                    }
                }
                const auto date = general::dateFactory::getDate(line[ddColumn]);
                const auto star = getStar(line,starColumn);
                const auto match = footballMatch(line[team1Column], line[team2Column], date, line[resultColumn],
                    spectators, star, isFinal);
                comp.matches.push_back(match);
            }
        }

        return comp;
    }

}
