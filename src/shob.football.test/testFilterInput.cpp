
#include "testFilterInput.h"

#include <gtest/gtest.h>

#include "../shob.football/filterInput.h"

namespace shob::football::test
{
    void testFilterInput::test1()
    {
        auto filter = filterInputList();
        filter.filters.push_back({ 0, "f" });

        auto hasFinale = filter.isFinale();
        EXPECT_TRUE(hasFinale);
    }

    void testFilterInput::test2()
    {
        auto filter = filterInputList();
        filter.filters.push_back({ 0, "f" });

        auto header = readers::csvColContent();
        header.column = { "f", "club1", "club2", "0-0" };

        auto isFinale = filter.checkLine(header);
        EXPECT_TRUE(isFinale);
    }

    void testFilterInput::test3()
    {
        auto filter = filterInputList();
        filter.filters.push_back({ 0, "2f" });

        auto hasFinale = filter.isFinale();
        EXPECT_FALSE(hasFinale);
    }

    void testFilterInput::test4()
    {
        auto filter = filterInputList();
        filter.filters.push_back({ 0, "2f" });

        auto header = readers::csvColContent();
        header.column = { "f", "club1", "club2", "0-0" };

        auto isFinale = filter.checkLine(header);
        EXPECT_FALSE(isFinale);
    }

}
