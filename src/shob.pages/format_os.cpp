
#include "format_os.h"

namespace shob::pages
{
    format_os::format_os(std::string folder, readers::csvAllSeasonsReader reader, readers::csvContent dames,
        readers::csvContent heren, html::settings settings) :
        folder(std::move(folder)), seasons_reader(std::move(reader)),
        dames(std::move(dames)), heren(std::move(heren)), settings(settings) {  }

    void format_os::get_pages_to_file(const int year, const std::string& filename) const{}

}
