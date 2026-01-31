
#pragma once
#include <string>
#include <vector>
#include "FormatOnePageEachSeason.h"
#include "../shob.general/uniqueStrings.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.html/settings.h"
#include "../shob.general/Season.h"
#include "../shob.football/leagueNames.h"
#include "TopMenu.h"
#include "wns_ec.h"

namespace shob::pages
{
    class format_ec : public FormatOnePageEachSeason
    {
    public:
        format_ec(std::string folder, readers::csvAllSeasonsReader& extras, teams::clubTeams& teams, const html::settings& settings,
            TopMenu menu, football::leagueNames leagueNames) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), teams(std::move(teams)), settings(settings),
            menu(std::move(menu)), leagueNames(std::move(leagueNames)) {}
        general::MultipleStrings getSeason(const general::Season& season) const override;
        bool isValidSeason(const general::Season& season) const override;
        std::string getOutputFilename(const std::string& folder, const general::Season& season) override;
        std::string getOutputFilename(const std::string& folder) const override;
        general::Season getLastSeason() const override;
    private:
        const std::string sportDataFolder;
        const readers::csvAllSeasonsReader extras;
        const teams::clubTeams teams;
        const html::settings settings;
        const TopMenu menu;
        const football::leagueNames leagueNames;
        general::MultipleStrings getFirstHalfYear(const std::string& part, const readers::csvContent& data, const wns_ec& wns_cl,
            const std::vector<std::vector<std::string>>& extraU2s, const int sortRule, int& dd) const;
        static general::uniqueStrings getGroups(const std::string& part, const readers::csvContent& data);
        static general::uniqueStrings getQualifiers(const std::string& part, const readers::csvContent& data);
        static general::uniqueStrings getXtra(const std::string& part, const readers::csvContent& data);
        static std::string getRemarks(const std::string& part, const std::string& group, const std::vector<std::vector<std::string>>& extraU2s);
        general::MultipleStrings getInternalLinks(const std::vector<std::string>& ECparts, const readers::csvContent& csvData) const;
        std::vector<std::vector<std::string>> readExtras(const general::Season& season, wns_ec& wns_cl, general::MultipleStrings& summary) const;
        static bool hasFinal(const std::string& part, const readers::csvContent& csvData);
        general::MultipleStrings getSupercup(const readers::csvContent& data, int& dd) const;
        static void readSortRule(int& sortRule, const std::vector<std::vector<std::string>>& extraU2s);
    };
}
