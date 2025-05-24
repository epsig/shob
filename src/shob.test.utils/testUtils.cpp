#include "testUtils.h"

namespace shob::readers::test
{
    std::string testUtils::refFileWithPath(const std::string& sourceFile, const std::string& relativePath)
    {
        auto found = sourceFile.find_last_of("/\\");
        auto base = sourceFile.substr(0, found + 1);
        return base + relativePath;
    }
}
