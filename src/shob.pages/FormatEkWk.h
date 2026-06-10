#pragma once

#include "EkWkDate.h"
#include "FormatOnePageEachYear.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "../shob.teams/footballer.h"
#include "TopMenu.h"
#include "PageBlock.h"

namespace shob::pages
{
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
        PageBlock getLast16(const readers::csvContent& csv_content, int& dd) const;
        static general::uniqueStrings getGroups(const readers::csvContent& data);
        PageBlock getGroupResults(const readers::csvContent& data, int& dd) const;
        PageBlock getTopscorers(const EkWkDate& ekwk) const;
    };
}
