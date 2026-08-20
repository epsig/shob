#include "CurrentEvents.h"
#include "../shob.readers/csvReader.h"
#include "../shob.general/itdate.h"
#include "../shob.general/shobException.h"

namespace shob::bookmarks
{
    using namespace shob::general;
    using namespace shob::readers;

    ListOfEvents CurrentEvents::getCurrentBookmarks(const std::string& folder, const int dd)
    {
        const auto date = itdate(dd);
        size_t year; size_t month; size_t day;
        if (!date.splitAndValidate(year, month, day))
        {
            throw shobException("Invalid date: " + std::to_string(dd));
        }
        const double date_cmp = static_cast<double>(month) + static_cast<double>(day) / 30.0;
        const auto content_file = csvReader::readCsvFile(folder + "/current.csv");

        auto return_value = ListOfEvents();
        for (const auto& row : content_file.body)
        {
            if (row.column.size() < 4)
            {
                throw shobException("Invalid row in current.csv, size: ", row.column.size());
            }
            const auto row_date_begin = std::stod(row.column[2]);
            const auto row_date_end   = std::stod(row.column[3]);
            if (row_date_begin <= date_cmp && date_cmp <= row_date_end)
            {
                Event event;
                event.name = row.column[1];
                event.url = row.column[0];
                return_value.add(event);
            }
        }
        return return_value;
    }
}
