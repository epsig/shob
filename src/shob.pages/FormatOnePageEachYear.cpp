
#include "FormatOnePageEachYear.h"
#include "../shob.html/updateIfNewer.h"

namespace shob::pages
{
    void FormatOnePageEachYear::getPagesToFile(const int year, const std::string& filename) const
    {
        auto output = getPages(year);
        html::updateIfDifferent::update(filename, output);
    }

    void FormatOnePageEachYear::getPagesStdout(const int year) const
    {
        const auto output = getPages(year);
        output.toStdout();
    }

}

