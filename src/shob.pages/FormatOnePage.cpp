
#include "FormatOnePage.h"
#include <algorithm>

namespace shob::pages
{

    bool cmpFunc(const std::string& a, const std::string& b)
    {
        return a < b;
    }

    void FormatOnePage::sortArchive(std::vector<std::string>& archive)
    {
        std::sort(archive.begin(), archive.end(), cmpFunc);
    }


}
