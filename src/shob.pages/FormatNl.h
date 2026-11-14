
#pragma once
#include <string>

#include "FormatOnePageEachSeason.h"
#include "PageBlock.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.football/topscorers.h"
#include "../shob.general/Season.h"
#include "../shob.football/footballCompetition.h"
#include "TopMenu.h"

namespace shob::pages
{
    class FormatNL : public FormatOnePageEachSeason
    {
    public:
        FormatNL(std::string folder, readers::CsvAllSeasonsReader extras, readers::CsvAllSeasonsReader remarks, TopMenu menu,
            teams::ClubTeams teams, html::Settings settings) :
            sportDataFolder(std::move(folder)), extras(std::move(extras)), remarks(std::move(remarks)), menu(std::move(menu)),
            teams(std::move(teams)), settings(settings) {}
        bool isValidSeason(const general::Season& season) const override;
        general::MultipleStrings getSeason(const general::Season& season) const override;
        general::MultipleStrings getSeason(const general::Season& season, int& dd) const;
        std::string getOutputFilename(const std::string& folder, const general::Season& season) override;
        std::string getOutputFilename(const std::string& folder) const override { return ""; }
        general::Season getLastSeason() const override;
        int get_dd() const override;
    private:
        const std::string sportDataFolder;
        const readers::CsvAllSeasonsReader extras;
        const readers::CsvAllSeasonsReader remarks;
        const TopMenu menu;
        const teams::ClubTeams teams;
        const html::Settings settings;
        general::MultipleStrings getTopScorers(const std::string& file, const std::string& name_competition, const general::Season& season,
            const teams::Footballers& players) const;
        PageBlock getSupercup(const readers::CsvContent& dataBekerAndSupercup, const general::Season& season, int& dd) const;
        PageBlock getKlassiekers(const football::FootballCompetition& competition) const;
        PageBlock getStandEredivisie(const football::FootballCompetition& competition, int scoring,
            const general::Season& season, const std::vector<std::vector<std::string>>& remarks_this_season) const;
        PageBlock getEersteDivisie(const general::Season& season) const;
        PageBlock getBothTopScorers(const general::Season& season) const;
        PageBlock getBeker(const readers::CsvContent& dataBekerAndSupercup, int& dd) const;
        PageBlock getToEuropacup(const general::Season& season) const;
    };
}
