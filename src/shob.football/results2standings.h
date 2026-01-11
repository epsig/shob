
#pragma once

#include "footballCompetition.h"
#include "standings.h"

namespace shob::football
{
    class results2standings
    {
    public:
        static standings u2s(const footballCompetition& matches, const int scoring=3, const int sortRule=0);
        static void u2s_home_away(const footballCompetition& matches, standings& home, standings& away, const int scoring = 3);
    };
}
