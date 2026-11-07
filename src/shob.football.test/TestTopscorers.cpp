#include "TestTopscorers.h"

#include <gtest/gtest.h>

#include "../shob.test.utils/TestUtils.h"

#include "../shob.football/Topscorers.h"

#include "../shob.teams/ClubTeams.h"

#include "../shob.readers/csvAllSeasonsReader.h"

namespace shob::football::test
{
    using namespace readers::test;

    const std::string eredivisie = "../../data/sport/eredivisie/topscorers_eredivisie.csv";
    const std::string filename = TestUtils::refFileWithPath(__FILE__, eredivisie);
    const std::string clubs = "../../data/sport/clubs.csv";
    const std::string voetballers = "../../data/sport/voetballers.csv";

    void TestTopscorers::test1()
    {
        auto allTp = readers::CsvAllSeasonsReader();
        allTp.init(filename);

        auto tp = Topscorers(allTp);
        tp.initFromFile(general::Season(2019));

        auto players = teams::Footballers();
        const std::string filename3 = TestUtils::refFileWithPath(__FILE__, voetballers);
        players.initFromFile(filename3);

        auto settings = html::Settings();
        auto reader = teams::ClubTeams();
        const std::string filename2 = TestUtils::refFileWithPath(__FILE__, clubs);

        reader.InitFromFile(filename2, teams::ClubsOrCountries::clubs);
        auto table2 = tp.prepareTable(reader, players, settings);

        EXPECT_EQ(table2.body.size(), 2);
    }
}
