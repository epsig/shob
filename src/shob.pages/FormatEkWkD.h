#pragma once

#include "FormatOnePageEachYear.h"
#include "../shob.teams/ClubTeams.h"
#include "../shob.readers/CsvAllSeasonsReader.h"
#include "../shob.html/Settings.h"
#include "../shob.teams/Footballer.h"
#include "TopMenu.h"
#include "../shob.football/FootballCompetition.h"

namespace shob::pages
{
    class FormatEkWkD : public FormatOnePageEachYear
    {
    public:
        FormatEkWkD(std::string data_sport_folder, teams::ClubTeams teams, const html::Settings& settings, readers::CsvAllSeasonsReader remarks,
            readers::CsvAllSeasonsReader top_scorers, teams::Footballers players, TopMenu top_menu)
        : data_sport_folder(std::move(data_sport_folder)), teams(std::move(teams)), settings(settings), remarks(std::move(remarks)),
        top_scorers(std::move(top_scorers)), players(std::move(players)), top_menu(std::move(top_menu)) {}

        general::MultipleStrings getPages(const int year) const override;
        bool isValidYear(const int year) const override;
        std::string getOutputFilename(const std::string& folder, const int year) const override;
        std::string getOutputFilename(const std::string& folder) const override;
        int getLastYear() const override;
    private:
        std::string data_sport_folder;
        teams::ClubTeams teams;
        html::Settings settings;
        readers::CsvAllSeasonsReader remarks;
        readers::CsvAllSeasonsReader top_scorers;
        teams::Footballers players;
        TopMenu top_menu;
    };
}
