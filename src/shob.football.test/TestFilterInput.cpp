#include "TestFilterInput.h"

#include <gtest/gtest.h>

#include "../shob.football/FilterInput.h"

namespace shob::football::test
{
    void TestFilterInput::test1()
    {
        auto filter = FilterInputList();
        filter.filters.push_back({ 0, "f" });

        auto hasFinale = filter.isFinale();
        EXPECT_TRUE(hasFinale);
    }

    void TestFilterInput::test2()
    {
        auto filter = FilterInputList();
        filter.filters.push_back({ 0, "f" });

        auto header = readers::CsvColContent();
        header.column = { "f", "club1", "club2", "0-0" };

        auto isFinale = filter.checkLine(header);
        EXPECT_TRUE(isFinale);
    }

    void TestFilterInput::test3()
    {
        auto filter = FilterInputList();
        filter.filters.push_back({ 0, "2f" });

        auto hasFinale = filter.isFinale();
        EXPECT_FALSE(hasFinale);
    }

    void TestFilterInput::test4()
    {
        auto filter = FilterInputList();
        filter.filters.push_back({ 0, "2f" });

        auto header = readers::CsvColContent();
        header.column = { "f", "club1", "club2", "0-0" };

        auto isFinale = filter.checkLine(header);
        EXPECT_FALSE(isFinale);
    }

}
