
#include "filterResults.h"
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
                star = static_cast<starEnum>(std::stoi(line[index]));
            }
        }
        return star;
    }

    footballCompetition filterResults::readFromCsvData(const csvContent & csvData, const std::string& round)
    {
        auto comp = footballCompetition();

        const auto team1Column = csvReader::findColumn("team1", csvData.header);
        const auto team2Column = csvReader::findColumn("team2", csvData.header);
        const auto ddColumn = csvReader::findColumn("dd", csvData.header);
        const auto resultColumn = csvReader::findColumn("result", csvData.header);
        const auto spectatorsColumn = csvReader::findColumn("spectators", csvData.header);
        const auto starColumn = csvReader::findColumn("star", csvData.header);

        const auto isFinal = round == "f";
        for (const auto& col : csvData.body)
        {
            const auto& line = col.column;
            if (line[0] == round)
            {
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
