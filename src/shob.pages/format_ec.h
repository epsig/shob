
#pragma once
#include <string>
#include <vector>
#include "../shob.general/uniqueStrings.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.html/table.h"

namespace shob::pages
{
    class format_ec
    {
    public:
        format_ec(std::string folder, readers::csvAllSeasonsReader& extras, teams::clubTeams& teams) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), teams(std::move(teams)) {}
        void get_season_stdout(const std::string& season) const;
        html::rowContent get_season(const std::string& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        const teams::clubTeams teams;
        html::rowContent getFirstHalfYear(const std::string& part, const readers::csvContent& data,
            const std::string& season) const;
        static general::uniqueStrings getGroups(const std::string& part, const readers::csvContent& data);
        static general::uniqueStrings getParts(const readers::csvContent& data);
        static general::uniqueStrings getQualifiers(const std::string& part, const readers::csvContent& data);
    };
}
