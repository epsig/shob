
#pragma once
#include <string>
#include <map>
#include "../shob.readers/csvReader.h"

namespace shob::teams
{
    class clubTeams
    {
    public:
        void InitFromFile(const std::string& filename);
        std::string expand(const std::string& club) const;
    private:
        void Init(const readers::csvContent& data);
        std::map<std::string, std::string> clubs;
    };
}
