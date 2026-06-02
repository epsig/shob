#pragma once

#include "FormatOnePageEachYear.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/settings.h"

namespace shob::pages
{
    class FormatEkWk : public FormatOnePageEachYear
    {
    public:
        FormatEkWk(std::string folder, const html::settings& settings, readers::csvAllSeasonsReader remarks, readers::csvAllSeasonsReader topScorers)
        : dataSportFolder(std::move(folder)), settings(settings), remarks(std::move(remarks)), topScorers(std::move(topScorers)) {}

        general::MultipleStrings getPages(const int year) const override;
        bool isValidYear(const int year) const override;
        std::string getOutputFilename(const std::string& folder, const int year) const override;
        std::string getOutputFilename(const std::string& folder) const override;
        int getLastYear() const override;
    private:
        std::string dataSportFolder;
        html::settings settings;
        readers::csvAllSeasonsReader remarks;
        readers::csvAllSeasonsReader topScorers;
    };
}
