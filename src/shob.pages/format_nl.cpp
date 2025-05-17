
#include "format_nl.h"
#include <iostream>

#include "../shob.football/results2standings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.football/topscorers.h"

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

        auto out = html::table::buildTable(htmlTable);
        auto out2 = html::table::buildTable(htmlTable2);


        // top scorers:
        auto allTp = readers::csvAllSeasonsReader();
        auto file4 = sportDataFolder + "/eredivisie/topscorers_eredivisie.csv";

        allTp.init(file4);

        auto tp = football::topscorers(allTp);
        tp.initFromFile(season);

        auto players = teams::footballers();
        const std::string filename3 = sportDataFolder + "/voetballers.csv";
        players.initFromFile(filename3);

        auto table2 = tp.prepareTable(teams, players, settings);
        auto out3 = html::table::buildTable(table2);

        std::vector<std::string> output;
        output.emplace_back("<html> <body>");
        for (const auto& row : out.data)
        {
            output.push_back(row);
        }
        for (const auto& row : out2.data)
        {
            output.push_back(row);
        }
        for (const auto& row : out3.data)
        {
            output.push_back(row);
        }
        output.emplace_back("</body> </html>");

        return output;
    }

}
