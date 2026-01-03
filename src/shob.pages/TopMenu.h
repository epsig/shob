
#pragma once

#include "../shob.general/multipleStrings.h"
#include "../shob.general/Season.h"
#include <string>
#include <vector>

namespace shob::pages
{
    class TopMenu
    {
    public:
        TopMenu(std::vector<std::string> archive, const char id, const int maxUrls=10) :
            archive(std::move(archive)), max_urls(maxUrls), id(id) {}
        general::multipleStrings getMenu(const general::Season& season) const;
        general::multipleStrings getMenu(const std::string& year) const;
    private:
        std::vector<std::string> archive;
        const int max_urls;
        const char id;
        void shortenMenu(general::multipleStrings& menu, int curPos) const;
        void shortenMenuCenter(general::multipleStrings& menu, int curPos) const;
        void shortenMenuLeft(general::multipleStrings& menu) const;
        void shortenMenuRight(general::multipleStrings& menu) const;
        static void addEllipsis(general::multipleStrings& rows);
    };
}

