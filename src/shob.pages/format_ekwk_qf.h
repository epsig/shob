#pragma once

#include "FormatOnePageEachYear.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "../shob.football/footballCompetition.h"
#include "../shob.football/standings.h"
#include "ekwk_date.h"
#include "TopMenu.h"
#include <map>

namespace shob::pages
{
    class format_ekwk_qf : public FormatOnePageEachYear
    {
    public:
        format_ekwk_qf(std::string folder, teams::clubTeams teams, readers::csvAllSeasonsReader reader, html::settings settings,
            TopMenu menu, std::map<std::string, std::string> organizingCountries, football::footballCompetition allFriendlies) :
            dataSportFolder(std::move(folder)), teams(std::move(teams)), seasonsReader(std::move(reader)),
            settings(settings), menu(std::move(menu)), organizingCountries(std::move(organizingCountries)),
            allFriendlies(std::move(allFriendlies)) {}
        general::MultipleStrings getPages(const int year) const override;
        bool isValidYear(const int year) const override;
        std::string getOutputFilename(const std::string& folder, const int year) const override;
        std::string getOutputFilename(const std::string& folder) const override;
        int getLastYear() const override;
    private:
        std::string dataSportFolder;
        teams::clubTeams teams;
        readers::csvAllSeasonsReader seasonsReader;
        html::settings settings;
        TopMenu menu;
        std::map<std::string, std::string> organizingCountries;
        football::footballCompetition allFriendlies;
        readers::csvContent read_matches_data(const ekwk_date& ekwk, const char type) const;
        static general::MultipleStrings filter_remarks(const std::vector<std::vector<std::string>>& remarks, const std::string& key);
        general::MultipleStrings get_group_nl(int& dd, const int star, const readers::csvContent& matches_data, const general::MultipleStrings& remarks) const;
        general::MultipleStrings get_virtual_standings(const ekwk_date& ekwk, general::MultipleStrings& opms_vstand) const;
        general::MultipleStrings get_play_offs(int& dd, const readers::csvContent& matches_data) const;
        general::MultipleStrings print_splitted(const football::standings& stand, const football::footballCompetition& matches,
            const general::MultipleStrings& remarks, const std::string& title, const std::string& title2) const;
        general::MultipleStrings get_nationsLeagueFinals(const int& year, int& dd) const;
        general::MultipleStrings get_nationsLeagueGroupPhase(const int& year, int& dd) const;
        general::MultipleStrings get_friendlies(const int& year, const std::vector<std::vector<std::string>>& remarks, int& dd) const;
        general::MultipleStrings get_other_standings(const ekwk_date& ekwk, const std::string& title) const;
        general::MultipleStrings get_list_qualified_countries(const ekwk_date& ekwk, const std::string& title_qualified) const;
        static int findStar(const std::vector<std::vector<std::string>>& remarks);
    };
}
