#pragma once
#include <string>
#include <vector>

namespace shob::general
{
    class multipleStrings
    {
    public:
        std::vector<std::string> data;
        void addContent(multipleStrings& extra);
        void addContent(std::string extra);
        bool areEqual(const multipleStrings& other) const;
    };
}
