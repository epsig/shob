
#include "Season.h"
#include "shobException.h"

#include <boost/regex.hpp>
#include <format>

namespace shob::general
{
    std::string Season::toString() const
    {
        return toString('-');
    }

    std::string Season::toStringShort() const
    {
        const int yp1 = first_year + 1;
        return std::format("{:02}-{:02}", first_year % 100, yp1 % 100);
    }

    std::string Season::toPartFilename() const
    {
        return toString('_');
    }

    std::string Season::toString(const char separator) const
    {
        const int yp1 = first_year + 1;
        return std::to_string(first_year) + separator + std::to_string(yp1);
    }

    Season Season::findSeason(const std::string& text)
    {
        const char* pattern = "\\d{4}";

        const boost::regex re(pattern);

        boost::sregex_iterator it(text.begin(), text.end(), re);
        boost::sregex_iterator end;

        std::vector<int> parts;

        for (; it != end; ++it)
        {
            parts.push_back(std::stoi(it->str()));
        }

        if (parts.size() == 2 && parts[0] == parts[1]-1)
        {
            return { parts[0] };
        }

        throw shobException("season not found in: " + text);
    }

}
