#pragma once

#include "../shob.general/multipleStrings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "../shob.football/footballCompetition.h"
#include "../shob.football/standings.h"
#include "ekwk_date.h"
#include "topmenu.h"
#include <map>

namespace shob::pages
{
    class format_ekwk_qf
    {
    public:
        format_ekwk_qf(std::string folder, teams::clubTeams teams, readers::csvAllSeasonsReader reader, html::settings settings,
            topMenu menu, std::map<std::string, std::string> organizingCountries, football::footballCompetition allFriendlies) :
            dataSportFolder(std::move(folder)), teams(std::move(teams)), seasonsReader(std::move(reader)),
            settings(settings), menu(std::move(menu)), organizingCountries(std::move(organizingCountries)),
            allFriendlies(std::move(allFriendlies)) {}
        general::multipleStrings get_pages(const int year) const;
        void get_pages_to_file(const int year, const std::string& filename) const;
        void get_pages_stdout(const int year) const;
    private:
        std::string dataSportFolder;
        teams::clubTeams teams;
        readers::csvAllSeasonsReader seasonsReader;
        html::settings settings;
        topMenu menu;
        std::map<std::string, std::string> organizingCountries;
        football::footballCompetition allFriendlies;
        readers::csvContent read_matches_data(const ekwk_date& ekwk, const char type) const;
        static general::multipleStrings filter_remarks(const std::vector<std::vector<std::string>>& remarks, const std::string& key);
        general::multipleStrings get_group_nl(int& dd, const int star, const readers::csvContent& matches_data, const general::multipleStrings& remarks) const;
        general::multipleStrings get_virtual_standings(const ekwk_date& ekwk, general::multipleStrings& opms_vstand) const;
        general::multipleStrings get_play_offs(int& dd, const readers::csvContent& matches_data) const;
        general::multipleStrings print_splitted(const football::standings& stand, const football::footballCompetition& matches,
            const general::multipleStrings& remarks, const std::string& title, const std::string& title2) const;
        general::multipleStrings get_nationsLeagueFinals(const int& year, int& dd) const;
        general::multipleStrings get_nationsLeagueGroupPhase(const int& year, int& dd) const;
        general::multipleStrings get_friendlies(const int& year, const std::vector<std::vector<std::string>>& remarks, int& dd) const;
        general::multipleStrings get_other_standings(const ekwk_date& ekwk, const std::string& title) const;
        general::multipleStrings get_list_qualified_countries(const ekwk_date& ekwk, const std::string& title_qualified) const;
        static int findStar(const std::vector<std::vector<std::string>>& remarks);
    };
}
