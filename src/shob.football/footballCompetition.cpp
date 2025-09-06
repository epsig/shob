
#include "footballCompetition.h"

#include "../shob.readers/csvReader.h"
#include "../shob.general/dateFactory.h"
#include "../shob.html/funcs.h"

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

        const auto clubNames = csvData.findColumnNamesTeams();
        const auto team1Column = csvData.findColumn(clubNames[0]);
        const auto team2Column = csvData.findColumn(clubNames[1]);
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
                    if (dateFactory::allDigits(line[spectatorsColumn]))
                    {
                        spectators = std::stoi(line[spectatorsColumn]);
                    }
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

    footballCompetition footballCompetition::filterNL() const
    {
        auto filtered = footballCompetition();
        for (const auto& match : matches)
        {
            if (match.team1.starts_with("NL") || match.team2.starts_with("NL"))
            {
                filtered.matches.push_back(match);
            }
        }
        return filtered;
    }

    html::tableContent footballCompetition::prepareTable(const teams::clubTeams& teams, const html::settings& settings) const
    {
        auto table = html::tableContent();
        if ( matches.empty()) { return table; }

        bool withRemarks = false;
        for (const auto& row : matches)
        {
            if (!row.remark.empty()) withRemarks = true;
        }

        if (settings.lang == html::language::Dutch)
        {
            table.header.data = { "dd", "team1 - team2", "uitslag" };
            if (withRemarks) table.header.data.emplace_back("opm");
        }
        else
        {
            table.header.data = { "dd", "team (home) - team (away)", "result" };
            if (withRemarks) table.header.data.emplace_back("remark");
        }
        if (settings.isCompatible) table.header.data.clear();
        if (onlyKO)
        {
            table.colWidths = { 1, 1, 1 };
            if (settings.isCompatible) table.colWidths = { 1, 1 };
        }
        else
        {
            table.colWidths = { 1, 2, 1 };
            if (settings.isCompatible) table.colWidths = { 3, 1 };
        }
        if (withRemarks) table.colWidths.push_back(1);

        auto returns = getReturns();

        for (int i = 0; i < static_cast<int>(matches.size()); i++)
        {
            auto& row = matches[i];
            auto out = multipleStrings();
            std::string dd = settings.dateFormatShort ? row.dd->toShortString() : row.dd->toString(settings.isCompatible);
            if ( ! row.stadium.empty())
            {
                dd = html::funcs::acronym(dd, "te: " + row.stadium);
            }
            auto addCountry = settings.addCountry;
            std::vector<std::string> stars = { "", "" };
            auto index = row.winner();
            if (returns.isSecondMatch[i])
            {
                addCountry = html::addCountryType::notAtAll;
                if (index >= 0) stars[1-index] = "&nbsp;*";
            }
            else
            {
                if (index >= 0) stars[index] = "&nbsp;*";
            }
            if (settings.isCompatible)
            {
                out.data = { dd + " " + teams.expand(row.team1, addCountry) + stars[0] + " - " + teams.expand(row.team2, addCountry) + stars[1], row.result};
            }
            else
            {
                out.data = { dd, teams.expand(row.team1, addCountry) + stars[0] + " - " + teams.expand(row.team2, addCountry) + stars[1], row.result};
            }
            if (withRemarks) out.data.emplace_back(row.remark);
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

    coupledMatchesData footballCompetition::getReturns() const
    {
        coupledMatchesData coupledMatches;
        coupledMatches.isSecondMatch = std::vector(matches.size(), false);
        for (size_t i = 0; i < matches.size(); i++)
        {
            for (size_t j = i+1; j < matches.size(); j++)
            {
                if (equalTeams(i,j))
                {
                    coupledMatches.couples.insert({ i,j });
                    coupledMatches.isSecondMatch[j] = true;
                }
            }
        }
        return coupledMatches;
    }

}
