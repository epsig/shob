
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
        html::multipleStrings getMenu(const general::season& season) const;
    private:
        std::vector<std::string> archive;
        const int maxUrls;
        void shortenMenu(html::multipleStrings& menu, int curPos) const;
        void shortenMenuLeft(html::multipleStrings& menu) const;
        void shortenMenuRight(html::multipleStrings& menu) const;
        static void addEllipsis(html::multipleStrings& rows);
    };
}

