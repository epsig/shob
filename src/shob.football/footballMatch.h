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
        footballMatch(const std::string& team1, const std::string& team2, std::shared_ptr<general::shobDate>& dd, const std::string& result, int spectators)
            : team1(team1), team2(team2), dd(dd), result(result), spectators(spectators) {}
        std::string team1; // id home playing team
        std::string team2; // id away playing team
        std::shared_ptr <general::shobDate> dd;
        std::string result; // in the form : "3-2"
        starEnum star = starEnum::unknownYet; // indication for who is going to the next round
        std::string stadium;
        std::string referee;
        int spectators;
        std::string remark;
        std::string printSimple(const teams::clubTeams& teams) const
        {
            return teams.expand(team1) + " - " + teams.expand(team2) + " " + result;
        }
    };

}

