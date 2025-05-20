
#include "filterResults.h"
#include "../shob.readers/csvReader.h"
#include "../shob.general/dateFactory.h"

namespace shob::football
{
    using namespace readers;
    footballCompetition filterResults::readFromCsvData(const std::vector<std::vector<std::string>>& csvData, const std::string& round)
    {
        auto comp = footballCompetition();

        auto team1Column = csvReader::findColumn("team1", csvData[0]);
        auto team2Column = csvReader::findColumn("team2", csvData[0]);
        auto ddColumn = csvReader::findColumn("dd", csvData[0]);
        auto resultColumn = csvReader::findColumn("result", csvData[0]);
        auto spectatorsColumn = csvReader::findColumn("spectators", csvData[0]);

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
                auto date = general::dateFactory::getDate(line[ddColumn]);
                const auto match = footballMatch(line[team1Column], line[team2Column], date, line[resultColumn], spectators);
                comp.matches.push_back(match);
            }
        }

        return comp;
    }

}
