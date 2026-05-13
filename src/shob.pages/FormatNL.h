
#pragma once
#include <string>

#include "PageBlock.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.football/topscorers.h"
#include "../shob.general/Season.h"
#include "TopMenu.h"

namespace shob::pages
{
    class FormatNL
    {
    public:
        FormatNL(std::string folder, readers::csvAllSeasonsReader extras, readers::csvAllSeasonsReader remarks, TopMenu menu) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), remarks(std::move(remarks)), menu(std::move(menu)) {}
        void get_season_stdout(const general::Season& season) const;
        void get_season_to_file(const general::Season& season, const std::string& filename) const;
        general::MultipleStrings get_season(const general::Season& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        const readers::csvAllSeasonsReader remarks;
        const TopMenu menu;
        static general::MultipleStrings getTopScorers(const std::string& file, const general::Season& season,
            const teams::footballers& players, const teams::clubTeams& teams);
        pageBlock getSupercup(const readers::csvContent& dataBekerAndSupercup, const teams::clubTeams& teams,
            const html::settings& settings, const general::Season& season) const;
    };
}
