#include "ListOfEvents.h"
#include <format>

namespace shob::bookmarks
{
    using namespace shob::general;

    void ListOfEvents::add(const Event& event)
    {
        events.push_back(event);
    }

    MultipleStrings ListOfEvents::printAll() const
    {
        MultipleStrings return_value;
        for (const auto& e : events)
        {
            return_value.addContent(e.link());
        }
        return return_value;
    }

    MultipleStrings ListOfEvents::printFirstAndLast() const
    {
        MultipleStrings return_value;
        return_value.addContent(events.front().link());
        return_value.addContent(events.back().link());
        return return_value;
    }
}
