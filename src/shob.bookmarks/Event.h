#pragma once
#include <string>

namespace shob::bookmarks
{
    class Event
    {
    public:
        std::string name;
        std::string url;
        std::string link() const;
    };
}
