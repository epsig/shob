
#include "format_ec.h"
#include <iostream>

#include "../shob.football/results2standings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.football/route2finalFactory.h"

namespace shob::pages
{
    void format_ec::get_season_stdout(const std::string& season) const
    {
        auto output = get_season(season);
        for (const auto& row : output)
        {
            std::cout << row << std::endl;
        }
    }

    std::vector<std::string> format_ec::get_season(const std::string& season) const
    {
        auto settings = html::settings();

        auto season1 = season;
        season1.replace(4, 1, "_");
        auto file1 = sportDataFolder + "/europacup/europacup_" + season1 + ".csv";
        //auto competition = football::footballCompetition();
        //competition.readFromCsv(file1);

        auto out = std::vector<html::rowContent>();

        auto teams = teams::clubTeams();
        auto file2 = sportDataFolder + "/clubs.csv";
        teams.InitFromFile(file2);

        auto ECparts = { "CL", "EL", "CF" };
        for (const auto& part : ECparts)
        {
            auto r2f = football::route2finaleFactory::createEC(file1, part);
            const auto prepTable = r2f.prepareTable(teams);
            out.push_back(html::table::buildTable(prepTable));
        }

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
