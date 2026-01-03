
#include "FormatUnOfficialStandings.h"
#include "../shob.html/updateIfNewer.h"

#include <iostream>

namespace shob::pages
{
    void FormatUnOfficialStandings::getPagesToFile(const int year, const std::string& filename) const
    {
        auto output = getPages(year);
        html::updateIfDifferent::update(filename, output);

    }

    void FormatUnOfficialStandings::getPagesStdout(const int year) const
    {
        const auto output = getPages(year);
        for (const auto& row : output.data)
        {
            std::cout << row << '\n';
        }
        std::cout.flush();
    }

    general::MultipleStrings FormatUnOfficialStandings::getPages(const int year) const
    {
        auto return_value = general::MultipleStrings();

        auto topMenu = menu1.getMenu(std::to_string(year), 29);
        return_value.addContent(topMenu);
        return_value.addContent("<hr>");

        return return_value;
    }
}

