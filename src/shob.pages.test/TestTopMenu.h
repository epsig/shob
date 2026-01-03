
#pragma once
#include <string>
#include <vector>

namespace shob::pages::test
{
    class TestTopMenu
    {
    public:
        static void testLeft();
        static void testCenter();
        static void testRight();
    private:
        static std::vector<std::string> getArchive();
    };

}

