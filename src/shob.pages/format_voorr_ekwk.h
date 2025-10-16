#pragma once

#include "../shob.general/multipleStrings.h"
#include "../shob.teams/clubTeams.h"

namespace shob::pages
{
    class format_voorr_ekwk
    {
    public:
        format_voorr_ekwk(std::string folder, teams::clubTeams teams) :
            dataSportFolder(std::move(folder)), teams(std::move(teams)) {}
        general::multipleStrings get_pages(const int year) const;
        void get_pages_to_file(const int year, const std::string& filename) const;
        void get_pages_stdout(const int year) const;
    private:
        std::string dataSportFolder;
        teams::clubTeams teams;
    };
}
