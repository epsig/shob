
#include "FootballMatch.h"
#include "../shob.html/funcs.h"

namespace shob::football
{
    int FootballMatch::winner() const
    {
        switch (star)  // NOLINT(clang-diagnostic-switch-enum)
        {
        case StarEnum::awayWins:
        case StarEnum::awayWinsXt:
        case StarEnum::awayWinsPenalties:
            return 1;
        case StarEnum::homeWins:
        case StarEnum::homeWinsXt:
        case StarEnum::homeWinsPenalties:
            return 0;
        default:
            return -1;
        }
    }

    bool FootballMatch::withSpectator() const
    {
        if (team2 == "straf") return false;
        if (result == "-") return false;
        if (spectators < 0) return false;
        return true;
    }

    std::string FootballMatch::nvns() const
    {
        switch (star)  // NOLINT(clang-diagnostic-switch-enum)
        {
        case StarEnum::awayWinsXt:
        case StarEnum::homeWinsXt:
            return " nv";
        case StarEnum::awayWinsPenalties:
        case StarEnum::homeWinsPenalties:
            return " ns";
        default:
            return "";
        }
    }

    std::string FootballMatch::printSimple(const teams::clubTeams& teams, const bool isReturn,
        const std::vector<html::addCountryType>& addCountry) const
    {
        std::vector expanded = { teams.expand(team1, addCountry[0]), teams.expand(team2, addCountry[1])};
        auto index = winner();
        if (index >= 0)
        {
            if (isReturn)
            {
                index = 1 - index;
            }
            if (isFinal)
            {
                expanded[index] = "<b>" + expanded[index] + "</b>";
            }
            else
            {
                expanded[index] += " *";
            }
        }
        auto datum = dd->toString();
        if ( ! stadium.empty())
        {
            datum = html::funcs::acronym(datum, "te: " + stadium);
        }
        if (link_name.empty())
        {
            return datum + " " + expanded[0] + " - " + expanded[1] + " " + result + nvns();
        }
        else
        {
            return datum + " <a href=#" + link_name + ">" + expanded[0] + " - " + expanded[1] + "</a> " + result + nvns();
        }
    }

    std::string FootballMatch::matchName(const teams::clubTeams& teams) const
    {
        std::vector expanded = { teams.expand(team1), teams.expand(team2) };
        return expanded[0] + " - " + expanded[1];
    }
};

