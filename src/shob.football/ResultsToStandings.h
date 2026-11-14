
#pragma once

#include "FootballCompetition.h"
#include "Standings.h"

namespace shob::football
{
    class ResultsToStandings
    {
    public:
        static Standings u2s(const FootballCompetition& matches, const int scoring=3, const int sortRule=0);
        static void u2s_home_away(const FootballCompetition& matches, Standings& home, Standings& away, const int scoring = 3);
    };
}
