#pragma once

#include "FormatOnePageEachSeason.h"
#include "TopMenu.h"
#include "../shob.html/Settings.h"
#include "../shob.teams/ClubTeams.h"
#include "../shob.general/Season.h"
#include "../shob.readers/CsvAllSeasonsReader.h"

namespace shob::pages
{
    class FormatHomeAndAwayStandings : public FormatOnePageEachSeason
    {
    public:
        FormatHomeAndAwayStandings(std::string folder, teams::ClubTeams teams, TopMenu menu,
            readers::CsvAllSeasonsReader all_seasons_reader, const html::Settings& settings)
            : folder(std::move(folder)), teams(std::move(teams)), menu(std::move(menu)),
            all_seasons_reader(std::move(all_seasons_reader)), settings(settings) {}
        general::MultipleStrings getSeason(const general::Season& season) const override;
        bool isValidSeason(const general::Season& season) const override;
        std::string getOutputFilename(const std::string& folder, const general::Season& season) override;
        std::string getOutputFilename(const std::string& folder) const override;
        general::Season getLastSeason() const override;
    private:
        const std::string folder;
        const teams::ClubTeams teams;
        const TopMenu menu;
        const readers::CsvAllSeasonsReader all_seasons_reader;
        const html::Settings settings;
        readers::CsvContent readMatchesData(const general::Season& season) const;
        int getScoring(const general::Season& season) const;
    };
}

