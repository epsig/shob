#pragma once

#include <vector>
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
            footballCompetition quarterFinal, footballCompetition last16, footballCompetition bronze = footballCompetition()) :
            final(std::move(final)), semiFinal(std::move(semiFinal)), quarterFinal(std::move(quarterFinal)),
            last16(std::move(last16)), bronze(std::move(bronze)) {}
        std::vector<html::tableContent> prepareTable(const teams::clubTeams& teams, const html::settings& settings) const;
        general::itdate lastDate() const;
        bool empty() const;
        footballCompetition getAllMatches() const;
        bool has_round(const std::string& round) const;
    private:
        footballCompetition final;
        footballCompetition semiFinal;
        footballCompetition quarterFinal;
        footballCompetition last16;
        footballCompetition bronze;
        static void addOneRound(html::tableContent& table, const footballCompetition& matches, const std::vector<int>& positions,
            const teams::clubTeams& teams, const size_t offset, const size_t maxCols, const html::settings settings,
            const std::vector<html::addCountryType>& addCountry);
    };

}
