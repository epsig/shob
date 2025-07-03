
#include "season.h"
#include "shobException.h"

#include <boost/regex.hpp>
#include <format>

namespace shob::general
{
    std::string season::to_string() const
    {
        return to_string('-');
    }

    std::string season::to_string_short() const
    {
        const int yp1 = firstYear + 1;
        return std::format("{:02}-{:02}", firstYear % 100, yp1 % 100);
    }

    std::string season::to_part_filename() const
    {
        return to_string('_');
    }

    std::string season::to_string(const char separator) const
    {
        const int yp1 = firstYear + 1;
        return std::to_string(firstYear) + separator + std::to_string(yp1);
    }

    season season::findSeason(const std::string& text)
    {
        const char* pattern = "\\d{4}";

        const boost::regex re(pattern);

        boost::sregex_iterator it(text.begin(), text.end(), re);
        boost::sregex_iterator end;

        std::vector<int> parts;

        for (; it != end; ++it)
        {
            parts.push_back(std::atoi(it->str().c_str()));
        }

        if (parts.size() == 2 && parts[0] == parts[1]-1)
        {
            return season(parts[0]);
        }

        throw shobException("season not found in: " + text);
    }

}
