#pragma once
#include <string>
#include <vector>

namespace shob::general
{
    class MultipleStrings
    {
    public:
        std::vector<std::string> data;

        /// <summary>
        /// add content by moving the strings
        /// </summary>
        /// <param name="extra"> content to be added </param>
        void addContent(MultipleStrings& extra);
        void addContent(std::string extra);
        bool areEqual(const MultipleStrings& other) const;
        int findString(const std::string& s) const;
        size_t length() const;
        std::string toString() const;
    };
}
