#pragma once
#include <string>

#include "TopMenu.h"
#include "FormatOnePageEachYear.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "../shob.general/MultipleStrings.h"
#include "../shob.teams/clubTeams.h"

namespace shob::pages
{
    /// <summary>
    /// class for generating the OS (Olympic games in Dutch) ice skating pages
    /// </summary>
    class FormatOs : public FormatOnePageEachYear
    {
    public:
        FormatOs(std::string folder, readers::csvAllSeasonsReader reader, readers::csvContent dames,
            readers::csvContent heren, TopMenu menu, teams::nationalTeams teams, html::settings settings);
        general::MultipleStrings getPages(const int year) const override;
        bool isValidYear(const int year) const override;
        std::string getOutputFilename(const std::string& output_folder, const int year) const override;
        std::string getOutputFilename(const std::string& folder) const override;
        int getLastYear() const override;
        // public for unit testing only:
        static std::string printResult(const std::string& time_as_string, const std::string& remark);
    private:
        const std::string folder;
        const readers::csvAllSeasonsReader seasons_reader;
        const readers::csvContent dames;
        const readers::csvContent heren;
        const TopMenu menu;
        const teams::nationalTeams land_codes;
        const html::settings settings;
        readers::csvContent readMatchesData(const int year) const;
        general::MultipleStrings getNumbersOne(const readers::csvContent& all_data) const;
        general::MultipleStrings getAllDistances(const char gender, const readers::csvContent& all_data) const;
        general::MultipleStrings getOneDistance(const std::string& distance, const char gender, const readers::csvContent& all_data) const;
        static int findDate(const std::vector<std::vector<std::string>>& remarks);
        static std::string findTitle(const std::vector<std::vector<std::string>>& remarks);
        static std::string findName(const std::string& name, const readers::csvContent& listNames);
        static std::vector<std::string> findDistances(const char gender, const readers::csvContent& all_data);
        static std::string adjustTeam(const std::string& team);
    };
}

