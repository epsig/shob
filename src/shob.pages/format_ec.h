
#pragma once
#include <string>
#include <vector>
#include "../shob.general/uniqueStrings.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.html/settings.h"
#include "../shob.general/Season.h"
#include "../shob.football/leagueNames.h"
#include "topmenu.h"
#include "wns_ec.h"

namespace shob::pages
{
    class format_ec
    {
    public:
        format_ec(std::string folder, readers::csvAllSeasonsReader& extras, teams::clubTeams& teams, const html::settings& settings,
            topMenu menu, football::leagueNames leagueNames) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), teams(std::move(teams)), settings(settings),
            menu(std::move(menu)), leagueNames(std::move(leagueNames)) {}
        void get_season_stdout(const general::Season& season) const;
        void get_season_to_file(const general::Season& season, const std::string& filename) const;
        general::multipleStrings get_season(const general::Season& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        const teams::clubTeams teams;
        const html::settings settings;
        const topMenu menu;
        const football::leagueNames leagueNames;
        general::multipleStrings getFirstHalfYear(const std::string& part, const readers::csvContent& data, const wns_ec& wns_cl,
            const std::vector<std::vector<std::string>>& extraU2s, const int sortRule, int& dd) const;
        static general::uniqueStrings getGroups(const std::string& part, const readers::csvContent& data);
        static general::uniqueStrings getQualifiers(const std::string& part, const readers::csvContent& data);
        static general::uniqueStrings getXtra(const std::string& part, const readers::csvContent& data);
        static std::string getRemarks(const std::string& part, const std::string& group, const std::vector<std::vector<std::string>>& extraU2s);
        general::multipleStrings getInternalLinks(const std::vector<std::string>& ECparts, const readers::csvContent& csvData) const;
        std::vector<std::vector<std::string>> readExtras(const general::Season& season, wns_ec& wns_cl, general::multipleStrings& summary) const;
        static bool hasFinal(const std::string& part, const readers::csvContent& csvData);
        general::multipleStrings getSupercup(const readers::csvContent& data, int& dd) const;
        static void readSortRule(int& sortRule, const std::vector<std::vector<std::string>>& extraU2s);
    };
}
