
#include "footballCompetition.h"

#include "csvReader.h"

namespace shob::football
{
    size_t findColumn(const std::string& columnName, const std::vector<std::string> & header)
    {
        for (size_t i = 0; i < header.size(); i++)
        {
            if (header[i] == columnName) return i;
        }
        return 999;
    }

    void footballCompetition::readFromCsv(const std::string& filename)
    {
        auto csvData = readers::csvReader::readCsvFile(filename);
        auto cntMatches = csvData.size() - 1;
        matches = std::vector<footballMatch>();

        auto team1 = findColumn("club1", csvData[0]);
        auto team2 = findColumn("club2", csvData[0]);
        auto dd = findColumn("dd", csvData[0]);
        auto result = findColumn("result", csvData[0]);
        auto spectators = findColumn("spectators", csvData[0]);
        for (size_t i = 0; i < cntMatches; i++)
        {
            const auto& line = csvData[i + 1];
            const auto dd_int = std::stoi(line[dd]);
            const auto spectators_int = (line[spectators].empty() ? 0 : std::stoi(line[spectators]));
            auto match = footballMatch(line[team1], line[team2], dd_int, line[result], spectators_int);
            matches.push_back(match);
        }
    };

}
