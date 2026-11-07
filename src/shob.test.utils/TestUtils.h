#pragma once
#include <string>

namespace shob::readers::test
{
    class TestUtils
    {
    public:
        static std::string refFileWithPath(const std::string& sourceFile, const std::string& relativePath);
    };
}
