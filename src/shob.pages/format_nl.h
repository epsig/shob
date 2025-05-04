
#pragma once
#include <string>
#include <vector>

namespace shob::pages
{
    class format_nl
    {
    public:
        format_nl(const std::string& folder) : sportDataFolder(folder) {}
        void get_season_stdout(const std::string& season) const;
        std::vector<std::string> get_season(const std::string& season) const;
    private:
        const std::string& sportDataFolder;
    };
}
