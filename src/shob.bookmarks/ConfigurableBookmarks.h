#pragma once
#include <string>
#include "../shob.readers/csvReader.h"

namespace shob::bookmarks
{
    struct PageProperties
    {
        std::string title;
        int dd = 0;
    };

    class ConfigurableBookmarks
    {
    public:
        ConfigurableBookmarks(const std::string& folder);
        bool getProperties(PageProperties& props, const std::string& page) const;
    private:
        readers::csvContent archive;
        readers::csvContent config;
    };
}
