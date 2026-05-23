
#pragma once
#include <string>
#include <map>
#include "../shob.readers/csvReader.h"

namespace shob::teams
{
    class nationalTeams
    {
    public:
        void InitFromFile(const std::string& filename);
        std::string expand(const std::string& landcode) const;
        static std::string shortName(const std::string& land);
        bool contains(const std::string& landcode) const;
        std::map<std::string, std::string>::const_iterator find(const std::string& landcode) const
        {
            return countries.find(landcode);
        }
        std::map<std::string, std::string>::const_iterator end() const
        {
            return countries.end();
        }

        bool empty() const { return countries.empty(); }
    private:
        void Init(const readers::csvContent& data);
        std::map<std::string, std::string, std::less<>> countries;
    };
}
