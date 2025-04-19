
#include "testXmlReader.h"

#include <gtest/gtest.h>

#include "../src/xmlReader.h"
#include "testUtils.h"

namespace shob::readers::test
{
    void testXmlReader::test1()
    {
        const std::string filename = testUtils::refFileWithPath(__FILE__,  "cats.xml");
        const auto cats = load(filename);
        EXPECT_EQ(9, cats.cats.size());
    }

    void testXmlReader::test2()
    {
        const std::string filename = testUtils::refFileWithPath(__FILE__, "../data/sport/ekwk/EK_1996.xml");
        const std::string  path = "games.group_phase.groupA.CH_NL.stats.chronological";
        const auto games = loadPairs(filename, path , "min");
        ASSERT_EQ(2, games.size());
        EXPECT_EQ(" 0-1 Jordi ", games[0].second);
        EXPECT_EQ("64", games[0].first);
        EXPECT_EQ(" 0-2 bergkamp ", games[1].second);
        EXPECT_EQ("79", games[1].first);
    }

}

