#include "CurrentEvents.h"
#include "../shob.readers/csvReader.h"
#include "../shob.general/itdate.h"
#include "../shob.general/shobException.h"
#include <filesystem>
#include <vector>

namespace shob::bookmarks
{
    using namespace shob::general;
    using namespace shob::readers;
    namespace fs = std::filesystem;

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
            if (row.column.size() < 5)
            {
                throw shobException("Invalid row in current.csv, size: ", row.column.size());
            }

            std::vector<std::string> urls = { row.column[0] };
            if (!row.column[4].empty())
            {
                urls.push_back(row.column[4]);
            }

            std::string checked_url;
            bool found_valid_url = false;
            for (auto& url : urls)
            {
                const auto pos = url.find("YYYY");
                if (pos != std::string::npos)
                {
                    url.replace(pos, 4, std::to_string(year));
                    const auto isValidUrl = fs::exists("../pages/" + url);
                    if (isValidUrl)
                    {
                        checked_url = url;
                        found_valid_url = true;
                        break;
                    }
                }
                else
                {
                    checked_url = url;
                    found_valid_url = true;
                    break;
                }
            }

            if (!found_valid_url) continue; // Skip this event if no valid URL is found

            const auto row_date_begin = std::stod(row.column[2]);
            const auto row_date_end   = std::stod(row.column[3]);
            if (row_date_begin <= date_cmp && date_cmp <= row_date_end)
            {
                Event event;
                event.name = row.column[1];
                event.url = checked_url;
                return_value.add(event);
            }
        }
        return return_value;
    }

    std::string CurrentEvents::getMessageEmpty()
    {
        return "geen grote evenementen deze maand.";
    }
}
