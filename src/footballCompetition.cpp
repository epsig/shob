
#include "footballCompetition.h"

#include "csvReader.h"
#include "dateFactory.h"

namespace shob::football
{
    using namespace shob::readers;
    using namespace shob::general;

    void footballCompetition::readFromCsv(const std::string& filename)
    {
        auto csvData = csvReader::readCsvFile(filename);
        readFromCsvData(csvData);
    }

    void footballCompetition::readFromCsvData(const std::vector<std::vector<std::string>>& csvData)
    {
        const auto cntMatches = csvData.size() - 1;
        matches = std::vector<footballMatch>();

        auto team1Column = csvReader::findColumn("club1", csvData[0]);
        auto team2Column = csvReader::findColumn("club2", csvData[0]);
        auto ddColumn = csvReader::findColumn("dd", csvData[0]);
        auto resultColumn = csvReader::findColumn("result", csvData[0]);
        auto spectatorsColumn = csvReader::findColumn("spectators", csvData[0]);
        for (size_t i = 0; i < cntMatches; i++)
        {
            const auto& line = csvData[i + 1];
            int spectators = 0;
            if (spectatorsColumn < line.size())
            {
                if (!line[spectatorsColumn].empty())
                {
                    spectators = std::stoi(line[spectatorsColumn]);
                }
            }
            auto date = dateFactory::getDate(line[ddColumn]);
            const auto match = footballMatch(line[team1Column], line[team2Column], date, line[resultColumn], spectators);
            matches.push_back(match);
        }
    }

}
