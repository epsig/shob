#pragma once

#include <vector>
#include "FootballCompetition.h"
#include "../shob.html/Table.h"
#include "../shob.teams/ClubTeams.h"
#include "../shob.html/Settings.h"

namespace shob::football
{
    class RouteToFinal
    {
    public:
        RouteToFinal(FootballCompetition final, FootballCompetition semiFinal,
            FootballCompetition quarterFinal, FootballCompetition last16, FootballCompetition bronze = FootballCompetition()) :
            final(std::move(final)), semiFinal(std::move(semiFinal)), quarterFinal(std::move(quarterFinal)),
            last16(std::move(last16)), bronze(std::move(bronze)) {}
        std::vector<html::TableContent> prepareTable(const teams::ClubTeams& teams, const html::Settings& settings) const;
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
            const teams::ClubTeams& teams, const size_t offset, const size_t maxCols, const html::Settings& settings,
            const std::vector<html::AddCountryType>& addCountry);
    };

}
