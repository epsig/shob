#pragma once
#include <string>
#include "../shob.readers/csvReader.h"

namespace shob::bookmarks
{
    class ConfigurableBookmarks
    {
    public:
        ConfigurableBookmarks(const std::string& folder);
    private:
        readers::csvContent archive;
        readers::csvContent config;
    };
}
