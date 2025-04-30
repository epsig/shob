
#include <string>
#include <iostream>

#include "shob.football/results2standings.h"
#include "shob.teams/clubTeams.h"

using namespace shob::football;

int main(int argc, char* argv[])
{
    if (argc < 3) return -1;
    std::string file1 = argv[1];
    std::string file2 = argv[2];

    auto competition = footballCompetition();

    competition.readFromCsv(file1);

    auto table = results2standings::u2s(competition);

    auto teams = shob::teams::clubTeams();
    teams.InitFromFile(file2);

    auto settings = shob::html::settings();

    auto htmlTable = table.prepareTable(teams, settings);

    auto out = shob::html::table::buildTable(htmlTable);

    std::cout << "<html> <body>" << std::endl;
    for (const auto& row : out.data)
    {
        std::cout << row << std::endl;
    }
    std::cout << "</body> </html>" << std::endl;
}
