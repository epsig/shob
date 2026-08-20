#include "Event.h"
#include <format>

namespace shob::bookmarks
{
    std::string Event::link() const
    {
        return std::format("<a href=\"{}\">{}</a>", url, name);
    }
}
