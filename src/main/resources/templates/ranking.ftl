[#import "macros/head.ftl" as headUtil]
[#import "macros/navigation.ftl" as navigationUtil]

<!DOCTYPE html>
<html lang="nl">

[@headUtil.head title='De Stand' /]
<body>
[@navigationUtil.navigation /]

<div class="grid">
    Todo:<br/>
    Standaard ranking van alle spelers met highlight van current user <br/>
    Ranking van de afdelingenen / gebruikersgroepen<br/>
</div>

<section>
    <div class="grid">
        <h1 class="h5">Individueel Klassement</h1>
    </div>
    <div class="grid">

    [#list users]
        <table class="ranking">
            <thead>
            <tr>
                <th>Naam</th>
                <th>Score</th>
            </tr>
            </thead>
            <tbody>
            [#items as u]
                <tr [#if u.getId() == user.getId() ]class="ranking__current-user"[/#if]>
                    <td>${ u.displayName }</td><td>0</td>
                </tr>
            [/#items]
            </tbody>
        </table>
    [#else]
        Er zijn geen deelnemers. :o(
    [/#list]


    </div>
</section>


</body>

</html>