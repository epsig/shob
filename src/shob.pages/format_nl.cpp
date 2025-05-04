
#include "format_nl.h"
#include <iostream>

#include "../shob.football/results2standings.h"
#include "../shob.teams/clubTeams.h"

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

        auto settings = html::settings();

        auto extras = readers::csvAllSeasonsReader();
        extras.init(sportDataFolder + "/eredivisie/eredivisie_u2s.csv");
        table.addExtras(extras, season);

        auto htmlTable = table.prepareTable(teams, settings);

        auto out = html::table::buildTable(htmlTable);

        std::vector<std::string> output;
        output.emplace_back("<html> <body>");
        for (const auto& row : out.data)
        {
            output.push_back(row);
        }
        output.emplace_back("</body> </html>");

        return output;
    }

}
