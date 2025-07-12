
#pragma once
#include <string>
#include <vector>
#include <map>
#include "../shob.general/uniqueStrings.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.html/table.h"
#include "../shob.html/settings.h"
#include "../shob.general/season.h"
#include "topMenu.h"

namespace shob::pages
{
    class wns_ec
    {
    public:
        int wns_cl;
        int scoring;
        std::map<std::string, int> groups;
        int getWns(const std::string& group) const
        {
            if (groups.contains(group))
            {
                return groups.at(group);
            }
            else
            {
                return wns_cl;
            }
        }
    };

    class format_ec
    {
    public:
        format_ec(std::string folder, readers::csvAllSeasonsReader& extras, teams::clubTeams& teams, const html::settings& settings,
            topMenu menu) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), teams(std::move(teams)), settings(settings),
            menu(std::move(menu)) {}
        void get_season_stdout(const general::season& season) const;
        void get_season_to_file(const general::season& season, const std::string& filename) const;
        general::multipleStrings get_season(const general::season& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        const teams::clubTeams teams;
        const html::settings settings;
        const topMenu menu;
        general::multipleStrings getFirstHalfYear(const std::string& part, const readers::csvContent& data, const wns_ec& wns_cl) const;
        static general::uniqueStrings getGroups(const std::string& part, const readers::csvContent& data);
        static general::uniqueStrings getParts(const readers::csvContent& data);
        static general::uniqueStrings getQualifiers(const std::string& part, const readers::csvContent& data);
        void readExtras(const general::season& season, wns_ec& wns_cl, general::multipleStrings& summary) const;
    };
}
