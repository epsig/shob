#pragma once
#include "Event.h"
#include <vector>

namespace shob::bookmarks
{
    class CurrentEvents
    {
    public:
        static std::vector<Event> getCurrentBookmarks(const std::string& folder, const int dd);
    };
}
