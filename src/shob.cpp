
#include <string>
#include <iostream>

#include "shob.football/results2standings.h"

using namespace shob::football;

int main(int argc, char* argv[])
{
    if (argc < 2) return -1;
    std::string file = argv[1];

    auto competition = footballCompetition();

    competition.readFromCsv(file);

    auto table = results2standings::u2s(competition);

    for (const auto& row : table.list)
    {
        std::cout << row.team << " " << row.totalGames << " " << row.points << " " << row.goalDifference() << std::endl;
    }

}
