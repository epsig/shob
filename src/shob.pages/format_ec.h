
#pragma once
#include <string>
#include <vector>
#include <map>
#include "../shob.general/uniqueStrings.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.html/settings.h"
#include "../shob.general/season.h"
#include "../shob.football/leagueNames.h"
#include "../shob.football/footballCompetition.h"
#include "topmenu.h"

namespace shob::pages
{
    class wns_ec
    {
    public:
        int wns_cl;
        int scoring;
        std::map<std::string, int> groups;
        int getWns(const std::string& part, const std::string& group, const football::footballCompetition& matches) const
        {
            if (groups.contains(group))
            {
                return groups.at(group);
            }
            else if (wns_cl != -1)
            {
                return wns_cl;
            }
            else if (matches.matches.size() == 12)
            {
                return (part == "CL" && group.find('2') == std::string::npos ? 2 : 1);
            }
            else if (matches.matches.size() == 10 && part == "UEFAcup")
            {
                return 5;
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
            topMenu menu, football::leagueNames leagueNames) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), teams(std::move(teams)), settings(settings),
            menu(std::move(menu)), leagueNames(std::move(leagueNames)) {}
        void get_season_stdout(const general::season& season) const;
        void get_season_to_file(const general::season& season, const std::string& filename) const;
        general::multipleStrings get_season(const general::season& season) const;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        const teams::clubTeams teams;
        const html::settings settings;
        const topMenu menu;
        const football::leagueNames leagueNames;
        general::multipleStrings getFirstHalfYear(const std::string& part, const readers::csvContent& data, const wns_ec& wns_cl,
            const std::vector<std::vector<std::string>>& extraU2s, const int sortRule) const;
        static general::uniqueStrings getGroups(const std::string& part, const readers::csvContent& data);
        static general::uniqueStrings getQualifiers(const std::string& part, const readers::csvContent& data);
        static general::uniqueStrings getXtra(const std::string& part, const readers::csvContent& data);
        static std::string getRemarks(const std::string& part, const std::string& group, const std::vector<std::vector<std::string>>& extraU2s);
        general::multipleStrings getInternalLinks(const std::vector<std::string>& ECparts, const readers::csvContent& csvData) const;
        std::vector<std::vector<std::string>> readExtras(const general::season& season, wns_ec& wns_cl, general::multipleStrings& summary) const;
        static bool hasFinal(const std::string& part, const readers::csvContent& csvData);
        general::multipleStrings getSupercup(const readers::csvContent& data) const;
        static void readSortRule(int& sortRule, const std::vector<std::vector<std::string>>& extraU2s);
    };
}
