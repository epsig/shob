#pragma once
#include <string>
#include <unordered_map>
#include <vector>
#include "../shob.football/results2standings.h"

namespace shob::pages
{
    class SpectatorResults
    {
    public:
        double meanSpectators = 0.0;
        std::vector<football::FootballMatch> mostSpectators;
        std::vector<football::FootballMatch> leastSpectators;
        std::vector<std::pair<std::string, double>> teamsWithMostSpectators;
        std::vector<std::pair<std::string, double>> teamsWithLeastSpectators;
        std::unordered_map<std::string, double> meanSpectatorsPerTeam;
        bool estimateSpectatorsCurrentSeason = false;
        int totalSpectators = 0;
        void estimateSpectators(size_t tableSize);
        void findExtremesValueInMap();
    private:
        void findExtremeValueInMap(const double factor);
    };
}
