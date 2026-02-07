
#include "FormatOnePageEachSeason.h"
#include "../shob.html/updateIfNewer.h"

namespace shob::pages
{
    void FormatOnePageEachSeason::getPagesToFile(const general::Season& season, const std::string& filename) const
    {
        auto output = getSeason(season);
        html::updateIfDifferent::update(filename, output);
    }

    void FormatOnePageEachSeason::getPagesStdout(const general::Season& season) const
    {
        const auto output = getSeason(season);
        output.toStdout();
    }

}
