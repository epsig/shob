#include "Versleutel.h"
#include "../shob.general/FileIO.h"
#include <utility>
#include <vector>
#include <boost/regex.hpp>
#include "../shob.readers/csvReader.h"
#include "../shob.general/shobException.h"

namespace shob::klaverjas
{
    using namespace shob::general;

    std::string Versleutel::escape_regex(const std::string & text)
    {
        static const std::string special = R"(\.^$|()[]{}*+?)";
        std::string escaped;
        for (char ch : text)
        {
            if (special.find(ch) != std::string::npos)
                escaped += '\\';
            escaped += ch;
        }
        return escaped;
    }

    void Versleutel::versleutel(std::string& text, const std::map<std::string, std::string>& lijst)
    {
        for (const auto& [key, value] : lijst)
        {
            // \b preserves the word-boundary check from Perl.
            const boost::regex pattern("\\b" + escape_regex(key) + "\\b");
            text = boost::regex_replace(
                text, pattern, value,
                boost::match_default | boost::regex_constants::format_literal);
        }
    }

    MultipleStrings Versleutel::versleutelCode(const MultipleStrings& input)
    {
        auto keys = FileIO::readFile(sleutels_path);
        if (keys.data.empty())
        {
            throw shobException("Sleutels file is empty or not found: " + sleutels_path);
        }

        auto keyMap = std::map<std::string, std::string>();
        for (const auto& line : keys.data) {
            auto delimiterPos = line.find(' ');
            if (delimiterPos != std::string::npos) {
                auto key = line.substr(0, delimiterPos);
                auto value = line.substr(delimiterPos + 1);
                keyMap[value] = key;
            }
        }

        MultipleStrings return_input;
        for (size_t i = 0; i < input.data.size(); ++i) {
            auto line = input.data[i];
            if (line.starts_with("//")) {
                continue; // Skip comment lines that start with "//"
            }
            else if (line.find("dbg") != std::string::npos) {
                continue; // Skip lines that contain "dbg"
            }
            else if (line.find("debug") != std::string::npos) {
                continue; // Skip lines that contain "debug"
            }
            if (line.find("'") == std::string::npos && line.find("http") == std::string::npos)
            {
                const auto pos = line.find("//");
                if (pos != std::string::npos) {
                    line = line.substr(0, pos); // Remove the comment part
                }
            }
            if (i > skip_header_lines)
            {
                line = readers::csvReader::trim(line, " ");
            }
            if (line.empty()) continue;
            return_input.data.push_back(line); // Copy each line to the new MultipleStrings object
        }

        for (size_t i = skip_header_lines; i < return_input.data.size(); ++i) {
            auto& line = return_input.data[i];
            versleutel(line, keyMap);
            line = readers::csvReader::trim(line, " ");
            if (line.find("'") != std::string::npos) continue;
            for (const std::string& token : { "+", "-", "=", "(", ")", "{", "}", "[", "]", ">", "<", ";", ",", "&", "!", "/", "|", "?", ":", "%", "*"}) {
                const boost::regex pattern( " *" + escape_regex(token) + " *");
                line = boost::regex_replace(
                    line, pattern, token,
                    boost::match_default | boost::regex_constants::format_literal);
            }
        }

        return return_input;
    }
}
