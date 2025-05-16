

#include "testTopscorers.h"

#include <gtest/gtest.h>

#include "../shob.general.test/testUtils.h"

#include "../shob.football/topscorers.h"

#include "../shob.teams/clubTeams.h"

#include "../shob.readers/csvAllSeasonsReader.h"

namespace shob::football::test
{
    using namespace readers::test;

    const std::string eredivisie = "../../data/sport/eredivisie/topscorers_eredivisie.csv";
    const std::string filename = testUtils::refFileWithPath(__FILE__, eredivisie);
    const std::string clubs = "../../data/sport/clubs.csv";

    void testTopscorers::test1()
    {
        auto allTp = readers::csvAllSeasonsReader();
        allTp.init(filename);

        auto tp = topscorers(allTp);
        tp.initFromFile("2019-2020");

        auto settings = html::settings();
        auto reader = teams::clubTeams();
        const std::string filename2 = testUtils::refFileWithPath(__FILE__, clubs);

        reader.InitFromFile(filename2);
        auto table2 = tp.prepareTable(reader, settings);

        EXPECT_EQ(table2.body.size(), 2);
    }
}
