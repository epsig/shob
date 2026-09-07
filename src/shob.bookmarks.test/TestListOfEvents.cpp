#include "TestListOfEvents.h"
#include "../shob.bookmarks/ListOfEvents.h"
#include <gtest/gtest.h>

namespace shob::bookmarks::test
{
    void TestListOfEvents::testEmpty()
    {
        const auto events = ListOfEvents();
        const auto result = events.printFirstAndLast();
        EXPECT_TRUE(result.data.empty());
    }

    void TestListOfEvents::testSingleEvent()
    {
        auto events = ListOfEvents();
        Event event;
        event.name = "Event";
        event.url = "https://example.test";
        events.add(event);

        const auto result = events.printFirstAndLast();
        ASSERT_EQ(result.data.size(), 1);
        EXPECT_EQ(result.data[0], "<a href=\"https://example.test\">Event</a>");
    }
}
