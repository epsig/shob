#pragma once
#include <string>

#include "topmenu.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "../shob.general/multipleStrings.h"
#include "../shob.teams/clubTeams.h"

namespace shob::pages
{
    /// <summary>
    /// class for generating the OS (Olympic games in Dutch) ice skating pages
    /// </summary>
    class FormatOs
    {
    public:
        FormatOs(std::string folder, readers::csvAllSeasonsReader reader, readers::csvContent dames,
            readers::csvContent heren, topMenu menu, teams::nationalTeams teams, html::settings settings);
        general::multipleStrings getPages(const int year) const;
        void getPagesToFile(const int year, const std::string& filename) const;
        void getPagesStdout(const int year) const;

        // public for unit testing only:
        static std::string printResult(const std::string& time_as_string, const std::string& remark);

    private:
        const std::string folder;
        const readers::csvAllSeasonsReader seasons_reader;
        const readers::csvContent dames;
        const readers::csvContent heren;
        const topMenu menu;
        const teams::nationalTeams land_codes;
        const html::settings settings;
        readers::csvContent readMatchesData(const int year) const;
        general::multipleStrings getNumbersOne(const readers::csvContent& all_data) const;
        general::multipleStrings getAllDistances(const char gender, const readers::csvContent& all_data) const;
        general::multipleStrings getOneDistance(const std::string& distance, const char gender, const readers::csvContent& all_data) const;
        static int findDate(const std::vector<std::vector<std::string>>& remarks);
        static std::string findTitle(const std::vector<std::vector<std::string>>& remarks);
        static std::string findName(const std::string& name, const readers::csvContent& listNames);
        static std::vector<std::string> findDistances(const char gender, const readers::csvContent& all_data);
        static std::string adjustTeam(const std::string& team);
    };
}

