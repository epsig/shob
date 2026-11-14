#include "CommandLine.h"
#include "../shob.general/DateFactory.h"
#include "../shob.general/ShobException.h"

namespace shob::main
{
    void CommandLine::readCommandLine(int argc, char* argv[], int& yr1, int& yr2, bool& skip_kj)
    {
        using namespace shob::general;
        if (argc >= 3)
        {
            if (DateFactory::allDigits(argv[1]) && DateFactory::allDigits(argv[2]))
            {
                const std::string arg1 = argv[1];
                const std::string arg2 = argv[2];
                yr1 = std::stoi(arg1);
                yr2 = std::stoi(arg2);
                if (argc >= 4)
                {
                    skip_kj = (std::string(argv[3]) != "with_kj");
                }
            }
            else
            {
                throw ShobException("first two command line arguments must be years");
            }
        }
        else if (argc == 2)
        {
            if (DateFactory::allDigits(argv[1]))
            {
                const std::string arg1 = argv[1];
                yr1 = std::stoi(arg1);
                yr2 = yr1;
            }
            else
            {
                throw ShobException("first command line argument must be a year");
            }
        }
    }
}
