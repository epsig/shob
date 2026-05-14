
#pragma once
#include <string>

#include "PageBlock.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.football/topscorers.h"
#include "../shob.general/Season.h"
#include "../shob.football/footballCompetition.h"
#include "TopMenu.h"

namespace shob::pages
{
    class FormatNL
    {
    public:
        FormatNL(std::string folder, readers::csvAllSeasonsReader extras, readers::csvAllSeasonsReader remarks, TopMenu menu,
            teams::clubTeams teams, html::settings settings) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), remarks(std::move(remarks)), menu(std::move(menu)),
            teams(std::move(teams)), settings(settings) {}
        void get_season_stdout(const general::Season& season) const;
        void get_season_to_file(const general::Season& season, const std::string& filename) const;
        general::MultipleStrings get_season(const general::Season& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        const readers::csvAllSeasonsReader remarks;
        const TopMenu menu;
        const teams::clubTeams teams;
        const html::settings settings;
        general::MultipleStrings getTopScorers(const std::string& file, const std::string& name_competition, const general::Season& season,
            const teams::footballers& players) const;
        PageBlock getSupercup(const readers::csvContent& dataBekerAndSupercup, const general::Season& season) const;
        PageBlock getKlassiekers(const football::footballCompetition& competition) const;
        PageBlock getStandEredivisie(const football::footballCompetition& competition, int scoring,
            const general::Season& season, const std::vector<std::vector<std::string>>& remarks_this_season) const;
        PageBlock getEersteDivisie(const general::Season& season) const;
        PageBlock getBothTopScorers(const general::Season& season) const;
    };
}
