#include "../shob.klaverjas/KlaverjasTable.h"

#include <gtest/gtest.h>

namespace shob::klaverjas::test
{
    TEST(KlaverjasTable, BuildsGraphicsTable)
    {
        const auto result = kjTable("gfx");

        EXPECT_TRUE(result.starts_with("<table border cellspacing=\"0\" width=\"100%\">") );
        EXPECT_NE(std::string::npos, result.find("javascript:KiesTroef(3)\""));
        EXPECT_NE(std::string::npos, result.find("<form name=\"ShowKaartS\"><img"));
        EXPECT_NE(std::string::npos, result.find("javascript:SpeelDeze(7)"));
        EXPECT_EQ(std::string::npos, result.find("value=\"WWW\""));
    }

    TEST(KlaverjasTable, BuildsTextTable)
    {
        const auto result = kjTable("txt");

        EXPECT_NE(std::string::npos, result.find("value=\" ? \""));
        EXPECT_NE(std::string::npos, result.find("<form name=\"ShowKaartS\"><input"));
        EXPECT_NE(std::string::npos, result.find("value=\"WWW\""));
        EXPECT_EQ(std::string::npos, result.find("include/wit.gif"));
    }
}