
#pragma once

#include "../shob.general/MultipleStrings.h"
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
        general::MultipleStrings getMenu(const general::Season& season) const;
        general::MultipleStrings getMenu(const std::string& year) const;
    private:
        std::vector<std::string> archive;
        const int max_urls;
        const char id;
        void shortenMenu(general::MultipleStrings& menu, int curPos) const;
        void shortenMenuCenter(general::MultipleStrings& menu, int curPos) const;
        void shortenMenuLeft(general::MultipleStrings& menu) const;
        void shortenMenuRight(general::MultipleStrings& menu) const;
        static void addEllipsis(general::MultipleStrings& rows);
    };
}

