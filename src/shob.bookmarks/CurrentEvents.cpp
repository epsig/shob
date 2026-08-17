#include "CurrentEvents.h"
#include "../shob.readers/csvReader.h"

namespace shob::bookmarks
{
    using namespace shob::general;
    using namespace shob::readers;

    MultipleStrings CurrentEvents::getCurrentBookmarks(const std::string& folder, const int dd)
    {
        auto reader = csvReader();
        auto content_file = reader.readCsvFile(folder + "/current.csv");
        return MultipleStrings();
    }
}
