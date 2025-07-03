
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
        const int maxUrls = 10;
    private:
        std::vector<std::string> archive;
        void shortenMenu(html::rowContent& menu, int curPos) const;
        void shortenMenuLeft(html::rowContent& menu) const;
        void shortenMenuRight(html::rowContent& menu) const;
    };
}

