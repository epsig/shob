
#include "footballCompetition.h"

#include "../shob.readers/csvReader.h"
#include "../shob.general/dateFactory.h"

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

        const auto team1Column = csvReader::findColumn("club1", csvData[0]);
        const auto team2Column = csvReader::findColumn("club2", csvData[0]);
        const auto ddColumn = csvReader::findColumn("dd", csvData[0]);
        const auto resultColumn = csvReader::findColumn("result", csvData[0]);
        const auto spectatorsColumn = csvReader::findColumn("spectators", csvData[0]);
        const auto remarksColumn = csvReader::findColumn("remark", csvData[0]);

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
            const std::string remarks=  (remarksColumn < line.size() ? line[remarksColumn] : "");
            const auto date = dateFactory::getDate(line[ddColumn]);
            const auto match = footballMatch(line[team1Column], line[team2Column], date,
                line[resultColumn], spectators, remarks);
            matches.push_back(match);
        }
    }

    footballCompetition footballCompetition::filter(const std::set<std::string>& clubs) const
    {
        auto filtered = footballCompetition();
        for (const auto& match : matches)
        {
            if (clubs.contains(match.team1) && clubs.contains(match.team2))
            {
                filtered.matches.push_back(match);
            }
        }
        return filtered;
    }

    html::tableContent footballCompetition::prepareTable(const teams::clubTeams& teams, const html::settings& settings) const
    {
        auto table = html::tableContent();
        if (settings.lang == html::language::Dutch)
        {
            table.header.data = { "dd", "team1", "team2", "uitslag", "opm" };
        }
        else
        {
            table.header.data = { "dd", "team (home)", "team (away)", "result", "remark" };
        }

        for (const auto& row : matches)
        {
            auto out = html::rowContent();
            out.data = { row.dd->toShortString(), teams.expand(row.team1), teams.expand(row.team2), row.result, row.remark };
            table.body.push_back(out);
        }

        return table;
    }

}
