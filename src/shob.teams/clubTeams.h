
#pragma once
#include <string>
#include <vector>
#include <map>

namespace shob::teams
{
    class clubTeams
    {
    public:
        void InitFromFile(const std::string& filename);
        std::string expand(const std::string& club) const;
    private:
        void Init(const std::vector<std::vector<std::string>>& data);
        std::map<std::string, std::string> clubs;
    };
}
