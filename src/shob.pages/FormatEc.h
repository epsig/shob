#pragma once
#include <string>
#include <vector>
#include "FormatOnePageEachSeason.h"
#include "../shob.general/UniqueStrings.h"
#include "../shob.readers/CsvAllSeasonsReader.h"
#include "../shob.teams/ClubTeams.h"
#include "../shob.html/Settings.h"
#include "../shob.general/Season.h"
#include "../shob.football/LeagueNames.h"
#include "TopMenu.h"
#include "WnsEc.h"

namespace shob::pages
{
    class FormatEc : public FormatOnePageEachSeason
    {
    public:
        FormatEc(std::string folder, readers::CsvAllSeasonsReader& extras, teams::ClubTeams& teams, const html::Settings& settings,
            TopMenu menu, football::LeagueNames leagueNames) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), teams(std::move(teams)), settings(settings),
            menu(std::move(menu)), leagueNames(std::move(leagueNames)) {}
        general::MultipleStrings getSeason(const general::Season& season) const override;
        general::MultipleStrings getSeason(const general::Season& season, int& dd) const;
        bool isValidSeason(const general::Season& season) const override;
        std::string getOutputFilename(const std::string& folder, const general::Season& season) override;
        std::string getOutputFilename(const std::string& folder) const override;
        general::Season getLastSeason() const override;
        int get_dd() const override;
    private:
        const std::string sportDataFolder;
        const readers::CsvAllSeasonsReader extras;
        const teams::ClubTeams teams;
        const html::Settings settings;
        const TopMenu menu;
        const football::LeagueNames leagueNames;
        general::MultipleStrings getFirstHalfYear(const std::string& part, const readers::CsvContent& data, const WnsEc& wns_cl,
            const std::vector<std::vector<std::string>>& extraU2s, const int sortRule, int& dd) const;
        static general::UniqueStrings getGroups(const std::string& part, const readers::CsvContent& data);
        static general::UniqueStrings getQualifiers(const std::string& part, const readers::CsvContent& data);
        static general::UniqueStrings getXtra(const std::string& part, const readers::CsvContent& data);
        static std::string getRemarks(const std::string& part, const std::string& group, const std::vector<std::vector<std::string>>& extraU2s);
        general::MultipleStrings getInternalLinks(const std::vector<std::string>& ECparts, const readers::CsvContent& csvData) const;
        std::vector<std::vector<std::string>> readExtras(const general::Season& season, WnsEc& wns_cl, general::MultipleStrings& summary) const;
        static bool hasFinal(const std::string& part, const readers::CsvContent& csvData);
        general::MultipleStrings getSupercup(const readers::CsvContent& data, int& dd) const;
        static void readSortRule(int& sortRule, const std::vector<std::vector<std::string>>& extraU2s);
    };
}
