#include "../shob.klaverjas/KlaverjasTable.h"
#include "../shob.klaverjas/Versleutel.h"
#include "../shob.test.utils/testUtils.h"

#include <gtest/gtest.h>

namespace shob::klaverjas::test
{
    using namespace readers::test;

    TEST(KlaverjasTable, BuildsGraphicsTable)
    {
        const auto result = KlaverjasTable::kjTable("gfx");

        EXPECT_TRUE(result.starts_with("<table border cellspacing=\"0\" width=\"100%\">") );
        EXPECT_NE(std::string::npos, result.find("javascript:KiesTroef(3)\""));
        EXPECT_NE(std::string::npos, result.find("<form name=\"ShowKaartS\"><img"));
        EXPECT_NE(std::string::npos, result.find("javascript:SpeelDeze(7)"));
        EXPECT_EQ(std::string::npos, result.find("value=\"WWW\""));
    }

    TEST(KlaverjasTable, BuildsTextTable)
    {
        const auto result = KlaverjasTable::kjTable("txt");

        EXPECT_NE(std::string::npos, result.find("value=\" ? \""));
        EXPECT_NE(std::string::npos, result.find("<form name=\"ShowKaartS\"><input"));
        EXPECT_NE(std::string::npos, result.find("value=\"WWW\""));
        EXPECT_EQ(std::string::npos, result.find("include/wit.gif"));
    }

    TEST(Klaverjas, TestVersleutel)
    {
        const std::string relative_path = "../../code/Klaverjas/sleutels.txt";
        const std::string filename = testUtils::refFileWithPath(__FILE__, relative_path);

        auto result = Versleutel(0, filename);

        auto input = general::MultipleStrings();
        input.addContent("harten = 10");
        input.addContent("roem200");
        input.addContent("  klaveren vrouw  ");
        auto output = result.versleutelCode(input);

        ASSERT_EQ(output.data.size(), 3);
        EXPECT_EQ(output.data[0], "harten=10") << "check stripping spaces around =";
        EXPECT_EQ(output.data[1], "mJ") << "check roem200 encryption";
        EXPECT_EQ(output.data[2], "klaveren vrouw") << "check trimming spaces around klaveren vrouw";
    }
}