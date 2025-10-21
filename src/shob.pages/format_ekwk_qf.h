#pragma once

#include "../shob.general/multipleStrings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "ekwk_date.h"

namespace shob::pages
{
    class format_ekwk_qf
    {
    public:
        format_ekwk_qf(std::string folder, teams::clubTeams teams, readers::csvAllSeasonsReader reader, html::settings settings) :
            dataSportFolder(std::move(folder)), teams(std::move(teams)), seasonsReader(std::move(reader)),
            settings(settings) {}
        general::multipleStrings get_pages(const int year) const;
        general::multipleStrings get_group_nl(const ekwk_date& ekwk, int& dd, const int star) const;
        void get_pages_to_file(const int year, const std::string& filename) const;
        void get_pages_stdout(const int year) const;
    private:
        std::string dataSportFolder;
        teams::clubTeams teams;
        readers::csvAllSeasonsReader seasonsReader;
        html::settings settings;
        static int findStar(const std::vector<std::vector<std::string>>& remarks);
    };
}
