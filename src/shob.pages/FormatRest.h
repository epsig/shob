#pragma once
#include "../shob.general/MultipleStrings.h"

namespace shob::pages
{
    enum class TechDocType
    {
        Klaverjas,
        Shob,
        Adressen,
    };

    class FormatRest
    {
    public:
        FormatRest(const std::string& data_folder) : data_folder(data_folder) {}
        void rebuildTechDoc(const TechDocType type, const int dd) const;
        general::MultipleStrings getTechDoc(const std::string& type_str, const TechDocType type, const int dd) const;
        /// <summary>
        /// Build the browser compatibility and HTML character reference page.
        /// </summary>
        general::MultipleStrings getLetters() const;
        void rebuildLetters() const;
        /// <summary>
        /// Build the HTML numeric character reference page for codes 30 through 259.
        /// </summary>
        general::MultipleStrings getAsciiCodes() const;
    private:
        std::string data_folder;
    };
}
