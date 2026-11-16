#include "HandleKlaverjasPages.h"
#include "../shob.pages/FormatKlaverjas.h"
#include "../shob.klaverjas/MergeJavaScript.h"

namespace shob::main
{
    using namespace shob::klaverjas;
    using namespace shob::pages;

    void  HandleKlaverjasPages::buildAllKJ(std::string& part, bool skip_kj)
    {
        part = "klaverjas";

        if (skip_kj)
        {
            return;
        }

        MergeJavaScript::mergeFiles("gfx");
        MergeJavaScript::mergeFiles("txt");
        auto fmt_klaverjas = FormatKlaverjas();
        for (const auto& location : { "adam", "rdam" })
        {
            for (const auto& type : { "gfx", "txt", "klein" })
            {
                fmt_klaverjas.rebuildKlaverjas(type, location);
            }
        }
        fmt_klaverjas.rebuildFaq();
    }
}
