
#include "filterResults.h"
#include "../shob.readers/csvReader.h"
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

    footballCompetition filterResults::readFromCsvData(const std::vector<std::vector<std::string>>& csvData, const std::string& round)
    {
        auto comp = footballCompetition();

        const auto team1Column = csvReader::findColumn("team1", csvData[0]);
        const auto team2Column = csvReader::findColumn("team2", csvData[0]);
        const auto ddColumn = csvReader::findColumn("dd", csvData[0]);
        const auto resultColumn = csvReader::findColumn("result", csvData[0]);
        const auto spectatorsColumn = csvReader::findColumn("spectators", csvData[0]);
        const auto starColumn = csvReader::findColumn("star", csvData[0]);

        const auto isFinal = round == "f";
        for (size_t i = 1; i < csvData.size(); i++)
        {
            const auto& line = csvData[i];
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
