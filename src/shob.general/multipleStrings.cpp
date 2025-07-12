
#include "multipleStrings.h"

namespace shob::general
{
    void multipleStrings::addContent(multipleStrings& extra)
    {
        for (auto& r : extra.data)
        {
            data.emplace_back(std::move(r));
        }
    }

    void multipleStrings::addContent(std::string extra)
    {
        data.emplace_back(std::move(extra));
    }
}
