[#import "macros/head.ftl" as headUtil]
[#import "macros/footer.ftl" as footerUtil]

[#import "macros/navigation.ftl" as navigationUtil]
[#import "macros/layout.ftl" as layout]

[#import "macros/message.ftl" as messageUtil]

<!DOCTYPE html>
<html lang="nl">

    [@headUtil.head title='Poelstand' /]

    <body>

    [@navigationUtil.navigation title='Poelstand' back='/' /]

    [@messageUtil.outputMessage message=message ! /]

    <div class="grid bg-darkgreen">
    [@layout.sectionWithLayout
    content={"layout":"100"}
    title='afdelingen'
    collapsible=true
    opened=false
    addCss='ranking-section'
    backGroundColor='greybat'
    closeColorClass='bg-greybat'
    openColorClass='bg-darkgreen'
    ]

        [#list userGroupRanking]
        <table class="ranking">
        <tbody>
            [#items as userGroupEntry]
        <tr class="ranking__row ranking__row-${ userGroupEntry ? item_parity } [#if user.userGroup ? has_content && userGroupEntry.userGroup.getId() == user.userGroup.getId() ]ranking__current-user[/#if]">
            <td class="ranking__rank"><span>${ userGroupEntry.rank }</span></td>
            <td class="ranking__name">
                <h2 class="h6 ranking__display-name">
                ${ userGroupEntry.userGroup.name }
                </h2>
            </td>
            <td class="ranking__score">${ userGroupEntry.score }</td>
        </tr>
        [/#items]
    </tbody>
    </table>
    [#else]
        Er zijn geen afdelingen. :o(
    [/#list]

    [/@layout.sectionWithLayout]
    </div>

    <div class="grid bg-darkgreen">
        [@layout.sectionWithLayout
            content={"layout":"100"}
            title='spelers'
            collapsible=true
            opened=true
            addCss='ranking-section'
            backGroundColor='greybat'
            closeColorClass='bg-greybat'
            openColorClass='bg-darkgreen'
        ]

            [#list ranking]
            <table class="ranking">
            <tbody>
                [#items as rankingEntry]
                <tr class="ranking__row ranking__row-${ rankingEntry ? item_parity } [#if rankingEntry.user.getId() == user.getId() ]ranking__current-user[/#if]">
                    <td class="ranking__rank"><span>${ rankingEntry.rank }</span></td>
                    <td class="ranking__name">
                        <h2 class="h6 ranking__display-name">
                            [#if rankingEntry.user.gameName ? has_content]
                            ${ rankingEntry.user.gameName }
                            [#else]
                            ${ rankingEntry.user.realName }
                            [/#if]
                        </h2>
                        <div class="ranking__meta">
                            <span class="ranking__full-name">
                                [#if rankingEntry.user.gameName ? has_content]
                                ${ rankingEntry.user.realName }
                                [#elseif rankingEntry.user.getId() == user.getId() ]
                                <a href="/user"><i> vul je voetbalnaam in op je profielpagina</i></a>
                                [/#if]
                            </span>
                            <span class="ranking__department">
                                [#if rankingEntry.user.userGroup ? has_content]
                                    ${ rankingEntry.user.userGroup.name }
                                [/#if]
                            </span>
                        </div>
                    </td>
                    <td class="ranking__score">${ rankingEntry.score }</td>
                </tr>
                [/#items]
            </tbody>
            </table>
            [#else]
            Er zijn geen deelnemers. :o(
            [/#list]

        [/@layout.sectionWithLayout]
    </div>

    [@footerUtil.footer /]
    </body>

</html>