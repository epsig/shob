
#pragma once
#include <string>
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.football/topscorers.h"
#include "../shob.general/season.h"
#include "topMenu.h"

namespace shob::pages
{
    class format_nl
    {
    public:
        format_nl(std::string folder, readers::csvAllSeasonsReader extras, readers::csvAllSeasonsReader remarks, topMenu menu) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), remarks(std::move(remarks)), menu(std::move(menu)) {}
        void get_season_stdout(const general::season& season) const;
        void get_season_to_file(const general::season& season, const std::string& filename) const;
        html::rowContent get_season(const general::season& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        const readers::csvAllSeasonsReader remarks;
        const topMenu menu;
        static html::rowContent getTopScorers(const std::string& file, const general::season& season,
            const teams::footballers& players, const teams::clubTeams& teams);
    };
}
