#pragma once
#include "ListOfEvents.h"

namespace shob::bookmarks
{
    class CurrentEvents
    {
    public:
        static ListOfEvents getCurrentBookmarks(const std::string& folder, const int dd);
        static std::string getMessageEmpty();
    };
}
