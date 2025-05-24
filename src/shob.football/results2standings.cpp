
#include "results2standings.h"
#include "../shob.readers/csvReader.h"

namespace shob::football
{

    standings results2standings::u2s(const footballCompetition& matches)
    {
        auto table = standings();

        for (const auto& match : matches.matches)
        {
            const auto& score = match.result;
            if (score == "-")
            {
                continue;
            }
            else if (match.team2 == "straf")
            {
                auto pnts = std::stoi(score);
                table.handlePunishment(match.team1, pnts);
            }
            else
            {
                const auto parts = readers::csvReader::split(score, "-").column;
                const auto goals1 = std::stoi(parts[0]);
                const auto goals2 = std::stoi(parts[1]);
                table.addResult(match.team1, match.team2, goals1, goals2);
            }
        }
        table.sort();

        return table;
    }
}
