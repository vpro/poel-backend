[#import "../macros/head.ftl" as headUtil]
[#import "../macros/footer.ftl" as footerUtil]
[#import "../macros/layout.ftl" as layout]
[#import "../macros/rounds.ftl" as roundUtil]
[#import "../macros/navigation.ftl" as navigationUtil]

<!DOCTYPE html>

<html lang="nl">

    [@headUtil.head title="Wedstrijden beheren" /]
    <body>


    [#if flash ? has_content]
    <div class="alert-overlay">
        <div class="alert-overlay__content">
        ${flash} <br/> <br/>
            <button class="h5 button alert-overlay__close-button">Ok!</button>
        </div>
    </div>
    [/#if]

    [@navigationUtil.navigation title='Admin' subtitle='wedstrijden'  bgColor='bg-darkred' back='/admin' /]

        <div class="grid main">

            [@layout.sectionWithLayout
                content={'layout': '100'}
                title='wedstrijden'
                backGroundColor="darkgreen"
            ]

                <form class="matches-form form" action="#" method="post">

                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="matches entities">
                    [#list matches]

                        [#items as match]
                            <div class="form-row match entity-admin row">

                                <!-- TODO: move this into a macro-->
                                <!-- or (even better) render this through match.hbs as we do when adding new matches -->
                                <!-- so this markup has a single source in stead of two -->

                                [#if match.matchResult ? has_content]
                                    [#assign hasMatchResult = true/]
                                [#else]
                                    [#assign hasMatchResult = false/]
                                [/#if]

                                [#assign roundId = -1]
                                [#if match.round ? has_content]
                                    [#assign roundId = match.round.id]
                                [/#if]

                                <input type="hidden" name="matches[${match?index}].id" value="${match.id}" />

                                <input type="text" class="col-12-2" name="matches[${match?index}].homeTeam" value="${match.homeTeam}" />
                                <input type="text" class="col-12-2" name="matches[${match?index}].awayTeam" value="${match.awayTeam}" />
                                <input type="datetime-local" class="col-12-3" name="matches[${match?index}].start" value="${match.start?string["yyyy-MM-dd'T'HH:mm"]}" />

                                <input type="number" class="col-12-1" name="matches[${match?index}].homeTeamGoals" [#if hasMatchResult]value="${match.matchResult.homeTeamGoals!}"[#else]placeholder="home"[/#if] />
                                <input type="number" class="col-12-1" name="matches[${match?index}].awayTeamGoals" [#if hasMatchResult]value="${match.matchResult.awayTeamGoals!}"[#else]placeholder="away"[/#if] />

                                [@roundUtil.roundSelection rounds=rounds formPath='matches[${match_index}].roundId' selectedRoundId=roundId addCss='col-12-2' /]

                                <span class="delete delete-match">
                                    <i class="glyph glyph-close c-gold col-12-1"></i>
                                </span>

                            </div>
                        [/#items]

                    [/#list]
                    </div>

                    <script id="roundSelection" type="text/template">
                        [@roundUtil.roundSelection rounds=rounds formPath='matches[{{@root.index}}].roundId' addCss='col-12-2' /]
                    </script>

                    <div class="form-button-container matches-form-button-container">

                        <input type="button" class="sort-matches sort-entities" value="Sorteren (datum)"/>

                        <input type="button" class="add-match add-entity" value="Toevoegen"/>

                        <input type="submit" value="Opslaan" />
                        <input type="reset" value="Annuleren (-achtig)" />

                    </div>

                </form>

            [/@layout.sectionWithLayout]

        </div>

    [@footerUtil.footer /]

    </body>

</html>