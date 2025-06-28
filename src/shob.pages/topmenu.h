
#pragma once

#include "../shob.html/table.h"
#include "../shob.general/season.h"
#include <string>
#include <vector>

namespace shob::pages
{
    class topmenu
    {
    public:
        topmenu(std::vector<std::string> archive) : archive(std::move(archive)) {}
        html::rowContent getMenu(const general::season& season) const;
    private:
        std::vector<std::string> archive;
    };
}

