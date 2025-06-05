
#pragma once
#include <string>
#include <vector>
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.html/table.h"

namespace shob::pages
{
    class format_ec
    {
    public:
        format_ec(std::string& folder, readers::csvAllSeasonsReader& extras) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)) {}
        void get_season_stdout(const std::string& season) const;
        std::vector<std::string> get_season(const std::string& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        static html::rowContent getFirstHalfYear(const std::string& part, const std::string& filename, const teams::clubTeams& teams);
    };
}
