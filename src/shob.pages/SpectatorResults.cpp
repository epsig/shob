
#include "SpectatorResults.h"

namespace shob::pages
{
    void SpectatorResults::estimateSpectators(const size_t tableSize)
    {
        if (meanSpectatorsPerTeam.size() == tableSize)
        {
            double sum = 0.0;
            for (const auto& [fst, snd] : meanSpectatorsPerTeam)
            {
                sum += snd;
            }
            constexpr size_t one = 1;
            totalSpectators = static_cast<int>(sum * static_cast<double>(meanSpectatorsPerTeam.size() - one));
            meanSpectators = sum / static_cast<double>(meanSpectatorsPerTeam.size());
            estimateSpectatorsCurrentSeason = true;
        }
        else
        {
            totalSpectators = 0;
        }
    }

    void SpectatorResults::findExtremesValueInMap()
    {
        findExtremeValueInMap(1.0);
        findExtremeValueInMap(-1.0);
    }

    void SpectatorResults::findExtremeValueInMap(const double factor)
    {
        auto return_value = std::vector<std::pair<std::string, double>>();
        for (const auto& x : meanSpectatorsPerTeam)
        {
            if (return_value.empty() || return_value[0].second == x.second)  // NOLINT(clang-diagnostic-float-equal)
            {
                return_value.emplace_back(x);
            }
            else if (return_value[0].second * factor < x.second * factor)
            {
                return_value = { x };
            }

        }

        if (factor > 0.0)
        {
            teamsWithMostSpectators = return_value;
        }
        else
        {
            teamsWithLeastSpectators = return_value;
        }
    }

}
