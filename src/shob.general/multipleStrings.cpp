
#include "multipleStrings.h"

namespace shob::general
{
    void multipleStrings::addContent(multipleStrings& extra)
    {
        for (auto& r : extra.data)
        {
            data.emplace_back(std::move(r));
        }
        extra.data.clear();
    }

    void multipleStrings::addContent(std::string extra)
    {
        data.emplace_back(std::move(extra));
    }

    size_t multipleStrings::length() const
    {
        size_t length = 0;
        for (auto& r : data)
        {
            length += r.size();
        }
        return length;
    }

    std::string multipleStrings::to_string() const
    {
        std::string result;
        for (auto& r : data)
        {
            result += r + "\n";
        }
        return result;
    }

    bool multipleStrings::areEqual(const multipleStrings& other) const
    {
        if (data.size() != other.data.size())
        {
            if (length() + data.size() == other.length() + other.data.size())
            {
                // this comparison always works but is quite expensive
                return to_string() == other.to_string();
            }
            return false;
        }
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
