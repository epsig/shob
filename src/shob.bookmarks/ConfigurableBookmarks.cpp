#include "ConfigurableBookmarks.h"

namespace shob::bookmarks
{
    using namespace shob::readers;

    ConfigurableBookmarks::ConfigurableBookmarks(const std::string& folder)
    {
        archive = csvReader::readCsvFile(folder + "/archive.csv");
        config = csvReader::readCsvFile(folder + "/config.csv");
    }
}
