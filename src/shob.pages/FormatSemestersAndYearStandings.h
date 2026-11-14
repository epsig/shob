#pragma once

#include "FormatOnePageEachYear.h"
#include "TopMenu.h"
#include "../shob.html/Settings.h"
#include "../shob.teams/ClubTeams.h"
#include "../shob.readers/CsvAllSeasonsReader.h"

namespace shob::pages
{
    class FormatSemestersAndYearStandings: public FormatOnePageEachYear
    {
    public:
        FormatSemestersAndYearStandings(std::string folder, teams::ClubTeams teams, TopMenu menu,
          readers::CsvAllSeasonsReader all_seasons_reader,int last_year, const html::Settings& settings)
        : folder(std::move(folder)), teams(std::move(teams)), menu(std::move(menu)),
          all_seasons_reader(std::move(all_seasons_reader)), last_year(last_year), settings(settings) {}
        general::MultipleStrings getPages(const int year) const override;
        std::string getOutputFilename(const std::string& folder) const override;
        bool isValidYear(const int year) const override;
        std::string getOutputFilename(const std::string& folder, const int year) const override;
        int getLastYear() const override;
    private:
        const std::string folder;
        const teams::ClubTeams teams;
        const TopMenu menu;
        const readers::CsvAllSeasonsReader all_seasons_reader;
        const int last_year;
        const html::Settings settings;
        readers::CsvContent readMatchesData(const general::Season& season) const;
        int getScoring(const general::Season& season) const;
    };
}
