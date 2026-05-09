
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

}
