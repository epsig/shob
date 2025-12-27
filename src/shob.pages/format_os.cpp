
#include "format_os.h"
#include "../shob.html/updateIfNewer.h"

namespace shob::pages
{
    format_os::format_os(std::string folder, readers::csvAllSeasonsReader reader, readers::csvContent dames,
        readers::csvContent heren, topMenu menu, html::settings settings) :
        folder(std::move(folder)), seasons_reader(std::move(reader)),
        dames(std::move(dames)), heren(std::move(heren)), menu(std::move(menu)), settings(settings) {  }

    void format_os::get_pages_to_file(const int year, const std::string& filename) const
    {
        auto output = get_pages(year);
        html::updateIfDifferent::update(filename, output);
    }

    general::multipleStrings format_os::get_pages(const int year) const
    {
        auto retVal = general::multipleStrings();
        retVal.addContent("<hr> andere winterspelen: |");
        auto topMenu = menu.getMenu(std::to_string(year));
        retVal.addContent(topMenu);
        retVal.addContent("<hr>");

        return retVal;
    }

}
