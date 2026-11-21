#include "HandleRemainingPages.h"
#include "../shob.pages/FormatRest.h"

namespace shob::main
{
    using namespace shob::pages;

    void HandleRemainingPages::buildAllRemaining(std::string& part, int dd)
    {
        part = "rest";
        auto fmt_rest = FormatRest("doc/");
        fmt_rest.rebuildTechDoc(TechDocType::Klaverjas, 20261023);
        fmt_rest.rebuildTechDoc(TechDocType::Shob, 20261023);
        fmt_rest.rebuildLetters();
        fmt_rest.rebuildAsciiCodes();
        fmt_rest.rebuildEpsig(20261023);
        fmt_rest = FormatRest("./Data_stats_website/");
        fmt_rest.rebuildStats(dd);
    }
}
