#pragma once

#include "footballCompetition.h"
#include "../shob.html/table.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.html/settings.h"

namespace shob::football
{
    class route2final
    {
    public:
        route2final(footballCompetition final, footballCompetition semiFinal,
            footballCompetition quarterFinal, footballCompetition last16) :
            final(std::move(final)), semiFinal(std::move(semiFinal)), quarterFinal(std::move(quarterFinal)), last16(std::move(last16)) {}
        html::tableContent prepareTable(const teams::clubTeams& teams, const html::settings& settings) const;
    private:
        footballCompetition final;
        footballCompetition semiFinal;
        footballCompetition quarterFinal;
        footballCompetition last16;
        static void addOneRound(html::tableContent& table, const footballCompetition& matches, const std::vector<int>& positions,
            const teams::clubTeams& teams, const size_t offset, const size_t maxCols, const html::settings settings,
            const std::vector<html::addCountryType>& addCountry);
    };

}
