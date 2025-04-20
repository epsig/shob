
#include "footballCompetition.h"

#include "csvReader.h"

namespace shob::football
{
    using namespace shob::readers;

    void footballCompetition::readFromCsv(const std::string& filename)
    {
        auto csvData = csvReader::readCsvFile(filename);
        auto cntMatches = csvData.size() - 1;
        matches = std::vector<footballMatch>();

        auto team1 = csvReader::findColumn("club1", csvData[0]);
        auto team2 = csvReader::findColumn("club2", csvData[0]);
        auto dd = csvReader::findColumn("dd", csvData[0]);
        auto result = csvReader::findColumn("result", csvData[0]);
        auto spectators = csvReader::findColumn("spectators", csvData[0]);
        for (size_t i = 0; i < cntMatches; i++)
        {
            const auto& line = csvData[i + 1];
            try
            {
                auto dd_int = std::stoi(line[dd]);
                const auto spectators_int = (line[spectators].empty() ? 0 : std::stoi(line[spectators]));
                auto match = footballMatch(line[team1], line[team2], dd_int, line[result], spectators_int);
                matches.push_back(match);
            }
            catch (...)
            {
                auto match = footballMatch(line[team1], line[team2], 0, line[result], 0);
                matches.push_back(match);
            }
        }
    }

}
