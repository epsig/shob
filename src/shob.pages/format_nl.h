
#pragma once
#include <string>
#include <vector>
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.football/topscorers.h"

namespace shob::pages
{
    class format_nl
    {
    public:
        format_nl(std::string folder, readers::csvAllSeasonsReader extras, readers::csvAllSeasonsReader remarks) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), remarks(std::move(remarks)) {}
        void get_season_stdout(const std::string& season) const;
        html::rowContent get_season(const std::string& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        const readers::csvAllSeasonsReader remarks;
        static html::rowContent getTopScorers(const std::string& file, const std::string& season,
            const teams::footballers& players, const teams::clubTeams& teams);

    };
}
