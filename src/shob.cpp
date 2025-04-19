
#include <string>
#include <iostream>

#include "results2standings.h"

int main(int argc, char* argv[])
{
    if (argc < 2) return -1;
    std::string file = argv[1];

    auto competition = shob::football::footballCompetition();

    competition.readFromCsv(file);

    auto table = shob::football::results2standings::u2s(competition);

    for (const auto& row : table.list)
    {
        std::cout << row.team << " " << row.totalGames << " " << row.points << " " << row.goalDifference() << std::endl;
    }

}
