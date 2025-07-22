
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

    bool multipleStrings::areEqual(const multipleStrings& other) const
    {
        if (data.size() != other.data.size()) return false;
        for (int i = 0; i < static_cast<int>(data.size()); i++)
        {
            if (data[i] != other.data[i]) return false;
        }
        return true;
    }

    int multipleStrings::findString(const std::string& s) const
    {
        for (int i = 0; i < static_cast<int>(data.size()); i++)
        {
            if (data[i] != s) return i;
        }
        return -1;
    }

}
