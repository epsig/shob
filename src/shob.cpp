
#include <string>
#include <iostream>

#include "shob.football/results2standings.h"
#include "shob.teams/clubTeams.h"

using namespace shob::football;

int main(int argc, char* argv[])
{
    if (argc < 2) return -1;
    std::string season = argv[1];

    auto competition = footballCompetition();

    auto season1 = season;
    season1.replace(4, 1, "_");
    auto file1 = "sport/eredivisie/eredivisie_" + season1 + ".csv";
    competition.readFromCsv(file1);

    auto table = results2standings::u2s(competition);

    auto teams = shob::teams::clubTeams();
    auto file2 = "sport/clubs.csv";
    teams.InitFromFile(file2);

    auto settings = shob::html::settings();

    auto extras = shob::readers::csvAllSeasonsReader();
    extras.init("sport/eredivisie/eredivisie_u2s.csv");
    table.addExtras(extras, season);

    auto htmlTable = table.prepareTable(teams, settings);

    auto out = shob::html::table::buildTable(htmlTable);

    std::cout << "<html> <body>" << std::endl;
    for (const auto& row : out.data)
    {
        std::cout << row << std::endl;
    }
    std::cout << "</body> </html>" << std::endl;
}
