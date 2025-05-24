
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
        std::string expand(const std::string& landcode);
    private:
        void Init(const readers::csvContent& data);
        std::map<std::string, std::string> countries;
    };
}
