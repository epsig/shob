#pragma once

#include "FormatOnePageEachYear.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "TopMenu.h"
#include "PageBlock.h"

namespace shob::pages
{
    class FormatEkWk : public FormatOnePageEachYear
    {
    public:
        FormatEkWk(std::string data_sport_folder, teams::clubTeams teams, const html::settings& settings, readers::csvAllSeasonsReader remarks,
            readers::csvAllSeasonsReader top_scorers, TopMenu top_menu)
        : data_sport_folder(std::move(data_sport_folder)), teams(std::move(teams)), settings(settings), remarks(std::move(remarks)),
        top_scorers(std::move(top_scorers)), top_menu(std::move(top_menu)) {}

        general::MultipleStrings getPages(const int year) const override;
        PageBlock getLast16(const readers::csvContent& csv_content, int& dd) const;
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
        TopMenu top_menu;
    };
}
