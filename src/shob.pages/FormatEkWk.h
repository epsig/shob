#pragma once

#include <boost/property_tree/ptree.hpp>

#include "EkWkDate.h"
#include "FormatOnePageEachYear.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "../shob.teams/footballer.h"
#include "TopMenu.h"
#include "PageBlock.h"
#include "../shob.football/standings.h"
#include "../shob.football/footballCompetition.h"
#include "../shob.football/route2final.h"

namespace shob::pages
{
    struct groupData
    {
        std::string name;
        std::string long_name;
        football::footballCompetition matches;
        football::standings standings;
    };

    struct groupList
    {
        std::vector<groupData> data;
    };

    class FormatEkWk : public FormatOnePageEachYear
    {
    public:
        FormatEkWk(std::string data_sport_folder, teams::clubTeams teams, const html::settings& settings, readers::csvAllSeasonsReader remarks,
            readers::csvAllSeasonsReader top_scorers, teams::footballers players, TopMenu top_menu)
        : data_sport_folder(std::move(data_sport_folder)), teams(std::move(teams)), settings(settings), remarks(std::move(remarks)),
        top_scorers(std::move(top_scorers)), players(std::move(players)), top_menu(std::move(top_menu)) {}

        general::MultipleStrings getPages(const int year) const override;
        bool isValidYear(const int year) const override;
        std::string getOutputFilename(const std::string& folder, const int year) const override;
        std::string getOutputFilename(const std::string& folder) const override;
        int getLastYear() const override;
    private:
        std::string data_sport_folder;
        teams::clubTeams teams;
        html::settings settings;
        readers::csvAllSeasonsReader remarks;
        readers::csvAllSeasonsReader top_scorers;
        teams::footballers players;
        TopMenu top_menu;
        PageBlock getRound2(const football::footballCompetition& round2, int& dd) const;
        PageBlock getLast16(const football::route2final& r2f, int& dd) const;
        static general::uniqueStrings getGroups(const readers::csvContent& data);
        static groupList getGroupData(const readers::csvContent& data);
        static football::footballCompetition getRound2data(const readers::csvContent& data);
        PageBlock getGroupResults(const groupList& groups, int& dd) const;
        PageBlock getStats(const football::route2final& r2f, const groupList& groups, const football::footballCompetition& round2) const;
        void getFieldsTable3(const std::vector<football::footballMatch>& matches, std::string& matchNames,
                             std::string& results) const;
        general::MultipleStrings table3_to_html(const football::strikingResults& data) const;
        general::MultipleStrings getExtraForOneMatch(const groupData& g, const football::linkInfo& link,
                                                     const std::string& ko_phase, const boost::property_tree::ptree& pt) const;
        PageBlock printExtras(const groupList& groups, const football::route2final& r2f, const std::string& filename_xml) const;
        PageBlock getTopscorers(const EkWkDate& ekwk) const;
    };
}
