#include "ConfigurableBookmarks.h"
#include "../shob.general/dateFactory.h"

namespace shob::bookmarks
{
    using namespace shob::readers;

    ConfigurableBookmarks::ConfigurableBookmarks(const std::string& folder)
    {
        archive = csvReader::readCsvFile(folder + "/archive.csv");
        config = csvReader::readCsvFile(folder + "/config.csv");
    }

    bool ConfigurableBookmarks::getProperties(PageProperties& props, const std::string& page) const
    {
        bool return_value = false;
        for (const auto& row : config.body)
        {
            if (row.column.size() >= 3 && row.column[0] == page)
            {
                return_value = true;
                if (row.column[1] == "title")
                {
                    props.title = row.column[2];
                }
                else if (row.column[1] == "dd" && general::dateFactory::isInt(row.column[2]))
                {
                    props.dd = std::stoi(row.column[2]);
                }
            }
        }
        return return_value;
    }

    std::vector<BlockProperties> ConfigurableBookmarks::getAllParts(const std::string& page) const
    {
        std::vector<BlockProperties> return_value;
        for (const auto& row : config.body)
        {
            if (row.column.size() >= 3 && row.column[0] == page)
            {
                if (row.column[1] == "title")
                {
                    continue;
                }
                else if (row.column[1] == "dd")
                {
                    continue;
                }
                else
                {
                    BlockProperties block;
                    block.title = row.column[1];
                    block.name = row.column[2];
                    return_value.push_back(block);
                }
            }
        }
        return return_value;
    }

    ListOfEvents ConfigurableBookmarks::getEventsForBlock(const std::string& block) const
    {
        auto return_value = ListOfEvents();
        for (const auto& row : archive.body)
        {
            if (row.column.size() >= 3 && row.column[0] == block)
            {
                Event event;
                event.url = row.column[1];
                event.name = row.column[2];
                return_value.add(event);
            }
        }
        return return_value;
    }
}
