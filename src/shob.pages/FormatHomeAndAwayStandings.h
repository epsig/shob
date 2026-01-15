
#pragma once

#include <string>

#include "TopMenu.h"
#include "../shob.html/settings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.general/Season.h"
#include "../shob.readers/csvAllSeasonsReader.h"

namespace shob::pages
{
    class FormatHomeAndAwayStandings
    {
    public:
        FormatHomeAndAwayStandings(std::string folder, teams::clubTeams teams, TopMenu menu,
            readers::csvAllSeasonsReader all_seasons_reader, const html::settings settings)
            : folder(std::move(folder)), teams(std::move(teams)), menu(std::move(menu)),
            all_seasons_reader(std::move(all_seasons_reader)), settings(settings) {}
        void getPagesToFile(const general::Season& season, const std::string& filename) const;
        void getPagesStdout(const general::Season& season) const;
        general::MultipleStrings getSeason(const general::Season& season) const;
    private:
        const std::string folder;
        const teams::clubTeams teams;
        const TopMenu menu;
        const readers::csvAllSeasonsReader all_seasons_reader;
        const html::settings settings;
        readers::csvContent readMatchesData(const general::Season& season) const;
        int getScoring(const general::Season& season) const;
    };
}

