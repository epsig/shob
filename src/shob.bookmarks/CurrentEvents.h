#pragma once
#include <vector>
#include <string>

namespace shob::bookmarks
{
    struct Event
    {
        std::string name;
        std::string url;
    };

    class CurrentEvents
    {
    public:
        static std::vector<Event> getCurrentBookmarks(const std::string& folder, const int dd);
    };
}
