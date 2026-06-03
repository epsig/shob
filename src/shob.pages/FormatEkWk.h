#pragma once

#include "FormatOnePageEachYear.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "TopMenu.h"

namespace shob::pages
{
    class FormatEkWk : public FormatOnePageEachYear
    {
    public:
        FormatEkWk(std::string data_sport_folder, const html::settings& settings, readers::csvAllSeasonsReader remarks,
            readers::csvAllSeasonsReader top_scorers, TopMenu top_menu)
        : data_sport_folder(std::move(data_sport_folder)), settings(settings), remarks(std::move(remarks)),
        top_scorers(std::move(top_scorers)), top_menu(std::move(top_menu)) {}

        general::MultipleStrings getPages(const int year) const override;
        bool isValidYear(const int year) const override;
        std::string getOutputFilename(const std::string& folder, const int year) const override;
        std::string getOutputFilename(const std::string& folder) const override;
        int getLastYear() const override;
    private:
        std::string data_sport_folder;
        html::settings settings;
        readers::csvAllSeasonsReader remarks;
        readers::csvAllSeasonsReader top_scorers;
        TopMenu top_menu;
    };
}
