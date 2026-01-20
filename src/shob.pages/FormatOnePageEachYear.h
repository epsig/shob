
#pragma once

#include "FormatOnePage.h"
#include "../shob.general/MultipleStrings.h"

namespace shob::pages
{
    class FormatOnePageEachYear : public FormatOnePage
    {
    public:
        virtual void getPagesToFile(const int year, const std::string& filename) const;
        virtual void getPagesStdout(const int year) const;
        virtual general::MultipleStrings getPages(const int year) const = 0;
        virtual bool isValidYear(const int year) const = 0;
        virtual std::string getOutputFilename(const std::string& folder, const int year) const = 0;
        std::string getOutputFilename(const std::string& folder) const override = 0;
        //virtual int getLastYear() const = 0;
        ~FormatOnePageEachYear() override = default;
    };

}

