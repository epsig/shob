#pragma once

#include <vector>
#include "footballCompetition.h"
#include "../shob.html/table.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.html/settings.h"

namespace shob::football
{
    class RouteToFfinal
    {
    public:
        RouteToFfinal(FootballCompetition final, FootballCompetition semiFinal,
            FootballCompetition quarterFinal, FootballCompetition last16, FootballCompetition bronze = FootballCompetition()) :
            final(std::move(final)), semiFinal(std::move(semiFinal)), quarterFinal(std::move(quarterFinal)),
            last16(std::move(last16)), bronze(std::move(bronze)) {}
        std::vector<html::TableContent> prepareTable(const teams::clubTeams& teams, const html::Settings& settings) const;
        general::ItDate lastDate() const;
        bool empty() const;
        FootballCompetition getAllMatches() const;
        bool has_round(const std::string& round) const;
    private:
        FootballCompetition final;
        FootballCompetition semiFinal;
        FootballCompetition quarterFinal;
        FootballCompetition last16;
        FootballCompetition bronze;
        static void addOneRound(html::TableContent& table, const FootballCompetition& matches, const std::vector<int>& positions,
            const teams::clubTeams& teams, const size_t offset, const size_t maxCols, const html::Settings& settings,
            const std::vector<html::AddCountryType>& addCountry);
    };

}
