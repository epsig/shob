
#pragma once
#include <string>
#include <unordered_map>

namespace shob::football
{
    struct leagueName
    {
        std::string fullName;
        std::string linkName;
        std::string shortName;
    };

    class leagueNames
    {
    public:
        leagueNames(const std::string& filename, const bool isCompatible = false);
        std::string getFullName(const std::string& id) const;
        std::string getLinkName(const std::string& id) const;
        std::string getShortName(const std::string& id) const;
        bool contains(const std::string& id) const;
    private:
        std::unordered_map<std::string, leagueName> data;
    };
}
