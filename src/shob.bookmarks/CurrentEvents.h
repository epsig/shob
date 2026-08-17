#pragma once
#include "../shob.general/MultipleStrings.h"

namespace shob::bookmarks
{
    class CurrentEvents
    {
    public:
        static general::MultipleStrings getCurrentBookmarks(const std::string& folder, const int dd);
    };
}
