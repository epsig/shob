
#pragma once

#include "FormatOnePage.h"
#include "../shob.general/Season.h"
#include "../shob.general/MultipleStrings.h"

namespace shob::pages
{
    class FormatOnePageEachSeason : public FormatOnePage
    {
    public:
        virtual void getPagesToFile(const general::Season& season, const std::string& filename) const;
        virtual void getPagesStdout(const general::Season& season) const;
        virtual general::MultipleStrings getSeason(const general::Season& season) const = 0;
        virtual bool isValidSeason(const general::Season& season) const = 0;
        virtual std::string getOutputFilename(const std::string& folder, const general::Season& season) = 0;
        std::string getOutputFilename(const std::string& folder) const override = 0;
        virtual general::Season getLastSeason() const = 0;
        ~FormatOnePageEachSeason() override = default;
    };

}

