#pragma once
#include <string>
#include <vector>
#include "../shob.readers/csvReader.h"
#include "ListOfEvents.h"

namespace shob::bookmarks
{
    struct BlockProperties
    {
        std::string title;
        std::string name;
    };

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
        std::vector<BlockProperties> getAllParts(const std::string& page) const;
        ListOfEvents getEventsForBlock(const std::string& block) const;
    private:
        readers::csvContent archive;
        readers::csvContent config;
    };
}
