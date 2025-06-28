
#include "topmenu.h"

namespace shob::pages
{
    html::rowContent topmenu::getMenu(const general::season& season) const
    {
        auto menu = html::rowContent();
        for (const auto& row : archive)
        {
            auto year = html::rowContent();
            year.data = { "bla bla" + row };
            menu.addContent(year);
        }
        return menu;
    };
}
