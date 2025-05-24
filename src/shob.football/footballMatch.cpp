
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
            return 1;
        case starEnum::homeWins:
        case starEnum::homeWinsXt:
        case starEnum::homeWinsPenalties:
            return 0;
        default:
            return -1;
        }
    }

    std::string footballMatch::printSimple(const teams::clubTeams& teams) const
    {
        std::vector expanded = { teams.expand(team1), teams.expand(team2) };
        const auto index = winner();
        if (index >= 0)
        {
            if (isFinal)
            {
                expanded[index] = "<b>" + expanded[index] + "</b>";
            }
            else
            {
                expanded[index] += " *";
            }
        }
        return dd->toShortString() + " " + expanded[0] + " - " + expanded[1] + " " + result;
    }
};


