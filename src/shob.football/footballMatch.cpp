
#include "footballMatch.h"

namespace shob::football
{
    int footballMatch::winner() const
    {
        switch (star)
        {
        case starEnum::awayWins:
        case starEnum::awayWinsXt:
        case starEnum::awayWinsPenalties:
            return 2;
        case starEnum::homeWins:
        case starEnum::homeWinsXt:
        case starEnum::homeWinsPenalties:
            return 1;
        default:
            return 0;
        }
    }

    std::string footballMatch::printSimple(const teams::clubTeams& teams) const
    {
        auto expanded1 = teams.expand(team1);
        auto expanded2 = teams.expand(team2);
        if (isFinal && winner() == 1) expanded1 = "<b>" + expanded1 + "</b>";
        if (isFinal && winner() == 2) expanded2 = "<b>" + expanded2 + "</b>";
        if (!isFinal && winner() == 1) expanded1 += " *";
        if (!isFinal && winner() == 2) expanded2 += " *";
        return expanded1 + " - " + expanded2 + " " + result;
    }
};


