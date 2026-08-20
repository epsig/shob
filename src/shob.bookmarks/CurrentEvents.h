#pragma once
#include "ListOfEvents.h"
#include <vector>

namespace shob::bookmarks
{
    class CurrentEvents
    {
    public:
        static ListOfEvents getCurrentBookmarks(const std::string& folder, const int dd);
    };
}
