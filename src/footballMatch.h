#pragma once

#include <string>

#include "DateTime.h"
#include "starEnum.h"

namespace shob::football
{
    class footballMatch
    {
    public:
        footballMatch(const std::string team1, const std::string team2, int dd, const std::string& result, int spectators)
            : team1(team1), team2(team2), dd(dd), result(result), spectators(spectators){}
        std::string team1; // id home playing team
        std::string team2; // id away playing team
        general::DateTime dd;
        std::string result; // in the form : "3-2"
        sport::starEnum star = sport::starEnum::unknownYet; // indication for who is going to the next round
        std::string stadium;
        std::string referee;
        int spectators;
        std::string remark;
    };

}

