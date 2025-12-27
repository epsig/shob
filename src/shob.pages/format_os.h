#pragma once
#include <string>
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"
#include "../shob.general/multipleStrings.h"

namespace shob::pages
{
    class format_os
    {
    public:
        format_os(std::string folder, readers::csvAllSeasonsReader reader, readers::csvContent dames, readers::csvContent heren, html::settings settings);
        general::multipleStrings get_pages(const int year) const;
        void get_pages_to_file(const int year, const std::string& filename) const;
        void get_pages_stdout(const int year) const;
    private:
        const std::string folder;
        const readers::csvAllSeasonsReader seasons_reader;
        const readers::csvContent dames;
        const readers::csvContent heren;
        const html::settings settings;
    };
}

