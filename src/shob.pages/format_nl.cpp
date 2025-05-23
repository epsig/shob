
#include "format_nl.h"
#include <iostream>

#include "../shob.football/results2standings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.football/route2finalFactory.h"

namespace shob::pages
{
    void format_nl::get_season_stdout(const std::string& season) const
    {
        auto output = get_season(season);
        for (const auto& row : output)
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

    std::vector<std::string> format_nl::get_season(const std::string& season) const
    {
        auto competition = football::footballCompetition();

        auto season1 = season;
        season1.replace(4, 1, "_");
        auto file1 = sportDataFolder + "/eredivisie/eredivisie_" + season1 + ".csv";
        competition.readFromCsv(file1);

        auto table = football::results2standings::u2s(competition);

        auto teams = teams::clubTeams();
        auto file2 = sportDataFolder + "/clubs.csv";
        teams.InitFromFile(file2);

        auto file3 = sportDataFolder + "/eerste_divisie/eerste_divisie_" + season1 + ".csv";
        auto standing_1e_div = football::standings();
        standing_1e_div.initFromFile(file3);

        auto settings = html::settings();

        table.addExtras(extras, season);

        auto htmlTable = table.prepareTable(teams, settings);
        auto htmlTable2 = standing_1e_div.prepareTable(teams, settings);

        auto out = std::vector<html::rowContent>();

        out.push_back(html::table::buildTable(htmlTable));
        out.push_back(html::table::buildTable(htmlTable2));

        // topscorers:
        auto players = teams::footballers();
        const std::string filename3 = sportDataFolder + "/voetballers.csv";
        players.initFromFile(filename3);

        auto file_tp_eredivisie = sportDataFolder + "/eredivisie/topscorers_eredivisie.csv";
        out.push_back(getTopScorers(file_tp_eredivisie, season, players, teams));

        auto file_tp_eerste_divisie = sportDataFolder + "/eerste_divisie/topscorers_eerste_divisie.csv";
        out.push_back(getTopScorers(file_tp_eerste_divisie, season, players, teams));

        // beker:
        const std::string bekerFilename = sportDataFolder + "/beker/beker_" + season1 +".csv";
        const auto r2f = football::route2finaleFactory::create(bekerFilename);
        const auto prepTable = r2f.prepareTable(teams);
        out.push_back(html::table::buildTable(prepTable));

        std::vector<std::string> output;
        output.emplace_back("<html> <body>");
        for (const auto& part : out)
        {
            for (const auto& row : part.data)
            {
                output.push_back(row);
            }
        }
        output.emplace_back("</body> </html>");

        return output;
    }

}
