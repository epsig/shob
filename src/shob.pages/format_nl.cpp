
#include "format_nl.h"
#include <iostream>

#include "../shob.football/results2standings.h"
#include "../shob.teams/clubTeams.h"

namespace shob::pages
{
    void format_nl::get_season(const std::string& season)
    {
        auto competition = football::footballCompetition();

        auto season1 = season;
        season1.replace(4, 1, "_");
        auto file1 = "sport/eredivisie/eredivisie_" + season1 + ".csv";
        competition.readFromCsv(file1);

        auto table = football::results2standings::u2s(competition);

        auto teams = teams::clubTeams();
        auto file2 = "sport/clubs.csv";
        teams.InitFromFile(file2);

        auto settings = html::settings();

        auto extras = readers::csvAllSeasonsReader();
        extras.init("sport/eredivisie/eredivisie_u2s.csv");
        table.addExtras(extras, season);

        auto htmlTable = table.prepareTable(teams, settings);

        auto out = html::table::buildTable(htmlTable);

        std::cout << "<html> <body>" << std::endl;
        for (const auto& row : out.data)
        {
            std::cout << row << std::endl;
        }
        std::cout << "</body> </html>" << std::endl;
    }

}
