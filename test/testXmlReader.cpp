
#include "testXmlReader.h"

#include <gtest/gtest.h>

#include "../src/xmlReader.h"
#include "testUtils.h"

namespace shob::readers::test
{
    void testXmlReader::test1()
    {
        const std::string filename = testUtils::refFileWithPath(__FILE__,  "cats.xml");
        auto cats = load(filename);
        EXPECT_EQ(9, cats.cats.size());
    }

    void testXmlReader::test2()
    {
        const std::string filename = testUtils::refFileWithPath(__FILE__, "../data/sport/ekwk/EK_1996.xml");
        auto game = loadChronological(filename);
        EXPECT_EQ(2, game.data.size());
    }

}

