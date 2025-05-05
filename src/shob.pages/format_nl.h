
#pragma once
#include <string>
#include <vector>
#include "../shob.readers/csvAllSeasonsReader.h"

namespace shob::pages
{
    class format_nl
    {
    public:
        format_nl(const std::string& folder, const readers::csvAllSeasonsReader& extras) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)) {}
        void get_season_stdout(const std::string& season) const;
        std::vector<std::string> get_season(const std::string& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
    };
}
