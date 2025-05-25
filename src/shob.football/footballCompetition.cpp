
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

    void footballCompetition::readFromCsvData(const csvContent& csvData)
    {
        matches = std::vector<footballMatch>();

        const auto team1Column = csvData.findColumn("club1");
        const auto team2Column = csvData.findColumn("club2");
        const auto ddColumn = csvData.findColumn("dd");
        const auto resultColumn = csvData.findColumn("result");
        const auto spectatorsColumn = csvData.findColumn("spectators");
        const auto remarksColumn = csvData.findColumn("remark");

        for (const auto& col : csvData.body)
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

    bool footballCompetition::equalTeams(size_t i, size_t j) const
    {
        if (matches[i].team1 == matches[j].team2 && matches[i].team2 == matches[j].team1) return true;
        if (matches[i].team1 == matches[j].team1 && matches[i].team2 == matches[j].team2) return true;
        return false;
    }

    std::map<size_t, size_t> footballCompetition::getReturns() const
    {
        std::map<size_t, size_t> couples;
        for (size_t i = 0; i < matches.size(); i++)
        {
            for (size_t j = i+1; j < matches.size(); j++)
            {
                if (equalTeams(i,j))
                {
                    couples.insert({ i,j });
                }
            }
        }
        return couples;
    }

}
