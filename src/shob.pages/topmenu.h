
#pragma once

#include "../shob.general/multipleStrings.h"
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
        general::multipleStrings getMenu(const general::season& season) const;
        general::multipleStrings getMenu(const std::string& year) const;
    private:
        std::vector<std::string> archive;
        const int maxUrls;
        void shortenMenu(general::multipleStrings& menu, int curPos) const;
        void shortenMenuCenter(general::multipleStrings& menu, int curPos) const;
        void shortenMenuLeft(general::multipleStrings& menu) const;
        void shortenMenuRight(general::multipleStrings& menu) const;
        static void addEllipsis(general::multipleStrings& rows);
    };
}

