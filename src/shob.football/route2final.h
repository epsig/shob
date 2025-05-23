#pragma once

#include "footballCompetition.h"
#include "../shob.html/table.h"
#include "../shob.teams/clubTeams.h"

namespace shob::football
{
    class route2final
    {
    public:
        route2final(footballCompetition final, footballCompetition semiFinal,
            footballCompetition quarterFinal, footballCompetition last16) :
            final(std::move(final)), semiFinal(std::move(semiFinal)), quarterFinal(std::move(quarterFinal)), last16(std::move(last16)) {}
        html::tableContent prepareTable(const teams::clubTeams& teams) const;
    private:
        footballCompetition final;
        footballCompetition semiFinal;
        footballCompetition quarterFinal;
        footballCompetition last16;
    };

}
