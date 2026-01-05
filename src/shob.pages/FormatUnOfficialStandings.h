
#pragma once

#include <string>

#include "TopMenu.h"
#include "../shob.html/settings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.general/Season.h"
#include "../shob.readers/csvAllSeasonsReader.h"

namespace shob::pages
{
    class FormatUnOfficialStandings
    {
    public:
        FormatUnOfficialStandings(std::string folder, teams::clubTeams teams, TopMenu menu1,
          readers::csvAllSeasonsReader all_seasons_reader, const html::settings settings)
        : folder(std::move(folder)), teams(std::move(teams)), menu1(std::move(menu1)),
          all_seasons_reader(std::move(all_seasons_reader)),
        settings(settings) {}
        void getPagesToFile(const int year, const std::string& filename) const;
        void getPagesStdout(const int year) const;
    private:
        const std::string folder;
        const teams::clubTeams teams;
        const TopMenu menu1;
        const readers::csvAllSeasonsReader all_seasons_reader;
        const html::settings settings;
        general::MultipleStrings getPages(const int year) const;
        readers::csvContent readMatchesData(const general::Season& season) const;
        int getScoring(const general::Season& season) const;
    };
}

