
#pragma once

#include <string>
#include <vector>

namespace shob::general
{
    /// <summary>
    /// class for storing unique strings in the order that they are given
    /// </summary>
    class uniqueStrings
    {
    public:
        void insert(const std::string& s);
        bool contains(const std::string& s) const;
        std::vector<std::string> list() const;
    private:
        std::vector<std::string> myset;
    };
}
