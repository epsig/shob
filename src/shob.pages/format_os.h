#pragma once
#include <string>

#include "topmenu.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "../shob.general/multipleStrings.h"
#include "../shob.teams/clubTeams.h"

namespace shob::pages
{
    class format_os
    {
    public:
        format_os(std::string folder, readers::csvAllSeasonsReader reader, readers::csvContent dames,
            readers::csvContent heren, topMenu menu, teams::nationalTeams teams, html::settings settings);
        general::multipleStrings get_pages(const int year) const;
        void get_pages_to_file(const int year, const std::string& filename) const;
        void get_pages_stdout(const int year) const;
    private:
        const std::string folder;
        const readers::csvAllSeasonsReader seasons_reader;
        const readers::csvContent dames;
        const readers::csvContent heren;
        const topMenu menu;
        const teams::nationalTeams land_codes;
        const html::settings settings;
        readers::csvContent read_matches_data(const int year) const;
        general::multipleStrings get_numbers_one(const readers::csvContent& allData) const;
        static int findDate(const std::vector<std::vector<std::string>>& remarks);
        static std::string findTitle(const std::vector<std::vector<std::string>>& remarks);
        static std::string findName(const std::string& name, const readers::csvContent& listNames);
        static std::string print_time(const std::string& stime, const std::string& remark);
    };
}

