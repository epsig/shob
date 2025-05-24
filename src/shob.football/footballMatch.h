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
        footballMatch(std::string team1, std::string team2, const std::shared_ptr<general::shobDate>& dd,
            std::string result, int spectators)
            : team1(std::move(team1)), team2(std::move(team2)), dd(dd), result(std::move(result)),
              spectators(spectators) {}
        footballMatch(std::string team1, std::string team2, const std::shared_ptr<general::shobDate>& dd,
            std::string result, int spectators, const starEnum star, const bool isFinal)
            : team1(std::move(team1)), team2(std::move(team2)), dd(dd), result(std::move(result)),
              star(star), spectators(spectators), isFinal(isFinal) {}
        std::string printSimple(const teams::clubTeams& teams) const;
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
    private:
        int winner() const;
        std::string nvns() const;
    };

}

