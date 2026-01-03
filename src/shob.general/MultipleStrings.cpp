
#include "MultipleStrings.h"

namespace shob::general
{
    void MultipleStrings::addContent(MultipleStrings& extra)
    {
        for (auto& r : extra.data)
        {
            data.emplace_back(std::move(r));
        }
        extra.data.clear();
    }

    void MultipleStrings::addContent(std::string extra)
    {
        data.emplace_back(std::move(extra));
    }

    size_t MultipleStrings::length() const
    {
        size_t length = 0;
        for (auto& r : data)
        {
            length += r.size();
        }
        return length;
    }

    std::string MultipleStrings::toString() const
    {
        std::string result;
        for (auto& r : data)
        {
            result += r + "\n";
        }
        return result;
    }

    bool MultipleStrings::areEqual(const MultipleStrings& other) const
    {
        if (data.size() != other.data.size())
        {
            if (length() + data.size() == other.length() + other.data.size())
            {
                // this comparison always works but is quite expensive
                return toString() == other.toString();
            }
            return false;
        }
        for (int i = 0; i < static_cast<int>(data.size()); i++)
        {
            if (data[i] != other.data[i]) return false;
        }
        return true;
    }

    int MultipleStrings::findString(const std::string& s) const
    {
        for (int i = 0; i < static_cast<int>(data.size()); i++)
        {
            if (data[i].find(s) != std::string::npos) return i;
        }
        return -1;
    }

}
