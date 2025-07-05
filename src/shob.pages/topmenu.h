
#pragma once

#include "../shob.html/table.h"
#include "../shob.general/season.h"
#include <string>
#include <vector>

namespace shob::pages
{
    class topMenu
    {
    public:
        topMenu(std::vector<std::string> archive, const int maxUrls=10) :
            archive(std::move(archive)), maxUrls(maxUrls) {}
        html::rowContent getMenu(const general::season& season) const;
    private:
        std::vector<std::string> archive;
        const int maxUrls;
        void shortenMenu(html::rowContent& menu, int curPos) const;
        void shortenMenuLeft(html::rowContent& menu) const;
        void shortenMenuRight(html::rowContent& menu) const;
        static void addEllipsis(html::rowContent& rows);
    };
}

