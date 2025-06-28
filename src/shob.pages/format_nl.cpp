
#include "format_nl.h"
#include <iostream>
#include <fstream>

#include "../shob.football/results2standings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.football/route2finalFactory.h"

namespace shob::pages
{
    void format_nl::get_season_to_file(const std::string& season, const std::string& filename) const
    {
        auto output = get_season(season);
        auto file = std::ofstream(filename);
        for (const auto& row : output.data)
        {
            file << row << std::endl;
        }
    }

    void format_nl::get_season_stdout(const std::string& season) const
    {
        auto output = get_season(season);
        for (const auto& row : output.data)
        {
            std::cout << row << std::endl;
        }
    }

    html::rowContent format_nl::getTopScorers(const std::string& file, const std::string& season,
        const teams::footballers& players, const teams::clubTeams& teams)
    {
        auto settings = html::settings();

        auto allTp = readers::csvAllSeasonsReader();
        allTp.init(file);

        auto tp = football::topscorers(allTp);
        tp.initFromFile(season);
        auto table = tp.prepareTable(teams, players, settings);
        auto out = html::table::buildTable(table);
        return out;
    }

    html::rowContent format_nl::get_season(const std::string& season) const
    {
        auto settings = html::settings();

        auto season1 = season;
        season1.replace(4, 1, "_");
        auto file1 = sportDataFolder + "/eredivisie/eredivisie_" + season1 + ".csv";
        auto competition = football::footballCompetition();
        competition.readFromCsv(file1);

        auto out = html::rowContent();
        out.addContent("<html> <body>");

        auto teams = teams::clubTeams();
        auto file2 = sportDataFolder + "/clubs.csv";
        teams.InitFromFile(file2);

        const std::set<std::string> toppers = { "ajx", "fyn", "psv" };
        const auto filtered = competition.filter(toppers);
        auto content = html::table::buildTable(filtered.prepareTable(teams, settings));
        out.addContent(content);

        const auto currentRemarks = remarks.getSeason(season);
        int scoring = 3;
        for (const auto& row: currentRemarks)
        {
            if (row[0] == "scoring")
            {
                scoring = std::stoi(row[1]);
            }
        }

        auto table = football::results2standings::u2s(competition, scoring);

        auto file3 = sportDataFolder + "/eerste_divisie/eerste_divisie_" + season1 + ".csv";
        auto standing_1e_div = football::standings();
        standing_1e_div.initFromFile(file3);

        table.addExtras(extras, season);

        auto htmlTable = table.prepareTable(teams, settings);
        auto htmlTable2 = standing_1e_div.prepareTable(teams, settings);

        content = html::table::buildTable(htmlTable);
        out.addContent(content);
        content = html::table::buildTable(htmlTable2);
        out.addContent(content);

        // topscorers:
        auto players = teams::footballers();
        const std::string filename3 = sportDataFolder + "/voetballers.csv";
        players.initFromFile(filename3);

        auto file_tp_eredivisie = sportDataFolder + "/eredivisie/topscorers_eredivisie.csv";
        content = getTopScorers(file_tp_eredivisie, season, players, teams);
        out.addContent(content);

        auto file_tp_eerste_divisie = sportDataFolder + "/eerste_divisie/topscorers_eerste_divisie.csv";
        content = getTopScorers(file_tp_eerste_divisie, season, players, teams);
        out.addContent(content);

        // beker:
        const std::string bekerFilename = sportDataFolder + "/beker/beker_" + season1 +".csv";
        const auto r2f = football::route2finaleFactory::create(bekerFilename);
        const auto prepTable = r2f.prepareTable(teams, settings.lang);
        content = html::table::buildTable(prepTable);
        out.addContent(content);

        out.addContent("</body> </html>");

        return out;
    }

}
