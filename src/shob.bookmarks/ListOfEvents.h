#pragma once
#include "Event.h"
#include "../shob.general/MultipleStrings.h"
#include <vector>

namespace shob::bookmarks
{
    class ListOfEvents
    {
    public:
        void add(const Event& event);
        size_t size() const { return events.size();}
        general::MultipleStrings printAll() const;
        general::MultipleStrings printFirstAndLast() const;
        general::MultipleStrings printAsFooterNewStyle() const;
        general::MultipleStrings printAsFooterOldStyle() const;
    private:
        std::vector<Event> events;
    };
}
