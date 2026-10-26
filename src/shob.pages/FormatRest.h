#pragma once
#include "../shob.general/MultipleStrings.h"

namespace shob::pages
{
    enum class TechDocType
    {
        Klaverjas,
        Shob,
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
        void rebuildAsciiCodes() const;
        general::MultipleStrings getEpsig(const int dd) const;
        void rebuildEpsig(const int dd) const;
        /// <summary>
        /// Build website statistics through the year of dd, reading data_folder as the statistics directory.
        /// </summary>
        general::MultipleStrings getStats(const int dd) const;
        void rebuildStats(const int dd) const;

    private:
        std::string data_folder;
    };
}
