#pragma once

#include <string>
#include <memory>
#include "../shob.general/shobDate.h"
#include "starEnum.h"
#include "../shob.teams/clubTeams.h"

namespace shob::football
{
    class footballMatch
    {
    public:
        footballMatch(const std::string& team1, const std::string& team2, std::shared_ptr<general::shobDate>& dd,
            const std::string& result, int spectators)
            : team1(team1), team2(team2), dd(dd), result(result), spectators(spectators) {}
        footballMatch(const std::string& team1, const std::string& team2, std::shared_ptr<general::shobDate>& dd,
            const std::string& result, int spectators, const starEnum star, const bool isFinal)
            : team1(team1), team2(team2), dd(dd), result(result), star(star), spectators(spectators), isFinal(isFinal) {}
        std::string team1; // id home playing team
        std::string team2; // id away playing team
        std::shared_ptr <general::shobDate> dd;
        std::string result; // in the form : "3-2"
        starEnum star = starEnum::unknownYet; // indication for who is going to the next round
        std::string stadium;
        std::string referee;
        int spectators;
        bool isFinal = false;
        std::string remark;
        int winner() const
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
        std::string printSimple(const teams::clubTeams& teams) const
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

}

